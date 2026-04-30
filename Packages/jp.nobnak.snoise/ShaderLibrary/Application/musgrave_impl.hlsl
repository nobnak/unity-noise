#ifndef __MUSGRAVE_IMPL__
#define __MUSGRAVE_IMPL__

#ifndef MUSGRAVE_COORD_T
#error Define MUSGRAVE_COORD_T (float2/float3/float4) before including musgrave_impl.hlsl
#endif
#ifndef MUSGRAVE_SAMPLE
#error Define MUSGRAVE_SAMPLE(coord) before including musgrave_impl.hlsl
#endif

#define MUSGRAVE_FBM 0
#define MUSGRAVE_MULTIFRACTAL 1
#define MUSGRAVE_RIDGED_MULTIFRACTAL 2
#define MUSGRAVE_HYBRID_MULTIFRACTAL 3
#define MUSGRAVE_HETEROGENEOUS_TERRAIN 4

static float MusgraveNoise_Simplex(MUSGRAVE_COORD_T x, float scale, float detail, float dimension,
	float lacunarity, int musgraveType)
{
	static const int MAX_OCT = 15;
	float d = max(detail, 0.0);
	int N = (int)floor(d);
	float r = d - floor(d);
	N = min(N, MAX_OCT);
	MUSGRAVE_COORD_T x0 = x * scale;
	float lac = max(lacunarity, 1.000001);

	if (musgraveType == MUSGRAVE_MULTIFRACTAL) {
		float prod = 1.0;
		float freq = 1.0;
		for (int i = 0; i < N; ++i) {
			float ai = pow(lac, -(float)i * dimension);
			prod *= (1.0 + ai * MUSGRAVE_SAMPLE(x0 * freq));
			freq *= lac;
		}
		if (r > 0.0) {
			float ai = pow(lac, -(float)N * dimension);
			prod *= (1.0 + r * ai * MUSGRAVE_SAMPLE(x0 * freq));
		}
		return prod;
	}

	if (musgraveType == MUSGRAVE_RIDGED_MULTIFRACTAL) {
		float sum = 0.0;
		float freq = 1.0;
		for (int i = 0; i < N; ++i) {
			float ai = pow(lac, -(float)i * dimension);
			float n = MUSGRAVE_SAMPLE(x0 * freq);
			float ri = 1.0 - abs(n);
			ri *= ri;
			sum += ai * ri;
			freq *= lac;
		}
		if (r > 0.0) {
			float ai = pow(lac, -(float)N * dimension);
			float n = MUSGRAVE_SAMPLE(x0 * freq);
			float ri = 1.0 - abs(n);
			ri *= ri;
			sum += r * ai * ri;
		}
		return sum;
	}

	if (musgraveType == MUSGRAVE_HYBRID_MULTIFRACTAL) {
		float freq = 1.0;
		float n0 = MUSGRAVE_SAMPLE(x0);
		float f = n0;
		float w = f;
		for (int i = 0; i < N; ++i) {
			float ai = pow(lac, -(float)i * dimension);
			float s = MUSGRAVE_SAMPLE(x0 * freq);
			f += w * ai * s;
			w *= s;
			freq *= lac;
		}
		if (r > 0.0) {
			float ai = pow(lac, -(float)N * dimension);
			float s = MUSGRAVE_SAMPLE(x0 * freq);
			f += r * w * ai * s;
		}
		return f;
	}

	if (musgraveType == MUSGRAVE_HETEROGENEOUS_TERRAIN) {
		float freq = 1.0;
		float f = MUSGRAVE_SAMPLE(x0);
		for (int i = 0; i < N; ++i) {
			float ai = pow(lac, -(float)i * dimension);
			float n = MUSGRAVE_SAMPLE(x0 * freq);
			f += ai * n * f;
			freq *= lac;
		}
		if (r > 0.0) {
			float ai = pow(lac, -(float)N * dimension);
			float n = MUSGRAVE_SAMPLE(x0 * freq);
			f += r * ai * n * f;
		}
		return f;
	}

	// MUSGRAVE_FBM and unknown types
	float sum = 0.0;
	float freq = 1.0;
	for (int i = 0; i < N; ++i) {
		float ai = pow(lac, -(float)i * dimension);
		sum += ai * MUSGRAVE_SAMPLE(x0 * freq);
		freq *= lac;
	}
	if (r > 0.0) {
		float ai = pow(lac, -(float)N * dimension);
		sum += r * ai * MUSGRAVE_SAMPLE(x0 * freq);
	}
	return sum;
}

#endif
