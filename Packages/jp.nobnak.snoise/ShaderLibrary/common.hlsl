#ifndef __NOISE_COMMON__
#define __NOISE_COMMON__

float mod(float a, float b) {
    return a - b * floor(a / b);
}
float2 mod(float2 a, float2 b) {
    return a - b * floor(a / b);
}
float3 mod(float3 a, float3 b) {
    return a - b * floor(a / b);
}
float4 mod(float4 a, float4 b) {
    return a - b * floor(a / b);
}

// Modulo 289, optimizes to code without divisions
float mod289(float x) {
    return x - floor(x * (1.0 / 289.0)) * 289.0;
}
float2 mod289(float2 x) {
    return x - floor(x * (1.0 / 289.0)) * 289.0;
}
float3 mod289(float3 x) {
    return x - floor(x * (1.0 / 289.0)) * 289.0;
}
float4 mod289(float4 x) {
    return x - floor(x * (1.0 / 289.0)) * 289.0;
}

// Modulo 7 without a division
float3 mod7(float3 x) {
    return x - floor(x * (1.0 / 7.0)) * 7.0;
}
float4 mod7(float4 x) {
    return x - floor(x * (1.0 / 7.0)) * 7.0;
}

// Permutation polynomial (ring size 289 = 17*17)
float permute(float x) {
    return mod289(((x * 34.0) + 1.0) * x);
}
float3 permute(float3 x) {
    return mod289(((x * 34.0) + 10.0) * x);
}
float4 permute(float4 x) {
    return mod289(((x * 34.0) + 10.0) * x);
}

float taylorInvSqrt(float r) {
    return 1.79284291400159 - 0.85373472095314 * r;
}
float4 taylorInvSqrt(float4 r) {
    return 1.79284291400159 - 0.85373472095314 * r;
}

float4 grad4(float j, float4 ip) {
    const float4 ones = float4(1.0, 1.0, 1.0, -1.0);
    float4 p, s;

    p.xyz = floor(frac(j * ip.xyz) * 7.0) * ip.z - 1.0;
    p.w = 1.5 - dot(abs(p.xyz), ones.xyz);
    s = float4(p < 0.0);
    p.xyz = p.xyz + (s.xyz * 2.0 - 1.0) * s.www;

    return p;
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