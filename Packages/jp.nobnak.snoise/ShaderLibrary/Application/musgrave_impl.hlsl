#ifndef __MUSGRAVE_IMPL_CONSTANTS__
#define __MUSGRAVE_IMPL_CONSTANTS__

#define MUSGRAVE_FBM 0
#define MUSGRAVE_MULTIFRACTAL 1
#define MUSGRAVE_RIDGED_MULTIFRACTAL 2
#define MUSGRAVE_HYBRID_MULTIFRACTAL 3
#define MUSGRAVE_HETEROGENEOUS_TERRAIN 4

#endif

#ifndef __MUSGRAVE_EXPAND_SIMPLEX_DEFINED__
#define __MUSGRAVE_EXPAND_SIMPLEX_DEFINED__

// Instantiate once per dimension with a unique FuncName, e.g.
//   MUSGRAVE_EXPAND_SIMPLEX(MusgraveNoise_Simplex_2, float2)
// Multiple wrappers can coexist in one translation unit; snoise overload resolves from COORD_T.
#define MUSGRAVE_EXPAND_SIMPLEX(FuncName, COORD_T) \
[noinline] static void FuncName(COORD_T x, float scale, float detail, float dimension, \
	float lacunarity, int musgraveType, out float outNoise, out float outUpper, out float outLower) \
{ \
	static const int MAX_OCT = 15; \
	static const float PROD_LO_EPS = 1e-6; \
	outNoise = 0.0; \
	outUpper = 0.0; \
	outLower = 0.0; \
	float d = max(detail, 0.0); \
	int N = (int)floor(d); \
	float r = d - floor(d); \
	N = min(N, MAX_OCT); \
	COORD_T x0 = x * scale; \
	float lac = max(lacunarity, 1.000001); \
	if (musgraveType == MUSGRAVE_MULTIFRACTAL) \
	{ \
		float prod = 1.0; \
		float prodUb = 1.0; \
		float prodLb = 1.0; \
		float freq = 1.0; \
		for (int i = 0; i < N; ++i) \
		{ \
			float ai = pow(lac, -(float)i * dimension); \
			prod *= (1.0 + ai * snoise(x0 * freq)); \
			prodUb *= (1.0 + ai); \
			prodLb *= max(1.0 - ai, PROD_LO_EPS); \
			freq *= lac; \
		} \
		if (r > 0.0) \
		{ \
			float ai = pow(lac, -(float)N * dimension); \
			prod *= (1.0 + r * ai * snoise(x0 * freq)); \
			prodUb *= (1.0 + r * ai); \
			prodLb *= max(1.0 - r * ai, PROD_LO_EPS); \
		} \
		outNoise = prod; \
		outUpper = prodUb; \
		outLower = prodLb; \
		return; \
	} \
	if (musgraveType == MUSGRAVE_RIDGED_MULTIFRACTAL) \
	{ \
		float sum = 0.0; \
		float ampSum = 0.0; \
		float freq = 1.0; \
		for (int i = 0; i < N; ++i) \
		{ \
			float ai = pow(lac, -(float)i * dimension); \
			float n = snoise(x0 * freq); \
			float ri = 1.0 - abs(n); \
			ri *= ri; \
			sum += ai * ri; \
			ampSum += ai; \
			freq *= lac; \
		} \
		if (r > 0.0) \
		{ \
			float ai = pow(lac, -(float)N * dimension); \
			float n = snoise(x0 * freq); \
			float ri = 1.0 - abs(n); \
			ri *= ri; \
			sum += r * ai * ri; \
			ampSum += r * ai; \
		} \
		outNoise = sum; \
		outUpper = ampSum; \
		outLower = 0.0; \
		return; \
	} \
	if (musgraveType == MUSGRAVE_HYBRID_MULTIFRACTAL) \
	{ \
		float freq = 1.0; \
		float n0 = snoise(x0); \
		float f = n0; \
		float w = f; \
		float ampUb = 1.0; \
		for (int i = 0; i < N; ++i) \
		{ \
			float ai = pow(lac, -(float)i * dimension); \
			float s = snoise(x0 * freq); \
			f += w * ai * s; \
			w *= s; \
			ampUb += ai; \
			freq *= lac; \
		} \
		if (r > 0.0) \
		{ \
			float ai = pow(lac, -(float)N * dimension); \
			float s = snoise(x0 * freq); \
			f += r * w * ai * s; \
			ampUb += r * ai; \
		} \
		outNoise = f; \
		outUpper = ampUb; \
		outLower = -ampUb; \
		return; \
	} \
	if (musgraveType == MUSGRAVE_HETEROGENEOUS_TERRAIN) \
	{ \
		float freq = 1.0; \
		float f = snoise(x0); \
		float prodUb = 1.0; \
		for (int i = 0; i < N; ++i) \
		{ \
			float ai = pow(lac, -(float)i * dimension); \
			float n = snoise(x0 * freq); \
			f += ai * n * f; \
			prodUb *= (1.0 + ai); \
			freq *= lac; \
		} \
		if (r > 0.0) \
		{ \
			float ai = pow(lac, -(float)N * dimension); \
			float n = snoise(x0 * freq); \
			f += r * ai * n * f; \
			prodUb *= (1.0 + r * ai); \
		} \
		outNoise = f; \
		outUpper = prodUb; \
		outLower = -prodUb; \
		return; \
	} \
	float sum = 0.0; \
	float ampSum = 0.0; \
	float freq = 1.0; \
	for (int i = 0; i < N; ++i) \
	{ \
		float ai = pow(lac, -(float)i * dimension); \
		sum += ai * snoise(x0 * freq); \
		ampSum += ai; \
		freq *= lac; \
	} \
	if (r > 0.0) \
	{ \
		float ai = pow(lac, -(float)N * dimension); \
		sum += r * ai * snoise(x0 * freq); \
		ampSum += r * ai; \
	} \
	outNoise = sum; \
	outUpper = ampSum; \
	outLower = -ampSum; \
}

#endif
