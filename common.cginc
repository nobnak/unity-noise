#ifndef __NOISE_COMMON_CGINC__
#define __NOISE_COMMON_CGINC__



// Cellular
#define K 0.142857142857 // 1/7
#define Ko 0.428571428571 // 1/2-K/2
#define K2 0.020408163265306 // 1/(7*7)
#define Kz 0.166666666667 // 1/6
#define Kzo 0.416666666667 // 1/2-1/6*2
#define jitter 1.0 // smaller jitter gives more regular pattern


float mod(float x, float y) {
    return x - y * floor(x / y);
}

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

float2 fade(float2 t) {
    return t * t * t * (t * (t * 6.0 - 15.0) + 10.0);
}
float3 fade(float3 t) {
    return t * t * t * (t * (t * 6.0 - 15.0) + 10.0);
}
float4 fade(float4 t) {
    return t * t * t * (t * (t * 6.0 - 15.0) + 10.0);
}

#endif
