# Gradient Noise Nodes (URP / Shader Graph)

**Gradient / cellular / fractal noise nodes** for Unity **Shader Graph**, shipped as the UPM package **`jp.nobnak.snoise`**.  
This repo embeds the package at `Packages/jp.nobnak.snoise/` and includes sample scenes under `Assets/Scenes/`.

Noise functions are ported from [Noise for GLSL](https://github.com/stegu/webgl-noise/) to HLSL.

## Quick start

| Goal | Action |
| ---- | ------ |
| Try samples in this repo | Open in Unity (URP) → `Assets/Scenes/Noises.unity`, `Assets/Scenes/Warp.unity` |
| Add to your project | Install **`jp.nobnak.snoise`** from [OpenUPM](#installation-openupm) |

[![Example02](http://img.youtube.com/vi/tglN3BLJ9fI/hqdefault.jpg)](https://youtu.be/tglN3BLJ9fI) · [Node screenshot](Images/NoiseNodes02.png)

## Table of contents

- [Shader Graph nodes](#shader-graph-nodes)
  - [Common slots](#common-slots)
  - [Classic](#classic-periodic-p)
  - [Noise (simplex)](#noise-simplex)
  - [Cellular (Worley)](#cellular-worley)
  - [Fractal](#fractal)
  - [Musgrave](#musgrave)
  - [4DNoise](#4dnoise)
- [Requirements](#requirements)
- [Installation (OpenUPM)](#installation-openupm)
- [CPU API (Burst)](#cpu-api-burst)
- [Package layout](#package-layout)
- [Further documentation](#further-documentation)

## Shader Graph nodes

Subgraphs live under `Packages/jp.nobnak.snoise/ShaderGraph/`. Add them from the Shader Graph **Create Node** menu (search by node name).

| Folder | Role |
| ------ | ---- |
| `Noises/` | Single-scale noise primitives |
| `Apps/` | Multi-octave or animated compositions |

**Naming**

| Suffix / name | Meaning |
| ------------- | ------- |
| `*_p` | Periodic tiling (`pnoise`) — adds **Repeat** |
| `*_psrd` | Tiling simplex with rotation (`psrdnoise`) — adds **Repeat**, **Rotation** |
| `*_grad` | Also outputs the noise **gradient** |
| `*_fast` | Faster cellular variant (smaller search window; F1/F2 may differ slightly) |

Domain-warping is demonstrated in the sample scene `Warp.unity` (not a separate subgraph).

### Common slots

| Slot | Type | Description |
| ---- | ---- | ----------- |
| **Position** | `float2` / `float3` / `float4` | Sample coordinates (UV, world XZ, etc.). Scale/frequency is controlled by multiplying **Position** before the node. |
| **Out** | `float` | Scalar noise. Gradient/simplex nodes are roughly in **[-1, 1]** (implementation scaling applies). |
| **Repeat** | `float2` / `float3` / `float4` | Tile period for periodic noise (`pnoise` / `psrdnoise`). **x**: any positive period; **y** (2D psrd): even integer recommended ([psrdnoise notes](Packages/jp.nobnak.snoise/ShaderLibrary/psrdnoise2D.hlsl)). |
| **F1** / **F2** | `float` | Cellular: distance to the nearest / second-nearest feature point. |
| **Gradient** / **Partial** | `float3` / `float2` | `Noise3D_grad`: ∂noise/∂position. `Noise2D_psrd`: ∂noise/∂x, ∂noise/∂y. |
| **Upper** / **Lower** | `float` | Musgrave: estimated output bounds for normalization (`Inverse Lerp`, etc.). See [Musgrave outputs](#musgrave). |

---

### Classic (periodic: `*_p`)

Classic **Perlin** (`cnoise` / `pnoise`). Smoother, slightly different spectrum than simplex.

| Node | Dim | Inputs | Outputs | Defaults |
| ---- | --- | ------ | ------- | -------- |
| Classic2D | 2D | Position | Out | — |
| Classic2D_p | 2D | Position, Repeat | Out | Repeat `(10, 10)` |
| Classic3D | 3D | Position | Out | — |
| Classic3D_p | 3D | Position, Repeat | Out | Repeat `(10, 10, 10)` |
| Classic4D | 4D | Position | Out | — |
| Classic4D_p | 4D | Position, Repeat | Out | Repeat `(10, 10, 10, 10)` |

| Parameter | Description |
| --------- | ------------- |
| **Repeat** | Period per axis. The field tiles seamlessly over each period. |

---

### Noise (simplex)

**Simplex** gradient noise (`snoise`). Default choice for general procedural textures.

| Node | Dim | Inputs | Outputs | Defaults |
| ---- | --- | ------ | ------- | -------- |
| Noise2D | 2D | Position | Out | — |
| Noise2D_psrd | 2D | Position, Repeat, Rotation | Out, Partial | Repeat `(10, 10)`, Rotation `(0, 0)` |
| Noise3D | 3D | Position | Out | — |
| Noise3D_grad | 3D | Position | Out, Gradient | — |
| Noise4D | 4D | Position | Out | — |

| Parameter | Description |
| --------- | ------------- |
| **Repeat** | Tile period (`Per` in HLSL). Used by `psrdnoise` for seamless tiling. |
| **Rotation** | Gradient rotation phase. In HLSL, **1.0 = one full turn** (swirling / flow-noise effects). The subgraph exposes a `float2` property; the value passed to `Rot` depends on your graph wiring (often a single component or swizzle). |
| **Partial** | Analytic derivatives of the scalar noise (x and y partials). |

---

### Cellular (Worley)

**Worley / cellular** noise: distances to pseudo-random feature points in a grid.

| Node | Dim | Inputs | Outputs | Notes |
| ---- | --- | ------ | ------- | ----- |
| Cellular2D | 2D | Position | F1, F2 | Full 3×3 search |
| Cellular2D_fast | 2D | Position | F1, F2 | 2×2 window |
| Cellular3D | 3D | Position | F1, F2 | Full search |
| Cellular3D_fast | 3D | Position | F1, F2 | 2×2×2 window |

| Output | Description |
| ------ | ------------- |
| **F1** | Distance to the closest feature point (cracks, cells, borders). |
| **F2** | Distance to the second-closest point (cell interiors, ridges when combined with F1). |

Values are Euclidean distances (≥ 0). Typical range depends on scale; divide by an expected cell size to normalize.

---

### Fractal

Layered **fBm-style** simplex fractal with optional preview and remapping to roughly **[0, 1]**.

| Node | Dim | Inputs | Outputs | Defaults |
| ---- | --- | ------ | ------- | -------- |
| Fractal3D | 3D | Position, Detail, Instability | Out | Detail `0.5`, Instability `1.0` |
| Fractal4D | 4D | Position, Detail, Instability | Out | Detail `0.5`, Instability `1.0` |

| Parameter | Description |
| --------- | ------------- |
| **Detail** | Blend weight across stacked octaves (0–1 in sample materials). Higher → more high-frequency content. Not the same as Musgrave’s integer **Detail** (octave count). |
| **Instability** | Strength of variation between layers. Sample shaders use range **0.5–1.5** (default `1.0`); values above `1` exaggerate contrast. |
| **Preview** | Shader keyword `_PREVIEW` (editor-oriented preview path inside the subgraph). |

**Position** on Fractal4D is `float4`; the fourth component can drive animation (see **4DNoise**).

---

### Musgrave

**Blender-aligned Musgrave** fractal built from 2D/3D/4D simplex octaves. See [`Docs/musgrave_formulation.md`](Docs/musgrave_formulation.md) for formulas.

| Node | Dim | Inputs | Outputs | Defaults |
| ---- | --- | ------ | ------- | -------- |
| Musgrave2D | 2D | Position, Scale, Detail, Dimension, Lacunarity, Type | Out, Upper, Lower | Scale `1`, Detail `4`, Dimension `1`, Lacunarity `2`, Type `0` |
| Musgrave3D | 3D | (same) | (same) | (same) |
| Musgrave4D | 4D | (same) | (same) | (same) |

| Parameter | Description |
| --------- | ------------- |
| **Scale** | Multiplier on input coordinates before octaves (`x₀ = Scale × Position`). |
| **Detail** | Octave count; fractional values add a partial last octave (`N = floor(Detail)`, `r = fract(Detail)`). Capped at 15 octaves in HLSL. |
| **Dimension** | Amplitude decay per octave: `aᵢ = Lacunarity^(-i × Dimension)`. Larger → weaker high frequencies. |
| **Lacunarity** | Frequency multiplier per octave (`fᵢ = Lacunarity^i`). Must be > 1 (clamped to `1.000001` minimum). |
| **Type** | Fractal variant (integer; see table below). |

**Type** (`Type` property → `musgraveType` in HLSL):

| Value | Name | Behavior (summary) |
| ----- | ---- | -------------------- |
| `0` | fBm | Sum of weighted octave noises |
| `1` | Multifractal | Product `Π (1 + aᵢ · noise)` |
| `2` | Ridged multifractal | Sum of `aᵢ · (1 - \|noise\|)²` |
| `3` | Hybrid multifractal | Multiplicative weights across octaves |
| `4` | Heterogeneous terrain | `f += aᵢ · noise · f` (feedback) |

**Upper** / **Lower**: heuristic bounds for the current settings (used to normalize **Out**). Ridged: **Lower** = `0`. Multifractal: product lower bound. Hybrid / heterogeneous: symmetric heuristic (`±Upper`). See comments in `musgrave2D.hlsl`.

Internal noise is **simplex** (`snoise`), not classic Perlin.

---

### 4DNoise

Animated **3D slice** of 4D simplex noise (time drives the **w** axis).

| Node | Dim | Inputs | Outputs | Defaults |
| ---- | --- | ------ | ------- | -------- |
| 4DNoise | 4D | In | Out | In `(0,0,0,0)` |

| Parameter | Description |
| --------- | ------------- |
| **In** | Base `float4` position; **w** is offset by time inside the subgraph for smooth animation. |
| **Preview** | Keyword `_PREVIEW` (same role as Fractal). |

For static 4D sampling without built-in time, use **Noise4D** or **Fractal4D**.

---

## Requirements

- **Unity** `6000.3.14f1` (`ProjectSettings/ProjectVersion.txt`)
- **URP** `17.3.0` (`Packages/manifest.json`)
- **Shader Graph** (included with URP)

## Installation (OpenUPM)

Package: [jp.nobnak.snoise](https://openupm.com/packages/jp.nobnak.snoise/)

1. **Edit → Project Settings → Package Manager** → **Scoped Registries** → **+**

   | Field | Value |
   | ----- | ----- |
   | Name | OpenUPM |
   | URL | `https://package.openupm.com` |
   | Scope(s) | `jp.nobnak` |

2. **Window → Package Manager** → **My Registries** → install **Gradient Noise Nodes**, or **Add package by name**: `jp.nobnak.snoise`

## CPU API (Burst)

Core gradient noise is also available from C# (`Nobnak.Noise`), ported from the same HLSL. Results are deterministic for a given input; GPU bit-exact match is not guaranteed.

| Class | API |
| ----- | --- |
| `Simplex` | `SNoise(float2/3)`, `SNoise(float3, out float3 gradient)` |
| `Classic` | `CNoise(float2/3)`, `PNoise(float2/3, rep)` |
| `NoiseBatch` | `ScheduleSNoise` / `ScheduleCNoise` / `SchedulePNoise` (`NativeArray` + Burst Jobs) |

Requires `com.unity.mathematics`, `com.unity.burst`, `com.unity.collections`.

## Package layout

```
Packages/jp.nobnak.snoise/
├── Runtime/         # C# CPU noise (Simplex, Classic, NoiseBatch)
├── ShaderGraph/     # Subgraphs (Noises/, Apps/)
└── ShaderLibrary/   # HLSL (noise*.hlsl, cellular*.hlsl, Application/musgrave*.hlsl)
```

## Further documentation

- [`Docs/musgrave_formulation.md`](Docs/musgrave_formulation.md) — Musgrave math (Blender-aligned)
