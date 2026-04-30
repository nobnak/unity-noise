#ifndef __MUSGRAVE_4D__
#define __MUSGRAVE_4D__

// Shader Graph Custom Function:
//   Function name: Musgrave4D
//   Float: Musgrave4D_float(float4 In, float Scale, float Detail, float Dimension, float Lacunarity, float Type, out float Out)
//   Half:  Musgrave4D_half(float4 In, half Scale, half Detail, half Dimension, half Lacunarity, half Type, out half Out)
// Type: 0 fBm, 1 Multifractal, 2 Ridged multifractal, 3 Hybrid multifractal, 4 Heterogeneous terrain

#include "../noise4D.hlsl"

#define MUSGRAVE_COORD_T float4
#define MUSGRAVE_SAMPLE(p) snoise(p)
#include "musgrave_impl.hlsl"
#undef MUSGRAVE_SAMPLE
#undef MUSGRAVE_COORD_T

void Musgrave4D_float(float4 In, float Scale, float Detail, float Dimension, float Lacunarity, float Type, out float Out)
{
	Out = MusgraveNoise_Simplex(In, Scale, Detail, Dimension, Lacunarity, (int)Type);
}

void Musgrave4D_half(float4 In, half Scale, half Detail, half Dimension, half Lacunarity, half Type, out half Out)
{
	Out = (half)MusgraveNoise_Simplex(In, (float)Scale, (float)Detail, (float)Dimension, (float)Lacunarity, (int)Type);
}

#endif
