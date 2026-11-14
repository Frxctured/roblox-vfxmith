# 4bfcdc5efaec: yinandchang.rbxl :: ReplicatedStorage/Assets/Particles/Yinlin/explosion

- Category: **explosion**; tags: explosion, fire, flash, floor, shockwave
- Layers: 34 emitters, 0 beams, 0 trails, 0 mesh parts, 0 lights; estimated length 4.88 s
- Fired by: EmitCount attributes
- Pack file: `Older OS (2025 and older)/Oct 2024 - Jan 2025/yinandchang.rbxl` (instance referent 3349): cut it into Studio with `kit/scripts/rbxcut.py "<pack>/Older OS (2025 and older)/Oct 2024 - Jan 2025/yinandchang.rbxl" --ref 3349 --out <studio content>/vfxlib/fx_4bfcdc5efaec.rbxmx`
- Frames: none captured yet (play it with kit/studio/VFXLibPlayer.luau)

## Layers (one line each, in firing order; E emitter, B beam, T trail, P part, S script)
```
E testshock      | tex 17035480360 | col #A470FE->#000000 | LE-0.5 LI0 Br3 | life 0.3 | size grow 0->38.8 | tr 0.57..0.57 vis 0.00-0.00 ->1.00 | spd 0.0026 | FacingCamera | EMIT 1 @0
E testshock      | tex 17035480360 | col #A470FE->#000000 | LE-0.5 LI0 Br3 | life 0.3 | size grow 0->39 | tr 0.63..0.60 vis 0.39-0.39 ->1.00 | spd 0.0026 | VelocityPerpendicular | EMIT 1 @0
E 2              | tex 17317111249 (D Grid4x4 spikes 1) | col #A470FE->#000000 | LE-0.5 LI0 Br3.25 | life 0.3-0.4 | size grow 0->34.2 | tr 0.00..0.00 vis 0.00-0.39 ->1.00 | spd 0.0026 spread 5 | VelocityPerpendicular | squash grow 0->0.185 | flip Grid4x4 OneShot 1 | EMIT 5 @0 | z -0.1
E shockwave1     | tex 8172249266 (D  Wave) | col #A470FE->#000000 | LE-0.5 LI0 Br3 | life 0.3 | size grow 0->38.8 | tr 0.29..0.29 vis 0.00-0.00 ->1.00 | spd 0.0026 | FacingCamera | EMIT 1 @0
E shockwave      | tex 8172249266 (D  Wave) | col #A470FE->#000000 | LE-0.5 LI0 Br3 | life 0.3 | size grow 0->39 | tr 0.40..0.40 vis 0.00-0.00 ->1.00 | spd 0.0026 | VelocityPerpendicular | EMIT 1 @0
E cresent1       | tex 10558510611 (M  clashcircle2) | col #A470FE | LE-0.5 LI0 Br10 | life 0.25 | size grow 0->25.8 | tr 0.00..0.00 vis 0.00-0.39 ->1.00 | spd 0.0026 spread 90 rotSpd 700 | VelocityPerpendicular | EMIT 1 @0 | z -0.5
E cresent        | tex 10558510611 (M  clashcircle2) | col #A470FE | LE-0.5 LI0 Br10 | life 0.3 | size grow 0->23.5 | tr 0.00..0.00 vis 0.00-0.39 ->1.00 | spd 0.0026 spread 90 rotSpd -700 | VelocityPerpendicular | EMIT 1 @0
E 3              | tex 17317111249 (D Grid4x4 spikes 1) | col #A470FE->#000000 | LE-0.5 LI0 Br3.25 | life 0.3-0.35 | size grow 0->34.2 | tr 0.00..0.00 vis 0.00-0.39 ->1.00 | spd 0.0026 spread 150 | VelocityPerpendicular | squash grow 0->0.498 | flip Grid4x4 OneShot 1 | EMIT 4 @0 | z -0.25
E 2              | tex 17317111249 (D Grid4x4 spikes 1) | col #A470FE->#000000 | LE-0.5 LI0 Br3.25 | life 0.3-0.4 | size grow 0->34.2 | tr 0.00..0.00 vis 0.00-0.39 ->1.00 | spd 0.0026 spread 120 | VelocityParallel | squash grow 0->0.185 | flip Grid4x4 OneShot 1 | EMIT 8 @0 | z -0.25
E Shard          | tex 15008355158 | col #A470FE | LE-1 LI0 Br5 | life 0.0952-0.19 | size swell 0->9.92@0.29->0 | tr flat 0.00 | spd 96-192 drag 2 spread 369 | VelocityParallel/Disc | squash grow 0->2.48 | locked | EMIT 5 @0 | z 0.599
E Shard          | tex 14271209798 (D Grid4x4 Shard) | col #E24CEE | LE-3 LI0 Br15 | life 0.0714-0.214 | size swell 0->13.1@0.30->0 | tr flat 0.00 | spd 139-418 drag 47.6 spread 360 | VelocityParallel/Disc | squash grow 0->3 | flip Grid4x4 OneShot 26.6 | locked | EMIT 7 @0 | z 0.93
E ParticleEmitte | tex 16335927774 | col #A470FE | LE1 LI0.015 Br15 | life 0.488-2.5 | size swell 0.389->0.51@0.76->0 | tr 1.00..0.00 vis 0.36-0.52 ->1.00 | spd 3.89-31.1 drag 4 spread 90 acc 0-31.1-0.311 | VelocityParallel/Disc | squash swell 0->0.3@0.46->-0.863 | locked | EMIT 9 @0
E Black Cresents | tex 17085222506 (M Grid4x4 Black Cresen) | col #000000 | LE0 LI0 Br0.1 | life 0.8-1.8 | size grow 0->36.8 | tr 1.00..0.80 vis 0.10-0.10 ->1.00 | spd 0.0016 drag 2 spread 7 rotSpd -75-75 | VelocityPerpendicular | flip Grid4x4 OneShot 1 | locked | EMIT 5 @0
E Shock          | tex 15603804067 | col #A470FE | LE-5 LI0 Br10 | life 0.2 | size grow 0->46.7 | tr 0.00..0.00 vis 0.00-0.00 ->1.00 | spd 0.234 spread 380 | VelocityPerpendicular | EMIT 2 @0
E Ground Marks 3 | tex 17061494025 | col #A470FE->#050200->#000000 | LE0 LI0 Br8 | life 0.7-1.2 | size const 9.6 | tr 1.00..0.00 vis 0.03-1.00 ->0.00 | spd 0.0016 | VelocityPerpendicular | flip Grid4x4 OneShot 1 | EMIT 1 @0 | z 0.001
E Ground Marks 2 | tex 17061494025 | col #A470FE->#050200->#000000 | LE0 LI0 Br8 | life 0.7-1.2 | size const 12.8 | tr 1.00..0.00 vis 0.03-1.00 ->0.00 | spd 0.0016 | VelocityPerpendicular | flip Grid4x4 OneShot 1 | EMIT 1 @0 | z 0.001
E flash          | tex 16917609331 | col #A470FE | LE-2 LI0 Br14 | life 0.3 | size const 33.6 | tr flat 0.00 | spd 0.0016 | VelocityPerpendicular | flip Grid4x4 OneShot 1 | EMIT 2 @0
E Pulse          | tex 17455015143 | col #A470FE | LE-5 LI0 Br10 | life 0.15 | size grow 0->32 | tr 0.00..0.00 vis 0.00-0.00 ->1.00 | spd 0.016 | VelocityPerpendicular | locked | EMIT 1 @0
E FLAME SHARDS 2 | tex 15413764911 (D Grid4x4 FL121AME SHA) | col #E24CEE | LE0 LI0 Br14 | life 0.3-0.8 | size grow 0->14.4 | tr flat 0.00 | spd 8-96 drag 8 spread 100 | VelocityParallel | squash const 0.485 | flip Grid4x4 OneShot 1 | EMIT 10 @0 | z 1
E FLAME SHARDS   | tex 15413764911 (D Grid4x4 FL121AME SHA) | col #A470FE | LE0 LI0 Br8 | life 0.3-0.8 | size grow 0->14.4 | tr flat 0.00 | spd 8-96 drag 8 spread 100 | VelocityParallel | squash const 0.485 | flip Grid4x4 OneShot 1 | EMIT 10 @0 | z 1
E ParticleEmitte | tex 15873103785 | col #ECAEFE | LE1 LI0 Br15 | life 0.488-4.88 | size swell 0->0.366@0.10->0 | tr flat 0.00 | spd 4.25-47.2 drag 2.87 spread 55 acc 0-2.62-0.136 rotSpd -147-147 | VelocityParallel/Disc | squash swell 0.825->0.825@0.00->-0.0375 | locked | EMIT 15 @0 | z -5.16
E Cresents       | tex 17085222506 (M Grid4x4 Black Cresen) | col #212121 | LE0.2 LI0 Br0.5 | life 0.4-0.8 | size grow 0->36.8 | tr 1.00..0.65 vis 0.10-0.10 ->1.00 | spd 0.0016 drag 2 spread 360 rotSpd -60-60 | VelocityPerpendicular | flip Grid4x4 OneShot 1 | locked | EMIT 9 @0
E Ground Marks   | tex 17061494025 | col #A470FE->#000000 | LE0 LI0 Br8 | life 0.7-1.2 | size const 17.6 | tr 1.00..0.00 vis 0.03-1.00 ->0.00 | spd 0.0016 | VelocityPerpendicular | flip Grid4x4 OneShot 1 | EMIT 1 @0 | z 0.001
E ParticleEmitte | tex 15873103785 | col #A470FE | LE1 LI0 Br15 | life 1.12-2.5 | size swell 0.403->0.604@0.10->0 | tr flat 0.00 | spd 33.6-54.6 drag 1.6 spread 75 acc 0--42-0 | VelocityParallel/Disc | squash swell 0->3@0.96->1.8 | locked | EMIT 12 @0
E shards `       | tex 16171607099 (D  LinesWhite) | col #E24CEE | LE0 LI0 Br15 | life 0.2-0.3 | size swell 0->2.4@0.10->0 | tr flat 0.00 | spd 96-184 drag 7 spread 90 acc 0--9.6-0 | VelocityParallel | locked | EMIT 15 @0
E shards 2 purpl | tex 16171607099 (D  LinesWhite) | col #A470FE | LE0 LI0 Br20 | life 0.3-0.9 | size swell 0->2.4@0.10->0 | tr flat 0.00 | spd 64-136 drag 4.5 spread 85 acc 0--27.2-0 | VelocityParallel | locked | EMIT 12 @0
E shards 2 orang | tex 16171607099 (D  LinesWhite) | col #A470FE | LE-5 LI0 Br15 | life 0.3-0.9 | size swell 0->2.4@0.10->0 | tr flat 0.00 | spd 64-136 drag 4.5 spread 85 acc 0--27.2-0 | VelocityParallel | locked | EMIT 12 @0
E embers         | tex 9997556038 (M  ParticleEmit) | col #A470FE | LE-5 LI0 Br15 | life 0.4-1.4 | size swell 0->2.08@0.14->0 | tr flat 0.00 | spd 64-112 drag 4 spread 80 acc 0--24-0 rotSpd -100-100 | FacingCamera | locked | EMIT 10 @0
E shockwave2     | tex 10553903882 (A  51) | col #E24CEE | LE1 LI0 Br5 | life 0.1 | size grow 0->40 | tr 0.70..0.70 vis 0.00-0.00 ->1.00 | spd 0.0016 | FacingCamera | EMIT 1 @0
E Glow           | tex 17061556158 (M  31) | col #A470FE | LE0 LI0 Br15 | life 0.2 | size const 40 | tr 1.00..0.62 vis 0.10-0.10 ->1.00 | spd 0.0016 | FacingCamera | EMIT 1 @0
E Shockwave      | tex 17487703808 | col #A470FE | LE-5 LI0 Br20 | life 0.1 | size grow 0->51.2 | tr 0.26..0.26 vis 0.00-0.00 ->1.00 | spd 0.0016 | FacingCamera | EMIT 3 @0 | z 5
E Flash          | tex 14006783533 (M  Flash) | col #A470FE | LE0 LI0 Br8 | life 0.08 | size grow 0->48 | tr flat 0.00 | spd 0 spread -360-360 | FacingCamera | EMIT 1 @0 | z 6
E Flash          | tex 10293208499 (A  15) | col #A470FE | LE0 LI0 Br8 | life 0.08 | size grow 0->40 | tr flat 0.00 | spd 0 spread -360-360 | FacingCamera | EMIT 1 @0 | z 6
E Glow2          | tex 17061556158 (M  31) | col #A470FE | LE0 LI0 Br15 | life 0.5 | size const 43.2 | tr 1.00..0.84 vis 0.10-0.10 ->1.00 | spd 0.0016 | VelocityPerpendicular | EMIT 1 @0 | z 0.001
```
