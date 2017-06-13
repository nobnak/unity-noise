float4 mod289(float4 x) {
  return fmod(x, 289.0);
}

float mod289(float x) {
  return fmod(x, 289.0);
}

// Modulo 7 without a division
float3 mod7(float3 x) {
  return fmod(x, 7.0);
}

float4 permute(float4 x) {
     return mod289(((x*34.0)+1.0)*x);
}

float permute(float x) {
     return mod289(((x*34.0)+1.0)*x);
}

float4 taylorInvSqrt(float4 r) {
  return 1.79284291400159 - 0.85373472095314 * r;
}

float taylorInvSqrt(float r) {
  return 1.79284291400159 - 0.85373472095314 * r;
}

float2 fade(float2 t) {
  return t*t*t*(t*(t*6.0-15.0)+10.0);
}