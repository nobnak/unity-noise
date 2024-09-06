/*
 * Web demos for GLSL procedural noise. The shaders are loaded over
 * the network from the glsl files in this repository and displayed with
 * various effects added.
 *
 * This code is in the public domain.
 */

'use strict';

// The shader will be assembled from
//  * a noise source file (e.g. noise3D.glsl)
//  * a glue function "color" that takes only a vec and returns a float
//  * an effect (one of EFFECTS) that assign to a float 'n'
//  * a shadertoy-compatible wrapper

const EFFECTS = {
    '2d': {
        plain: `
    float n = color(xyz.xy * 4.0);
`,

        fbm: `
    vec2 step = vec2(1.3, 1.7);
    float n = color(xyz.xy);
    n += 0.5 * color(xyz.xy * 2.0 - step);
    n += 0.25 * color(xyz.xy * 4.0 - 2.0 * step);
    n += 0.125 * color(xyz.xy * 8.0 - 3.0 * step);
    n += 0.0625 * color(xyz.xy * 16.0 - 4.0 * step);
    n += 0.03125 * color(xyz.xy * 32.0 - 5.0 * step);
`,
    },
    
    '3d': {
        plain: `
    float n = color(xyz * 4.0);
`,

        fbm: `
    vec3 step = vec3(1.3, 1.7, 2.1);
    float n = color(xyz);
    n += 0.5 * color(xyz * 2.0 - step);
    n += 0.25 * color(xyz * 4.0 - 2.0 * step);
    n += 0.125 * color(xyz * 8.0 - 3.0 * step);
    n += 0.0625 * color(xyz * 16.0 - 4.0 * step);
    n += 0.03125 * color(xyz * 32.0 - 5.0 * step);
`,
    },
};


/**
 * Create and compile a GL shader.
 * @param {WebGLRenderingContext} gl - webgl context
 * @param {GLEnum} type - gl.VERTEX_SHADER | gl.FRAGMENT_SHADER
 * @param {string} glsl
 * @returns {} shader
 */
function createGlShader(gl, type, glsl) {
    let shader = gl.createShader(type);
    gl.shaderSource(shader, glsl);
    gl.compileShader(shader);
    if (!gl.getShaderParameter(shader, gl.COMPILE_STATUS)) {
        console.log(gl.getShaderInfoLog(shader));
        gl.deleteShader(shader);
        return;
    }
    return shader;
}

/**
 * Construct a shadertoy-compatible shader program
 * @param {"2d" | "3d"} shape - whether to use xy or xyz
 * @param {string} sourceFile - url with the fragment shader to load
 * @param {string} glueFrag - a glsl expression to generate a color
 */
async function createFragShader(shape, sourceFile, glueFrag, effect) {
    let noiseFrag = await fetch(`../src/${sourceFile}`);
    noiseFrag = await noiseFrag.text();
    noiseFrag = noiseFrag.replace('#version 120', '', noiseFrag);

    let reshapeFrag;
    if (shape === '3d') {
        reshapeFrag = `
    float z_squared = 1.0 - length(p.xy);
    if (z_squared < 0.0) { fragColor = vec4(0, 0, 0, 1); return; }
    vec3 xyz = vec3(p, -sqrt(z_squared));
${EFFECTS[shape][effect]}
    fragColor.xyz = mix(0.0, 0.5 + 0.5 * n, smoothstep(0.0, 0.003, z_squared)) * vec3(1, 1, 1);
`;
    } else {
        reshapeFrag = `
    vec3 xyz = vec3(p, 0);
${EFFECTS[shape][effect]}
    fragColor.xyz = vec3(0.5 + 0.5 * vec3(n, n, n));
`;
    }
    
    return `${noiseFrag}
// demo code:
float color(${shape === '3d'? 'vec3 xyz' : 'vec2 xy'}) { return ${glueFrag}; }
void mainImage(out vec4 fragColor, in vec2 fragCoord) {
    vec2 p = (fragCoord.xy/iResolution.y) * 2.0 - 1.0;
${reshapeFrag}
}`;

}

