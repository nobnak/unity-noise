using Unity.Burst;
using Unity.Collections;
using Unity.Jobs;
using Unity.Mathematics;

namespace Nobnak.Noise {

/// <summary>Burst Jobs for batch sampling (SIMD over many coordinates).</summary>
public static class NoiseBatch {
	public static JobHandle ScheduleSNoise(NativeArray<float2> positions, NativeArray<float> values, JobHandle dependsOn = default) =>
		new SNoise2DJob { Positions = positions, Values = values }.Schedule(positions.Length, 64, dependsOn);

	public static JobHandle ScheduleSNoise(NativeArray<float3> positions, NativeArray<float> values, JobHandle dependsOn = default) =>
		new SNoise3DJob { Positions = positions, Values = values }.Schedule(positions.Length, 64, dependsOn);

	public static JobHandle ScheduleCNoise(NativeArray<float2> positions, NativeArray<float> values, JobHandle dependsOn = default) =>
		new CNoise2DJob { Positions = positions, Values = values }.Schedule(positions.Length, 64, dependsOn);

	public static JobHandle ScheduleCNoise(NativeArray<float3> positions, NativeArray<float> values, JobHandle dependsOn = default) =>
		new CNoise3DJob { Positions = positions, Values = values }.Schedule(positions.Length, 64, dependsOn);

	public static JobHandle SchedulePNoise(NativeArray<float2> positions, float2 rep, NativeArray<float> values, JobHandle dependsOn = default) =>
		new PNoise2DJob { Positions = positions, Rep = rep, Values = values }.Schedule(positions.Length, 64, dependsOn);

	public static JobHandle SchedulePNoise(NativeArray<float3> positions, float3 rep, NativeArray<float> values, JobHandle dependsOn = default) =>
		new PNoise3DJob { Positions = positions, Rep = rep, Values = values }.Schedule(positions.Length, 64, dependsOn);

	#region jobs
	[BurstCompile]
	struct SNoise2DJob : IJobParallelFor {
		[ReadOnly] public NativeArray<float2> Positions;
		[WriteOnly] public NativeArray<float> Values;
		public void Execute(int i) => Values[i] = Simplex.SNoise(Positions[i]);
	}

	[BurstCompile]
	struct SNoise3DJob : IJobParallelFor {
		[ReadOnly] public NativeArray<float3> Positions;
		[WriteOnly] public NativeArray<float> Values;
		public void Execute(int i) => Values[i] = Simplex.SNoise(Positions[i]);
	}

	[BurstCompile]
	struct CNoise2DJob : IJobParallelFor {
		[ReadOnly] public NativeArray<float2> Positions;
		[WriteOnly] public NativeArray<float> Values;
		public void Execute(int i) => Values[i] = Classic.CNoise(Positions[i]);
	}

	[BurstCompile]
	struct CNoise3DJob : IJobParallelFor {
		[ReadOnly] public NativeArray<float3> Positions;
		[WriteOnly] public NativeArray<float> Values;
		public void Execute(int i) => Values[i] = Classic.CNoise(Positions[i]);
	}

	[BurstCompile]
	struct PNoise2DJob : IJobParallelFor {
		[ReadOnly] public NativeArray<float2> Positions;
		public float2 Rep;
		[WriteOnly] public NativeArray<float> Values;
		public void Execute(int i) => Values[i] = Classic.PNoise(Positions[i], Rep);
	}

	[BurstCompile]
	struct PNoise3DJob : IJobParallelFor {
		[ReadOnly] public NativeArray<float3> Positions;
		public float3 Rep;
		[WriteOnly] public NativeArray<float> Values;
		public void Execute(int i) => Values[i] = Classic.PNoise(Positions[i], Rep);
	}
	#endregion
}

}
