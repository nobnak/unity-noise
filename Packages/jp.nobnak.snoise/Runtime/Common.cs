using Unity.Mathematics;

namespace Nobnak.Noise {

/// <summary>Shared helpers ported from ShaderLibrary/common.hlsl.</summary>
public static class Common {
	public static float Mod(float a, float b) => a - b * math.floor(a / b);
	public static float2 Mod(float2 a, float2 b) => a - b * math.floor(a / b);
	public static float3 Mod(float3 a, float3 b) => a - b * math.floor(a / b);
	public static float4 Mod(float4 a, float4 b) => a - b * math.floor(a / b);

	public static float Mod289(float x) => x - math.floor(x * (1f / 289f)) * 289f;
	public static float2 Mod289(float2 x) => x - math.floor(x * (1f / 289f)) * 289f;
	public static float3 Mod289(float3 x) => x - math.floor(x * (1f / 289f)) * 289f;
	public static float4 Mod289(float4 x) => x - math.floor(x * (1f / 289f)) * 289f;

	public static float Permute(float x) => Mod289(((x * 34f) + 10f) * x);
	public static float3 Permute(float3 x) => Mod289(((x * 34f) + 10f) * x);
	public static float4 Permute(float4 x) => Mod289(((x * 34f) + 10f) * x);

	public static float TaylorInvSqrt(float r) => 1.79284291400159f - 0.85373472095314f * r;
	public static float4 TaylorInvSqrt(float4 r) => 1.79284291400159f - 0.85373472095314f * r;

	public static float2 Fade(float2 t) => t * t * t * (t * (t * 6f - 15f) + 10f);
	public static float3 Fade(float3 t) => t * t * t * (t * (t * 6f - 15f) + 10f);
	public static float4 Fade(float4 t) => t * t * t * (t * (t * 6f - 15f) + 10f);
}

}
