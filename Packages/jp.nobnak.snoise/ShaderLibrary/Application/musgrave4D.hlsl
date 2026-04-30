#ifndef __MUSGRAVE_4D__
#define __MUSGRAVE_4D__

// Shader Graph: Musgrave4D_float(..., out float Out, out float outUpper, out float outLower)

#include "../noise4D.hlsl"

#define MUSGRAVE_COORD_T float4
#define MUSGRAVE_SAMPLE(p) snoise(p)
#include "musgrave_impl.hlsl"
#undef MUSGRAVE_SAMPLE
#undef MUSGRAVE_COORD_T

void Musgrave4D_float(float4 In, float Scale, float Detail, float Dimension, float Lacunarity, float Type, out float Out, out float outUpper, out float outLower)
{
	MusgraveNoise_Simplex(In, Scale, Detail, Dimension, Lacunarity, (int)Type, Out, outUpper, outLower);
}

void Musgrave4D_half(float4 In, half Scale, half Detail, half Dimension, half Lacunarity, half Type, out half Out, out half outUpper, out half outLower)
{
	float o, hi, lo;
	MusgraveNoise_Simplex(In, (float)Scale, (float)Detail, (float)Dimension, (float)Lacunarity, (int)Type, o, hi, lo);
	Out = (half)o;
	outUpper = (half)hi;
	outLower = (half)lo;
}

#endif
