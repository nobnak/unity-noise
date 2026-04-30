#ifndef __MUSGRAVE_3D__
#define __MUSGRAVE_3D__

// Shader Graph: Musgrave3D_float(float3 In, float Scale, float Detail, float Dimension, float Lacunarity, float Type, out float Out, out float AmpUpper)

#include "../noise3D.hlsl"

#define MUSGRAVE_COORD_T float3
#define MUSGRAVE_SAMPLE(p) snoise(p)
#include "musgrave_impl.hlsl"
#undef MUSGRAVE_SAMPLE
#undef MUSGRAVE_COORD_T

void Musgrave3D_float(float3 In, float Scale, float Detail, float Dimension, float Lacunarity, float Type, out float Out, out float AmpUpper)
{
	MusgraveNoise_Simplex(In, Scale, Detail, Dimension, Lacunarity, (int)Type, Out, AmpUpper);
}

void Musgrave3D_half(float3 In, half Scale, half Detail, half Dimension, half Lacunarity, half Type, out half Out, out half AmpUpper)
{
	float o, a;
	MusgraveNoise_Simplex(In, (float)Scale, (float)Detail, (float)Dimension, (float)Lacunarity, (int)Type, o, a);
	Out = (half)o;
	AmpUpper = (half)a;
}

#endif
