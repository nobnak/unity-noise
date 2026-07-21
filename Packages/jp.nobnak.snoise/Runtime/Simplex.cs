using Unity.Mathematics;

namespace Nobnak.Noise {

/// <summary>Simplex noise ported from noise2D / noise3D / noise3Dgrad.hlsl.</summary>
public static class Simplex {
	public static float SNoise(float2 v) {
		float4 C = new float4(0.211324865405187f, 0.366025403784439f, -0.577350269189626f, 0.024390243902439f);
		float2 i = math.floor(v + math.dot(v, C.yy));
		float2 x0 = v - i + math.dot(i, C.xx);
		float2 i1 = x0.x > x0.y ? new float2(1f, 0f) : new float2(0f, 1f);
		float4 x12 = x0.xyxy + C.xxzz;
		x12.xy -= i1;

		i = Common.Mod289(i);
		float3 p = Common.Permute(Common.Permute(i.y + new float3(0f, i1.y, 1f)) + i.x + new float3(0f, i1.x, 1f));

		float3 m = math.max(0.5f - new float3(math.dot(x0, x0), math.dot(x12.xy, x12.xy), math.dot(x12.zw, x12.zw)), 0f);
		m = m * m;
		m = m * m;

		float3 x = 2f * math.frac(p * C.www) - 1f;
		float3 h = math.abs(x) - 0.5f;
		float3 ox = math.floor(x + 0.5f);
		float3 a0 = x - ox;
		m *= 1.79284291400159f - 0.85373472095314f * (a0 * a0 + h * h);

		float3 g = new float3(a0.x * x0.x + h.x * x0.y, a0.yz * x12.xz + h.yz * x12.yw);
		return 130f * math.dot(m, g);
	}

	public static float SNoise(float3 v) {
		float2 C = new float2(1f / 6f, 1f / 3f);
		float4 D = new float4(0f, 0.5f, 1f, 2f);

		float3 i = math.floor(v + math.dot(v, C.yyy));
		float3 x0 = v - i + math.dot(i, C.xxx);

		float3 g = math.step(x0.yzx, x0.xyz);
		float3 l = 1f - g;
		float3 i1 = math.min(g.xyz, l.zxy);
		float3 i2 = math.max(g.xyz, l.zxy);

		float3 x1 = x0 - i1 + C.xxx;
		float3 x2 = x0 - i2 + C.yyy;
		float3 x3 = x0 - D.yyy;

		i = Common.Mod289(i);
		float4 p = Common.Permute(Common.Permute(Common.Permute(
			i.z + new float4(0f, i1.z, i2.z, 1f))
			+ i.y + new float4(0f, i1.y, i2.y, 1f))
			+ i.x + new float4(0f, i1.x, i2.x, 1f));

		float n_ = 0.142857142857f;
		float3 ns = n_ * D.wyz - D.xzx;

		float4 j = p - 49f * math.floor(p * ns.z * ns.z);
		float4 x_ = math.floor(j * ns.z);
		float4 y_ = math.floor(j - 7f * x_);

		float4 x = x_ * ns.x + ns.yyyy;
		float4 y = y_ * ns.x + ns.yyyy;
		float4 h = 1f - math.abs(x) - math.abs(y);

		float4 b0 = new float4(x.xy, y.xy);
		float4 b1 = new float4(x.zw, y.zw);
		float4 s0 = math.floor(b0) * 2f + 1f;
		float4 s1 = math.floor(b1) * 2f + 1f;
		float4 sh = -math.step(h, 0f);

		float4 a0 = b0.xzyw + s0.xzyw * sh.xxyy;
		float4 a1 = b1.xzyw + s1.xzyw * sh.zzww;

		float3 p0 = new float3(a0.xy, h.x);
		float3 p1 = new float3(a0.zw, h.y);
		float3 p2 = new float3(a1.xy, h.z);
		float3 p3 = new float3(a1.zw, h.w);

		float4 norm = Common.TaylorInvSqrt(new float4(math.dot(p0, p0), math.dot(p1, p1), math.dot(p2, p2), math.dot(p3, p3)));
		p0 *= norm.x;
		p1 *= norm.y;
		p2 *= norm.z;
		p3 *= norm.w;

		float4 m = math.max(0.5f - new float4(math.dot(x0, x0), math.dot(x1, x1), math.dot(x2, x2), math.dot(x3, x3)), 0f);
		m = m * m;
		return 105f * math.dot(m * m, new float4(math.dot(p0, x0), math.dot(p1, x1), math.dot(p2, x2), math.dot(p3, x3)));
	}

