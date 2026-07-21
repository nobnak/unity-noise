using Unity.Mathematics;

namespace Nobnak.Noise {

/// <summary>Classic / periodic Perlin noise from classicnoise2D / 3D.hlsl.</summary>
public static class Classic {
	public static float CNoise(float2 P) {
		float4 Pi = math.floor(P.xyxy) + new float4(0f, 0f, 1f, 1f);
		float4 Pf = math.frac(P.xyxy) - new float4(0f, 0f, 1f, 1f);
		Pi = Common.Mod289(Pi);
		return Evaluate2D(Pi, Pf) * 2.3f;
	}

	public static float PNoise(float2 P, float2 rep) {
		float4 Pi = math.floor(P.xyxy) + new float4(0f, 0f, 1f, 1f);
		float4 Pf = math.frac(P.xyxy) - new float4(0f, 0f, 1f, 1f);
		Pi = Common.Mod(Pi, rep.xyxy);
		Pi = Common.Mod289(Pi);
		return Evaluate2D(Pi, Pf) * 2.3f;
	}

	public static float CNoise(float3 P) {
		float3 Pi0 = math.floor(P);
		float3 Pi1 = Pi0 + 1f;
		Pi0 = Common.Mod289(Pi0);
		Pi1 = Common.Mod289(Pi1);
		float3 Pf0 = math.frac(P);
		float3 Pf1 = Pf0 - 1f;
		return Evaluate3D(Pi0, Pi1, Pf0, Pf1) * 2.2f;
	}

	public static float PNoise(float3 P, float3 rep) {
		float3 Pi0 = Common.Mod(math.floor(P), rep);
		float3 Pi1 = Common.Mod(Pi0 + 1f, rep);
		Pi0 = Common.Mod289(Pi0);
		Pi1 = Common.Mod289(Pi1);
		float3 Pf0 = math.frac(P);
		float3 Pf1 = Pf0 - 1f;
		return Evaluate3D(Pi0, Pi1, Pf0, Pf1) * 2.2f;
	}

	#region private
	static float Evaluate2D(float4 Pi, float4 Pf) {
		float4 ix = Pi.xzxz;
		float4 iy = Pi.yyww;
		float4 fx = Pf.xzxz;
		float4 fy = Pf.yyww;

		float4 i = Common.Permute(Common.Permute(ix) + iy);
		float4 gx = math.frac(i * (1f / 41f)) * 2f - 1f;
		float4 gy = math.abs(gx) - 0.5f;
		float4 tx = math.floor(gx + 0.5f);
		gx = gx - tx;

		float2 g00 = new float2(gx.x, gy.x);
		float2 g10 = new float2(gx.y, gy.y);
		float2 g01 = new float2(gx.z, gy.z);
		float2 g11 = new float2(gx.w, gy.w);

		float4 norm = Common.TaylorInvSqrt(new float4(
			math.dot(g00, g00), math.dot(g01, g01), math.dot(g10, g10), math.dot(g11, g11)));
		float n00 = norm.x * math.dot(g00, new float2(fx.x, fy.x));
		float n01 = norm.y * math.dot(g01, new float2(fx.z, fy.z));
		float n10 = norm.z * math.dot(g10, new float2(fx.y, fy.y));
		float n11 = norm.w * math.dot(g11, new float2(fx.w, fy.w));

		float2 fade_xy = Common.Fade(Pf.xy);
		float2 n_x = math.lerp(new float2(n00, n01), new float2(n10, n11), fade_xy.x);
		return math.lerp(n_x.x, n_x.y, fade_xy.y);
	}

	static float Evaluate3D(float3 Pi0, float3 Pi1, float3 Pf0, float3 Pf1) {
		float4 ix = new float4(Pi0.x, Pi1.x, Pi0.x, Pi1.x);
		float4 iy = new float4(Pi0.yy, Pi1.yy);
		float4 iz0 = Pi0.zzzz;
		float4 iz1 = Pi1.zzzz;

		float4 ixy = Common.Permute(Common.Permute(ix) + iy);
		float4 ixy0 = Common.Permute(ixy + iz0);
		float4 ixy1 = Common.Permute(ixy + iz1);

		float4 gx0 = ixy0 * (1f / 7f);
		float4 gy0 = math.frac(math.floor(gx0) * (1f / 7f)) - 0.5f;
		gx0 = math.frac(gx0);
		float4 gz0 = 0.5f - math.abs(gx0) - math.abs(gy0);
		float4 sz0 = math.step(gz0, 0f);
		gx0 -= sz0 * (math.step(0f, gx0) - 0.5f);
		gy0 -= sz0 * (math.step(0f, gy0) - 0.5f);

		float4 gx1 = ixy1 * (1f / 7f);
		float4 gy1 = math.frac(math.floor(gx1) * (1f / 7f)) - 0.5f;
		gx1 = math.frac(gx1);
		float4 gz1 = 0.5f - math.abs(gx1) - math.abs(gy1);
		float4 sz1 = math.step(gz1, 0f);
		gx1 -= sz1 * (math.step(0f, gx1) - 0.5f);
		gy1 -= sz1 * (math.step(0f, gy1) - 0.5f);

		float3 g000 = new float3(gx0.x, gy0.x, gz0.x);
		float3 g100 = new float3(gx0.y, gy0.y, gz0.y);
		float3 g010 = new float3(gx0.z, gy0.z, gz0.z);
		float3 g110 = new float3(gx0.w, gy0.w, gz0.w);
		float3 g001 = new float3(gx1.x, gy1.x, gz1.x);
		float3 g101 = new float3(gx1.y, gy1.y, gz1.y);
		float3 g011 = new float3(gx1.z, gy1.z, gz1.z);
		float3 g111 = new float3(gx1.w, gy1.w, gz1.w);

		float4 norm0 = Common.TaylorInvSqrt(new float4(
			math.dot(g000, g000), math.dot(g010, g010), math.dot(g100, g100), math.dot(g110, g110)));
		float4 norm1 = Common.TaylorInvSqrt(new float4(
			math.dot(g001, g001), math.dot(g011, g011), math.dot(g101, g101), math.dot(g111, g111)));

		float n000 = norm0.x * math.dot(g000, Pf0);
		float n010 = norm0.y * math.dot(g010, new float3(Pf0.x, Pf1.y, Pf0.z));
		float n100 = norm0.z * math.dot(g100, new float3(Pf1.x, Pf0.yz));
		float n110 = norm0.w * math.dot(g110, new float3(Pf1.xy, Pf0.z));
		float n001 = norm1.x * math.dot(g001, new float3(Pf0.xy, Pf1.z));
		float n011 = norm1.y * math.dot(g011, new float3(Pf0.x, Pf1.yz));
		float n101 = norm1.z * math.dot(g101, new float3(Pf1.x, Pf0.y, Pf1.z));
		float n111 = norm1.w * math.dot(g111, Pf1);

		float3 fade_xyz = Common.Fade(Pf0);
		float4 n_z = math.lerp(new float4(n000, n100, n010, n110), new float4(n001, n101, n011, n111), fade_xyz.z);
		float2 n_yz = math.lerp(n_z.xy, n_z.zw, fade_xyz.y);
		return math.lerp(n_yz.x, n_yz.y, fade_xyz.x);
	}
	#endregion
}

}
