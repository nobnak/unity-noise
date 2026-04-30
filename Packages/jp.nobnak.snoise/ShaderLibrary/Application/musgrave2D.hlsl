#ifndef __MUSGRAVE_2D__
#define __MUSGRAVE_2D__

// Simplex-based Musgrave (Blender-style fractal). Shader Graph Custom Function:
//   Function name: Musgrave2D
//   Float precision: Musgrave2D_float(float2 In, float Scale, float Detail, float Dimension, float Lacunarity, float Type, out float Out)
//   Half precision:  Musgrave2D_half(float2 In, half Scale, half Detail, half Dimension, half Lacunarity, half Type, out half Out)
// Type: 0 fBm, 1 Multifractal, 2 Ridged multifractal, 3 Hybrid multifractal, 4 Heterogeneous terrain

#include "../noise2D.hlsl"

#define MUSGRAVE_COORD_T float2
#define MUSGRAVE_SAMPLE(p) snoise(p)
#include "musgrave_impl.hlsl"
#undef MUSGRAVE_SAMPLE
#undef MUSGRAVE_COORD_T

void Musgrave2D_float(float2 In, float Scale, float Detail, float Dimension, float Lacunarity, float Type, out float Out)
{
	Out = MusgraveNoise_Simplex(In, Scale, Detail, Dimension, Lacunarity, (int)Type);
}

void Musgrave2D_half(float2 In, half Scale, half Detail, half Dimension, half Lacunarity, half Type, out half Out)
{
	Out = (half)MusgraveNoise_Simplex(In, (float)Scale, (float)Detail, (float)Dimension, (float)Lacunarity, (int)Type);
}

#endif
