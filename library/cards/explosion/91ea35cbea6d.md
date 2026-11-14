# 91ea35cbea6d: errything.rbxm :: Model/fiery

- Category: **explosion**; tags: aura, explosion, fire
- Layers: 24 emitters, 2 beams, 0 trails, 4 mesh parts, 0 lights; estimated length 7.74 s
- Fired by: saved running (Enabled + Rate)
- Pack file: `Older OS (2025 and older)/November 2023/errything.rbxm` (instance referent 32442). Watch it in Studio: `kit/scripts/rbxcut.py --id 91ea35cbea6d --studio`, then `P.load("fx_91ea35cbea6d")` (needs the pack: `kit/scripts/get_pack.py`)
- Frames: none captured yet (play it with kit/studio/VFXLibPlayer.luau)

## Layers (one line each, in firing order; E emitter, B beam, T trail, P part, S script)
```
E aura           | tex 7216848219 (M  aura) | col #FF480B | LE-2 LI0 Br15 | life 1 | size swell 0->2.47@0.67->0 | tr 1.00..0.00 vis 0.41-0.41 ->1.00 | spd 40 spread 200 acc 0-40-0 | VelocityParallel | squash grow 0->0.975 | locked | RATE 35 (continuous) | z 3
E aura           | tex 7216848219 (M  aura) | col #000000 | LE-2 LI0 Br4.8 | life 1.5 | size swell 0->2.47@0.67->0 | tr 1.00..0.00 vis 0.41-0.41 ->1.00 | spd 10 spread 200 acc 0-10-0 | VelocityParallel | squash grow 0->0.975 | locked | RATE 35 (continuous) | z 3
E aura           | tex 7216848219 (M  aura) | col #FF300C | LE-2 LI0 Br100 | life 1 | size swell 0->2.47@0.67->0 | tr 1.00..0.00 vis 0.41-0.41 ->1.00 | spd 30 spread 200 acc 0-30-0 | VelocityParallel | squash grow 0->0.975 | locked | RATE 35 (continuous) | z 3
E ParticleEmitte | tex 11846119288 (D Grid4x4 11.n) | col #FF431D | LE-1 LI0 Br10 | life 0.5-0.8 | size swell 1->4.38@0.73->4.07 | tr flat 0.00 | spd 30 spread 360 acc 0-100-0 rotSpd -40-60 | FacingCameraWorldUp | flip Grid4x4 OneShot 1 | locked | RATE 35 (continuous)
E ParticleEmitte | tex 13736805356 (D Grid4x4 wavy') | col #FF3E1C | LE-1 LI0 Br10 | life 0.6-0.9 | size grow 0->20 | tr 1.00..0.00 vis 0.50-0.50 ->1.00 | spd 0.001 rotSpd -70-70 | VelocityPerpendicular | flip Grid4x4 Loop 15-20 | locked | RATE 7 (continuous)
E behind aura    | tex 11813039262 (D Grid4x4 Aura) | col #0F0907 | LE-5 LI0.4 Br300 | life 0.9-1 | size swell 0.188->1.48@0.50->0 | tr 0.60..0.00 vis 0.61-1.00 ->0.00 | spd 12 drag 1.5 spread 80 acc 0-20-0 rotSpd 0-20 | FacingCamera | flip Grid4x4 OneShot 30 | locked | RATE 100 (continuous) | z -1
E behind aura    | tex 11813039262 (D Grid4x4 Aura) | col #FF6619 | LE-5 LI0.4 Br300 | life 0.9-1 | size swell 0.188->1.48@0.50->0 | tr 0.60..0.00 vis 0.61-1.00 ->0.00 | spd 12 drag 1.5 spread 80 acc 0-20-0 rotSpd 0-20 | FacingCamera | flip Grid4x4 OneShot 30 | locked | RATE 300 (continuous) | z -2
E behind aura    | tex 11813039262 (D Grid4x4 Aura) | col #FF3705 | LE-2 LI0.75 Br300 | life 0.9-1 | size swell 0.188->0.875@0.50->0 | tr 0.60..0.00 vis 0.61-1.00 ->0.00 | spd 6 drag 1.5 spread 80 acc 0-20-0 rotSpd 0-20 | FacingCamera | flip Grid4x4 OneShot 30 | locked | RATE 300 (continuous) | z 4
E ParticleEmitte | tex 13736805356 (D Grid4x4 wavy') | col #FF330F | LE-3 LI0 Br40 | life 0.6-0.9 | size grow 0->40 | tr 1.00..0.00 vis 0.50-0.50 ->1.00 | spd 0.001 rotSpd -70-70 | VelocityPerpendicular | flip Grid4x4 Loop 15-20 | locked | RATE 7 (continuous)
E ParticleEmitte | tex 14508109029 | col #DF2D01 | LE-2 LI0 Br100 | life 0.7-1.2 | size swell 0->0.247@0.28->0 | tr 1.00..0.15 vis 0.08-0.90 ->1.00 | spd 1 drag 2.25 spread 50 acc -3-3-0 rotSpd 60 | FacingCamera | flip Grid4x4 Loop 25.8 | locked | RATE 20 (continuous) | z 2
E EyeLight       | tex 7216848960 (M  EyeLight) | col #DF2D01 | LE1 LI0 Br10 | life 4 | size const 0.5 | tr 1.00..0.01 vis 0.50-0.50 ->1.00 | spd 0.01 | FacingCamera | squash const -0.2 | locked | RATE 1 (continuous) | z 3
B Leam           | tex 14654650241 (M  Leam) | col #DF2D01 | LE1 LI0 Br5.5 | w 5-8 curve 2-0 seg 10 face | tr 1.00..0.00 vis 0.13-0.50 ->1.00 | tex Stretch 0.5 spd 0.8 | z -1
B Ream           | tex 14654650241 (M  Leam) | col #DF2D01 | LE1 LI0 Br5.5 | w 5-8 curve -2-0 seg 10 face | tr 1.00..0.00 vis 0.50-0.50 ->1.00 | tex Stretch 0.5 spd 0.8 | z -1
E explosion      | tex 8090715771 (D  SpecDash) | col #FF1A1A | LE-2 LI0 Br10 | life 0.3-1.5 | size shrink 5.74->1.05 | tr flat 0.00 | spd 20-50 drag 2.25 spread 80 | VelocityParallel | EMIT 50 @0.06 | z 2
E explosion      | tex 1084970835 (A  ParticleEmit) | col #8D1F09 | LE1 LI0 Br20 | life 0.3-1.5 | size swell 0->1.31@0.69->0 | tr flat 0.00 | spd 60-100 drag 5 spread 360 | FacingCamera | EMIT 40 @0.08 | z 2
E explosion      | tex 9781687320 (A  2) | col #FF3810 | LE1 LI0 Br20 | life 0.3-1.5 | size swell 0->1.31@0.69->0 | tr flat 0.00 | spd 60-100 drag 5 spread 360 | FacingCamera | EMIT 40 @0.08 | z 2
E explosion      | tex 9781687320 (A  2) | col #FF0000 | LE1 LI0 Br100 | life 0.3-1.5 | size swell 0->1.31@0.69->0 | tr flat 0.00 | spd 80-150 drag 10 spread 360 | FacingCamera | EMIT 40 @0.08 | z 0.35
E explosion      | tex 12757089364 (D Grid4x4 explosion) | col #DF2D01 | LE0.5 LI0 Br100 | life 0.5-1 | size shrink 0.556->0.309 | tr flat 0.00 | spd 2-3 drag 20 spread 80 rotSpd -30-30 | FacingCamera | flip Grid4x4 OneShot 1 | locked | EMIT 50 @0.08 | z -1
E explosion      | tex 12757089364 (D Grid4x4 explosion) | col #DF2D01 | LE0.5 LI0 Br100 | life 0.5-1 | size shrink 0.556->0.309 | tr flat 0.00 | spd 2-3 drag 20 spread 80 rotSpd -30-30 | FacingCamera | flip Grid4x4 OneShot 1 | locked | EMIT 50 @0.08 | z -1
E explosion      | tex 12757089364 (D Grid4x4 explosion) | col #DF2D01 | LE0.5 LI0 Br100 | life 0.5-1 | size shrink 0.556->0.309 | tr flat 0.00 | spd 2-3 drag 20 spread 80 rotSpd -30-30 | FacingCamera | flip Grid4x4 OneShot 1 | locked | EMIT 50 @0.08 | z -1
E explosion      | tex 12757089364 (D Grid4x4 explosion) | col #DF2D01 | LE0.5 LI0 Br100 | life 0.5-1 | size shrink 0.556->0.309 | tr flat 0.00 | spd 2-3 drag 20 spread 80 rotSpd -30-30 | FacingCamera | flip Grid4x4 OneShot 1 | locked | EMIT 50 @0.08 | z -1
E explosion      | tex 12757089364 (D Grid4x4 explosion) | col #DF2D01 | LE0.5 LI0 Br100 | life 0.5-1 | size shrink 0.556->0.309 | tr flat 0.00 | spd 2-3 drag 20 spread 80 rotSpd -30-30 | FacingCamera | flip Grid4x4 OneShot 1 | locked | EMIT 50 @0.08 | z -1
E explosion      | tex 12757089364 (D Grid4x4 explosion) | col #DF2D01 | LE0.5 LI0 Br100 | life 0.5-1 | size shrink 0.556->0.309 | tr flat 0.00 | spd 2-8 drag 15 spread 360 rotSpd -30-30 | FacingCamera | flip Grid4x4 OneShot 1 | locked | EMIT 50 @0.08 | z -0.5
E clashcircle3   | tex 10558510611 (M  clashcircle2) | col #FF3806 | LE-5 LI0 Br10 | life 0.75-1.2 | size grow 0->34 | tr 1.00..0.00 vis 0.30-0.70 ->1.00 | spd 0.001 spread 10 rotSpd 900-1.2e+03 | VelocityPerpendicular | locked | EMIT 10 @6.54 | z 2
E clashcircle2   | tex 10558510611 (M  clashcircle2) | col #000000 | LE-1 LI0 Br10 | life 0.75-1.2 | size const 14 | tr 1.00..0.00 vis 0.50-0.50 ->1.00 | spd 0.001 spread 10 rotSpd 900-1.2e+03 | VelocityPerpendicular | locked | EMIT 10 @6.54 | z 1.5
E clashcircle2   | tex 10558510611 (M  clashcircle2) | col #FF4406 | LE1 LI0 Br10 | life 0.75-1.2 | size grow 0->13.9 | tr 1.00..0.00 vis 0.50-0.50 ->1.00 | spd 0.001 spread 20 rotSpd 900-1.2e+03 | VelocityPerpendicular | locked | EMIT 10 @6.54 | z 1.5
P {"k": "MeshPart", "name": "HandGuard", "size": [0.494, 0.04225, 0.62075], "mat": "Plastic", "transp": 0.0, "mesh": 6840699890, "meshTex": 6840699932}
P {"k": "MeshPart", "name": "Blade", "size": [0.0195, 3.2175, 0.60125], "mat": "Plastic", "transp": 0.0, "mesh": 6840700033, "meshTex": 6840700083}
P {"k": "MeshPart", "name": "Handle", "size": [0.0845, 1.755, 0.377], "mat": "Plastic", "transp": 0.0, "mesh": 6840699720, "meshTex": 6840699763}
P {"k": "Part", "name": "Right Leg", "size": [1.0, 2.0, 1.0], "mat": "Plastic", "transp": 0.0}
P {"k": "Part", "name": "Left Leg", "size": [1.0, 2.0, 1.0], "mat": "Plastic", "transp": 0.0}
P {"k": "Part", "name": "Right Arm", "size": [1.0, 2.0, 1.0], "mat": "Plastic", "transp": 0.0}
P {"k": "Part", "name": "Left Arm", "size": [1.0, 2.0, 1.0], "mat": "Plastic", "transp": 0.0}
P {"k": "Part", "name": "Torso", "size": [2.0, 2.0, 1.0], "mat": "Plastic", "transp": 0.0}
P {"k": "Part", "name": "Head", "size": [2.0, 1.0, 1.0], "mat": "Plastic", "transp": 0.0}
P {"k": "MeshPart", "name": "Hair", "size": [3.05936, 2.31794, 2.48509], "mat": "SmoothPlastic", "transp": 0.0, "mesh": 5470423963, "meshTex": 5470378157}
```
