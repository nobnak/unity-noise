#ifndef __MUSGRAVE_3D__
#define __MUSGRAVE_3D__

// Shader Graph: Musgrave3D_float(..., out float Out, out float outUpper, out float outLower)

#include "../noise3D.hlsl"
#include "musgrave_impl.hlsl"
MUSGRAVE_EXPAND_SIMPLEX(MusgraveNoise_Simplex_3, float3)

void Musgrave3D_float(float3 In, float Scale, float Detail, float Dimension, float Lacunarity, float Type, out float Out, out float outUpper, out float outLower)
{
	MusgraveNoise_Simplex_3(In, Scale, Detail, Dimension, Lacunarity, (int)Type, Out, outUpper, outLower);
}

void Musgrave3D_half(float3 In, half Scale, half Detail, half Dimension, half Lacunarity, half Type, out half Out, out half outUpper, out half outLower)
{
	float o, hi, lo;
	MusgraveNoise_Simplex_3(In, (float)Scale, (float)Detail, (float)Dimension, (float)Lacunarity, (int)Type, o, hi, lo);
	Out = (half)o;
	outUpper = (half)hi;
	outLower = (half)lo;
}

#endif
