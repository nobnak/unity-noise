#ifndef __NOISE_SHADER_GRAPH_CGINC__
#define __NOISE_SHADER_GRAPH_CGINC__

#include "noise2D.cginc"
#include "noise3D.cginc"
#include "noise3Dgrad.cginc"
#include "noise4D.cginc"

#define SATURATE(v) clamp(v, -1, 1)
#define unlerp(a, b, v) (v - a) / (b - a)

float SNoise_float(float2 uv, uint octaves, float atten, out float v) {
	float wsum = 0;
	float w = 1;
	float freq = 1;
	v = 0;

	for (uint i = 0; i < octaves; i++) {
		v += w * SATURATE(snoise(uv * freq));

		wsum += w;
		w *= atten;
		freq *= 2;
	}
	v /= wsum;
}
float SNoise_float(float3 uv, uint octaves, float atten, out float v) {
	float wsum = 0;
	float w = 1;
	float freq = 1;
	v = 0;

	for (uint i = 0; i < octaves; i++) {
		v += w * SATURATE(snoise(uv * freq));

		wsum += w;
		w *= atten;
		freq *= 2;
	}
	v /= wsum;
}
void SNoise_float(float4 uv, uint octaves, float atten, out float v) {
	float wsum = 0;
	float w = 1;
	float freq = 1;
	v = 0;

	for (uint i = 0; i < octaves; i++) {
		v += w * SATURATE(snoise(uv * freq));

		wsum += w;
		w *= atten;
		freq *= 2;
	}
	v /= wsum;
}

#endif
