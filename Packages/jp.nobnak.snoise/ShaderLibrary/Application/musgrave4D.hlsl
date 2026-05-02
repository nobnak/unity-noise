#ifndef __MUSGRAVE_4D__
#define __MUSGRAVE_4D__

// Shader Graph: Musgrave4D_float(..., out float Out, out float outUpper, out float outLower)

#include "../noise4D.hlsl"
#include "musgrave_impl.hlsl"
MUSGRAVE_EXPAND_SIMPLEX(MusgraveNoise_Simplex_4, float4)

void Musgrave4D_float(float4 In, float Scale, float Detail, float Dimension, float Lacunarity, float Type, out float Out, out float outUpper, out float outLower)
{
	MusgraveNoise_Simplex_4(In, Scale, Detail, Dimension, Lacunarity, (int)Type, Out, outUpper, outLower);
}

void Musgrave4D_half(float4 In, half Scale, half Detail, half Dimension, half Lacunarity, half Type, out half Out, out half outUpper, out half outLower)
{
	float o, hi, lo;
	MusgraveNoise_Simplex_4(In, (float)Scale, (float)Detail, (float)Dimension, (float)Lacunarity, (int)Type, o, hi, lo);
	Out = (half)o;
	outUpper = (half)hi;
	outLower = (half)lo;
}

#endif
