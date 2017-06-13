#ifndef __NOISE_COMMON_CGINC__
#define __NOISE_COMMON_CGINC__



#define NOISE_SIMPLEX_1_DIV_289 0.00346020761245674740484429065744f
float mod289(float x) {
    return x - floor(x * NOISE_SIMPLEX_1_DIV_289) * 289.0;
}
float2 mod289(float2 x) {
    return x - floor(x * NOISE_SIMPLEX_1_DIV_289) * 289.0;
}
float3 mod289(float3 x) {
    return x - floor(x * NOISE_SIMPLEX_1_DIV_289) * 289.0;
}
float4 mod289(float4 x) {
    return x - floor(x * NOISE_SIMPLEX_1_DIV_289) * 289.0;
}

float mod7(float x) {
    return x - floor(x * (1.0 / 7.0)) * 7.0;
}
float2 mod7(float2 x) {
    return x - floor(x * (1.0 / 7.0)) * 7.0;
}
float3 mod7(float3 x) {
    return x - floor(x * (1.0 / 7.0)) * 7.0;
}
float4 mod7(float4 x) {
    return x - floor(x * (1.0 / 7.0)) * 7.0;
}

float permute(float x) {
    return mod289(x*x*34.0 + x);
}
float2 permute(float2 x) {
    return mod289(x*x*34.0 + x);
}
float3 permute(float3 x) {
    return mod289(x*x*34.0 + x);
}
float4 permute(float4 x) {
    return mod289(x*x*34.0 + x);
}

float taylorInvSqrt(float r) {
    return 1.79284291400159 - 0.85373472095314 * r;
}
float4 taylorInvSqrt(float4 r) {
    return 1.79284291400159 - 0.85373472095314 * r;
}



#endif
