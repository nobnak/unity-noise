#ifndef __MUSGRAVE_2D__
#define __MUSGRAVE_2D__

// Shader Graph: Musgrave2D_float(..., out float Out, out float outUpper, out float outLower)
// outUpper/outLower: bracket for normalization; Ridged outLower=0; Multifractal uses Πmax(1-ai,ε); Hybrid/Heterogeneous outLower is symmetric heuristic (-outUpper).

#include "../noise2D.hlsl"
#include "musgrave_impl.hlsl"
MUSGRAVE_EXPAND_SIMPLEX(MusgraveNoise_Simplex_2, float2)

void Musgrave2D_float(float2 In, float Scale, float Detail, float Dimension, float Lacunarity, float Type, out float Out, out float outUpper, out float outLower)
{
	MusgraveNoise_Simplex_2(In, Scale, Detail, Dimension, Lacunarity, (int)Type, Out, outUpper, outLower);
}

void Musgrave2D_half(float2 In, half Scale, half Detail, half Dimension, half Lacunarity, half Type, out half Out, out half outUpper, out half outLower)
{
	float o, hi, lo;
	MusgraveNoise_Simplex_2(In, (float)Scale, (float)Detail, (float)Dimension, (float)Lacunarity, (int)Type, o, hi, lo);
	Out = (half)o;
	outUpper = (half)hi;
	outLower = (half)lo;
}

#endif
