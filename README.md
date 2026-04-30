# Gradient Noise Nodes (URP / Shader Graph)

**Gradient / cellular / fractal noise nodes** for Unity **Shader Graph**, shipped as the UPM package **`jp.nobnak.snoise`**.
This repo is a **Unity project** that embeds the package at `Packages/jp.nobnak.snoise/` and provides sample scenes/materials.

Base noise functions are a port of [Noise for GLSL](https://github.com/stegu/webgl-noise/) to Unity (HLSL).

## Quick start

| Goal | What to do |
| ---- | ---------- |
| Explore samples in **this** repo | Open the project in Unity (URP), then open `Assets/Scenes/Noises.unity` (and `Assets/Scenes/Warp.unity`) |
| Add the package to **your** project | Install **`jp.nobnak.snoise`** from OpenUPM (see [Installation (OpenUPM)](#installation-openupm)) |

## Demo

### Output (video)

[![Example02](http://img.youtube.com/vi/tglN3BLJ9fI/hqdefault.jpg)](https://youtu.be/tglN3BLJ9fI)

### Node list (screenshot)

![Nodes](Images/NoiseNodes02.png)

## Table of contents

- [Quick start](#quick-start)
- [Demo](#demo)
- [Overview](#overview)
- [Requirements](#requirements)
- [Installation (OpenUPM)](#installation-openupm)
- [What you get](#what-you-get)
- [Package layout](#package-layout)
- [Further documentation](#further-documentation)

## Overview

Shader Graph subgraphs + shared HLSL that cover:

- **Classic**: classic gradient noise (2D/3D/4D)
- **Noise**: value / simplex-style gradient noise variants (2D/3D/4D)
- **Cellular**: Worley / cellular noise (2D/3D + fast variants)
- **Fractal**: fBm-style fractal compositions (3D/4D)
- **Warp**: domain warping examples
- **Musgrave**: Blender-like Musgrave variants (2D/3D/4D)

## Requirements

- **Unity**: this repo is currently on **6000.3.14f1** (see `ProjectSettings/ProjectVersion.txt`)
- **URP**: **17.3.0** (see `Packages/manifest.json`)
- **Shader Graph**: included with URP

## Installation (OpenUPM)

The package is available on OpenUPM: [jp.nobnak.snoise](https://openupm.com/packages/jp.nobnak.snoise/).

### 1. Add scoped registry

1. Open **Edit → Project Settings → Package Manager**.
2. Under **Scoped Registries**, click **+** and set:

   | Field    | Value                         |
   | -------- | ----------------------------- |
   | Name     | OpenUPM                       |
   | URL      | `https://package.openupm.com` |
   | Scope(s) | `jp.nobnak`                   |

3. Click **Save**.

### 2. Add the package

1. Open **Window → Package Manager**.
2. Set **Packages:** to **My Registries** (or any list that includes OpenUPM).
3. Select **Gradient Noise Nodes** (`jp.nobnak.snoise`) and click **Install**.

Or use **Add package by name** and enter:

`jp.nobnak.snoise`

## What you get

| Area | Summary |
| ---- | ------- |
| Shader Graph | Subgraphs under `Packages/jp.nobnak.snoise/ShaderGraph/` (Noises / Apps) |
| HLSL | Shared functions under `Packages/jp.nobnak.snoise/ShaderLibrary/` |
| Samples (this repo) | Scenes under `Assets/Scenes/` and materials under `Assets/Materials/` |

## Package layout

Embedded package root (this repo):

`Packages/jp.nobnak.snoise/`

Main folders:

- `ShaderGraph/` — Shader Graph subgraphs (building blocks + apps)
- `ShaderLibrary/` — HLSL noise functions and app implementations

## Further documentation

- `Docs/musgrave_formulation.md` — Musgrave formulation notes (Blender-aligned)
