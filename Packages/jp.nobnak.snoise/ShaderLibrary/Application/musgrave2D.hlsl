#ifndef __MUSGRAVE_2D__
#define __MUSGRAVE_2D__

// Shader Graph Custom Function name: Musgrave2D
// Float:  Musgrave2D_float(float2 In, float Scale, float Detail, float Dimension, float Lacunarity, float Type, out float Out, out float AmpUpper)
// Half:   Musgrave2D_half(..., out half Out, out half AmpUpper)
// AmpUpper assumes |noise|<=1. Types: 0 fBm, 1 Multifractal, 2 Ridged, 3 Hybrid, 4 Heterogeneous

#include "../noise2D.hlsl"

#define MUSGRAVE_COORD_T float2
#define MUSGRAVE_SAMPLE(p) snoise(p)
#include "musgrave_impl.hlsl"
#undef MUSGRAVE_SAMPLE
#undef MUSGRAVE_COORD_T

void Musgrave2D_float(float2 In, float Scale, float Detail, float Dimension, float Lacunarity, float Type, out float Out, out float AmpUpper)
{
	MusgraveNoise_Simplex(In, Scale, Detail, Dimension, Lacunarity, (int)Type, Out, AmpUpper);
}

void Musgrave2D_half(float2 In, half Scale, half Detail, half Dimension, half Lacunarity, half Type, out half Out, out half AmpUpper)
{
	float o, a;
	MusgraveNoise_Simplex(In, (float)Scale, (float)Detail, (float)Dimension, (float)Lacunarity, (int)Type, o, a);
	Out = (half)o;
	AmpUpper = (half)a;
}

#endif
