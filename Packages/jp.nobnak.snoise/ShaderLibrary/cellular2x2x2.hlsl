#ifndef __CELLULAR_2x2x2__
#define __CELLULAR_2x2x2__

// Cellular noise ("Worley noise") in 3D in GLSL.
// Copyright (c) Stefan Gustavson 2011-04-19. All rights reserved.
// This code is released under the conditions of the MIT license.
// See LICENSE file for details.
// https://github.com/stegu/webgl-noise

#include "common.hlsl"

// Cellular noise, returning F1 and F2 in a float2.
// Speeded up by using 2x2x2 search window instead of 3x3x3,
// at the expense of some pattern artifacts.
// F2 is often wrong and has sharp discontinuities.
// If you need a good F2, use the slower 3x3x3 version.
float2 cellular2x2x2(float3 P) {
    static float K = 0.142857142857; // 1/7
    static float Ko = 0.428571428571; // 1/2-K/2
    static float K2 = 0.020408163265306; // 1/(7*7)
    static float Kz = 0.166666666667; // 1/6
    static float Kzo = 0.416666666667; // 1/2-1/6*2
    static float jitter = 0.8; // smaller jitter gives less errors in F2
	float3 Pi = mod289(floor(P));
 	float3 Pf = frac(P);
	float4 Pfx = Pf.x + float4(0.0, -1.0, 0.0, -1.0);
	float4 Pfy = Pf.y + float4(0.0, 0.0, -1.0, -1.0);
	float4 p = permute(Pi.x + float4(0.0, 1.0, 0.0, 1.0));
	p = permute(p + Pi.y + float4(0.0, 0.0, 1.0, 1.0));
	float4 p1 = permute(p + Pi.z); // z+0
	float4 p2 = permute(p + Pi.z + 1.0); // z+1
	float4 ox1 = frac(p1*K) - Ko;
	float4 oy1 = mod7(floor(p1*K))*K - Ko;
	float4 oz1 = floor(p1*K2)*Kz - Kzo; // p1 < 289 guaranteed
	float4 ox2 = frac(p2*K) - Ko;
	float4 oy2 = mod7(floor(p2*K))*K - Ko;
	float4 oz2 = floor(p2*K2)*Kz - Kzo;
	float4 dx1 = Pfx + jitter*ox1;
	float4 dy1 = Pfy + jitter*oy1;
	float4 dz1 = Pf.z + jitter*oz1;
	float4 dx2 = Pfx + jitter*ox2;
	float4 dy2 = Pfy + jitter*oy2;
	float4 dz2 = Pf.z - 1.0 + jitter*oz2;
	float4 d1 = dx1 * dx1 + dy1 * dy1 + dz1 * dz1; // z+0
	float4 d2 = dx2 * dx2 + dy2 * dy2 + dz2 * dz2; // z+1

	// Sort out the two smallest distances (F1, F2)
#if 0
	// Cheat and sort out only F1
	d1 = min(d1, d2);
	d1.xy = min(d1.xy, d1.wz);
	d1.x = min(d1.x, d1.y);
	return float2(sqrt(d1.x));
#else
	// Do it right and sort out both F1 and F2
	float4 d = min(d1,d2); // F1 is now in d
	d2 = max(d1,d2); // Make sure we keep all candidates for F2
	d.xy = (d.x < d.y) ? d.xy : d.yx; // Swap smallest to d.x
	d.xz = (d.x < d.z) ? d.xz : d.zx;
	d.xw = (d.x < d.w) ? d.xw : d.wx; // F1 is now in d.x
	d.yzw = min(d.yzw, d2.yzw); // F2 now not in d2.yzw
	d.y = min(d.y, d.z); // nor in d.z
	d.y = min(d.y, d.w); // nor in d.w
	d.y = min(d.y, d2.x); // F2 is now in d.y
	return sqrt(d.xy); // F1 and F2
#endif
}

void cellular2x2x2_float(float3 In, out float2 Out) {
	Out = cellular2x2x2(In);
}

#endif