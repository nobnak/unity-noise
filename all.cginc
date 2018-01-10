#ifndef __NOISE_ALL_CGINC__
#define __NOISE_ALL_CGINC__

#include "cellular2D.cginc"
#include "cellular2x2.cginc"
#include "cellular2x2x2.cginc"
#include "cellular3D.cginc"

#include "classicnoise2D.cginc"
#include "classicnoise3D.cginc"
#include "classicnoise4D.cginc"

#include "noise2D.cginc"
#include "noise3D.cginc"
#include "noise3Dgrad.cginc"
#include "noise4D.cginc"

#include "psrdnoise2D.cginc"



float SNoise(float2 uv, uint octaves, float atten) {
	float wsum = 0;
	float w = 1;
	float freq = 1;
	float v = 0;

	[loop]
	for (uint i = 0; i < octaves; i++) {
		v += w * snoise(uv * freq);

		wsum += w;
		w *= atten;
		freq *= 2;
	}
	return v / wsum;
}
float SNoise(float3 uv, uint octaves, float atten) {
	float wsum = 0;
	float w = 1;
	float freq = 1;
	float v = 0;

	[loop]
	for (uint i = 0; i < octaves; i++) {
		v += w * snoise(uv * freq);

		wsum += w;
		w *= atten;
		freq *= 2;
	}
	return v / wsum;
}


#endif