	public static float SNoise(float3 v, out float3 gradient) {
		float2 C = new float2(1f / 6f, 1f / 3f);
		float4 D = new float4(0f, 0.5f, 1f, 2f);

		float3 i = math.floor(v + math.dot(v, C.yyy));
		float3 x0 = v - i + math.dot(i, C.xxx);

		float3 g = math.step(x0.yzx, x0.xyz);
		float3 l = 1f - g;
		float3 i1 = math.min(g.xyz, l.zxy);
		float3 i2 = math.max(g.xyz, l.zxy);

		float3 x1 = x0 - i1 + C.xxx;
		float3 x2 = x0 - i2 + C.yyy;
		float3 x3 = x0 - D.yyy;

		i = Common.Mod289(i);
		float4 p = Common.Permute(Common.Permute(Common.Permute(
			i.z + new float4(0f, i1.z, i2.z, 1f))
			+ i.y + new float4(0f, i1.y, i2.y, 1f))
			+ i.x + new float4(0f, i1.x, i2.x, 1f));

		float n_ = 0.142857142857f;
		float3 ns = n_ * D.wyz - D.xzx;

		float4 j = p - 49f * math.floor(p * ns.z * ns.z);
		float4 x_ = math.floor(j * ns.z);
		float4 y_ = math.floor(j - 7f * x_);

		float4 x = x_ * ns.x + ns.yyyy;
		float4 y = y_ * ns.x + ns.yyyy;
		float4 h = 1f - math.abs(x) - math.abs(y);

		float4 b0 = new float4(x.xy, y.xy);
		float4 b1 = new float4(x.zw, y.zw);
		float4 s0 = math.floor(b0) * 2f + 1f;
		float4 s1 = math.floor(b1) * 2f + 1f;
		float4 sh = -math.step(h, 0f);

		float4 a0 = b0.xzyw + s0.xzyw * sh.xxyy;
		float4 a1 = b1.xzyw + s1.xzyw * sh.zzww;

		float3 p0 = new float3(a0.xy, h.x);
		float3 p1 = new float3(a0.zw, h.y);
		float3 p2 = new float3(a1.xy, h.z);
		float3 p3 = new float3(a1.zw, h.w);

		float4 norm = Common.TaylorInvSqrt(new float4(math.dot(p0, p0), math.dot(p1, p1), math.dot(p2, p2), math.dot(p3, p3)));
		p0 *= norm.x;
		p1 *= norm.y;
		p2 *= norm.z;
		p3 *= norm.w;

		float4 m = math.max(0.5f - new float4(math.dot(x0, x0), math.dot(x1, x1), math.dot(x2, x2), math.dot(x3, x3)), 0f);
		float4 m2 = m * m;
		float4 m4 = m2 * m2;
		float4 pdotx = new float4(math.dot(p0, x0), math.dot(p1, x1), math.dot(p2, x2), math.dot(p3, x3));

		float4 temp = m2 * m * pdotx;
		gradient = -8f * (temp.x * x0 + temp.y * x1 + temp.z * x2 + temp.w * x3);
		gradient += m4.x * p0 + m4.y * p1 + m4.z * p2 + m4.w * p3;
		gradient *= 105f;

		return 105f * math.dot(m4, pdotx);
	}
}

}