/**
 * Draw a webgl diagram
 * @param {string} selector - a css selector for the target canvas
 * @param {"2d" | "3d"} shape - whether to use xy or xyz
 * @param {string} sourceFile - url with the fragment shader to load
 * @param {string} glueFrag - a glsl expression to generate a color
 * @param {"plain" | "fbm"} effect - one octave or many
 * @param {boolean} animate - whether to redraw every frame
 */
async function Diagram(selector, shape, sourceFile, glueFrag, effect, animate) {
    let shadertoyFrag = await createFragShader(shape, sourceFile, glueFrag, effect);
    let frag = `
        precision highp float;  // medium sufficient on desktop, high needed on mobile
        uniform float iTime;
        uniform vec2 iResolution;
        uniform vec2 per;
        
        ${shadertoyFrag}

        void main() {
           mainImage(gl_FragColor, gl_FragCoord.xy);
           gl_FragColor.a = 1.0;
        }`;
    
    let vert = `
        precision highp float;
        attribute vec2 a_position;
        void main () {
            gl_Position = vec4(a_position, 0, 1);
        }`;
    
    const canvas = document.querySelector(selector);
    const gl = /** @type{WebGLRenderingContext} */ (canvas.getContext('webgl'));
    let canvasSize = {w: canvas.clientWidth, h: canvas.clientHeight};
    canvas.width = gl.viewportWidth = canvasSize.w | 0;
    canvas.height = gl.viewportHeight = canvasSize.h | 0;

    let vertShader = createGlShader(gl, gl.VERTEX_SHADER, vert);
    let fragShader = createGlShader(gl, gl.FRAGMENT_SHADER, frag);
    let program = gl.createProgram();
    gl.attachShader(program, vertShader);
    gl.attachShader(program, fragShader);
    gl.linkProgram(program);
    if (!gl.getProgramParameter(program, gl.LINK_STATUS)) {
        console.log(gl.getProgramInfoLog(program));
        gl.deleteProgram(program);
        return;
    }

    let locations = {
        a_position: gl.getAttribLocation(program, 'a_position'),
        iTime: gl.getUniformLocation(program, 'iTime'),
        iResolution: gl.getUniformLocation(program, 'iResolution'),
        per: gl.getUniformLocation(program, 'per'),
    };

    let positionBuffer = gl.createBuffer();
    gl.bindBuffer(gl.ARRAY_BUFFER, positionBuffer);
    gl.bufferData(gl.ARRAY_BUFFER, new Float32Array([-4, -4, +4, -4, 0, +4]), gl.STATIC_DRAW);

    const startTime = Date.now();
    let sliders = {};
    let changed = true;

    function draw() {
        if (animate || changed) {
            changed = false;
            
            gl.viewport(0, 0, gl.viewportWidth, gl.viewportHeight);
            gl.clearColor(1, 0, 1, 1);
            gl.clear(gl.COLOR_BUFFER_BIT);

            gl.useProgram(program);
            
            gl.bindBuffer(gl.ARRAY_BUFFER, positionBuffer);
            gl.vertexAttribPointer(locations.a_position, 2, gl.FLOAT, false, 0, 0);
            gl.enableVertexAttribArray(locations.a_position);

            gl.uniform1f(locations.iTime, (Date.now() - startTime) * 1e-3);
            gl.uniform2f(locations.iResolution, gl.viewportWidth, gl.viewportHeight);
            gl.uniform2f(locations.per,
                         sliders?.per_x?.valueAsNumber ?? 1.0,
                         sliders?.per_y?.valueAsNumber ?? 1.0);

            gl.drawArrays(gl.TRIANGLES, 0, 3);
        }
        requestAnimationFrame(draw);
    }
    
    // Set up event listeners on sliders to trigger redraw
    for (let slider of document.querySelectorAll("input[type=range]")) {
        sliders[slider.getAttribute("id")] = slider;
        slider.addEventListener('input', () => { changed = true; });
    }

    // Click on the diagram to see a shadertoy version
    canvas.addEventListener('click', () => {
        document.querySelector("textarea").value = shadertoyFrag;
    });
    
    // Redraw loop will run forever
    draw();
}
