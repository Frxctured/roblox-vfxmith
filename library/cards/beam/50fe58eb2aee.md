# 50fe58eb2aee: oldstuff doesnt work well.rbxl :: Workspace/Wado Ichimonji

- Category: **beam**; tags: aura, beam, fire, lightning, smoke, star
- Layers: 7 emitters, 5 beams, 0 trails, 0 mesh parts, 1 lights; estimated length 0.8 s
- Fired by: saved running (Enabled + Rate)
- Pack file: `Older OS (2025 and older)/November 2023/oldstuff doesnt work well.rbxl` (instance referent 23053). Watch it in Studio: `kit/scripts/rbxcut.py --id 50fe58eb2aee --studio`, then `P.load("fx_50fe58eb2aee")` (needs the pack: `kit/scripts/get_pack.py`)
- Frames: none captured yet (play it with kit/studio/VFXLibPlayer.luau)

## Layers (one line each, in firing order; E emitter, B beam, T trail, P part, S script)
```
E Lightning1     | tex 11492870634 (M Grid4x4 Lightning) | col #4F23FF | LE1 LI0 Br5 | life 0.4-0.6 | size const 0.4 | tr 0.00..0.00 vis 0.00-0.86 ->1.00 | spd 0.001 spread -360-360 | FacingCamera | flip Grid4x4 OneShot 1 | locked | EMIT 2 @0 | z 3
E Specs1         | tex 1084996976 (A  ParticleEmit) | col #4F23FF | LE1 LI0 Br5 | life 0.8 | size swell 0->0.188@0.41->0 | tr flat 0.00 | spd 2.7-3.1 drag 1.3 spread -360-360 rotSpd -25-25 | VelocityParallel | squash swell 0->0.148@0.50->0 | locked | RATE 78 (continuous) | z -1.1
E Lightning2     | tex 11492870634 (M Grid4x4 Lightning) | col #4F23FF | LE1 LI0 Br5 | life 0.4-0.6 | size const 2.25 | tr 0.00..0.00 vis 0.00-0.86 ->1.00 | spd 0.001 spread -360-360 | FacingCamera | flip Grid4x4 OneShot 1 | locked | EMIT 2 @0 | z 3
E Smoke1         | tex 12412552354 | col #4F23FF | LE1 LI0 Br1 | life 0.75 | size grow 0->2 | tr 1.00..0.93 vis 0.50-0.50 ->1.00 | spd 1.1-2.4 drag 1.3 spread -360-360 rotSpd -50-50 | FacingCamera | squash swell 0->0.148@0.50->0 | flip Grid2x2 OneShot 1 | locked | RATE 45 (continuous) | z -1.1
E Aura1          | tex 11341746334 (M  Aura1) | col #4F23FF | LE1 LI0 Br3 | life 0.4-0.55 | size swell 0->0.5@0.40->0 | tr 1.00..0.00 vis 0.50-0.50 ->1.00 | spd 1.1-2.8 drag 1.3 spread -360-360 rotSpd -50-50 | FacingCamera | squash swell 0->0.148@0.50->0 | locked | RATE 78 (continuous) | z -1.1
E FLARE1         | tex 10598374841 (A Grid2x2 Star99) | col #4F23FF | LE1 LI0 Br5 | life 0.4-0.6 | size const 1 | tr 1.00..0.00 vis 0.25-0.75 ->1.00 | spd 0.001 | FacingCamera | squash const -0.35 | locked | EMIT 2 @0 | z 3
E ParticleEmitte | tex 10151994092 | col #4F23FF | LE1 LI0 Br1 | life 0.7 | size swell 0->1.18@0.20->0.673 | tr 1.00..0.82 vis 0.27-0.27 ->1.00 | spd 5 drag 2 spread 0-360 acc 0--75-0 | VelocityParallel | squash grow 0->-0.323 | locked | EMIT 55 @0 | z 1.45
B Beam4          | tex 10528782340 (A  Beam) | col #4F23FF | LE1 LI0 Br1 | w 0.8-5.3 curve 0-0 seg 10 face | tr 1.00..0.88 vis 0.50-0.50 ->1.00 | tex Stretch 0.35 spd 0.45
B Beam5          | tex 12191903502 (M  4) | col #4F23FF | LE1 LI0 Br5 | w 1.65-1.3 curve 0-0 seg 10 face | tr 1.00..0.00 vis 0.51-0.51 ->1.00 | tex Stretch 0.85 spd 1.3 | z 0.1
B Beam3          | tex 11624551967 | col #4F23FF | LE1 LI0 Br3 | w 3-3 curve 0-0 seg 10 face | tr 1.00..0.00 vis 0.51-0.51 ->1.00 | tex Stretch 0.35 spd 0.45
B Beam1          | tex 12414458390 | col #4F23FF | LE1 LI0 Br5 | w 1.65-1.3 curve 0-0 seg 10 face | tr 1.00..0.00 vis 0.51-0.51 ->1.00 | tex Stretch 0.85 spd 1.3 | z 0.1
B Beam2          | tex 12191903502 (M  4) | col #4F23FF | LE1 LI0 Br1 | w 2-5 curve 0-0 seg 10 face | tr 1.00..0.86 vis 0.50-0.50 ->1.00 | tex Stretch 0.5 spd 0.8 | z 0.1
P {"k": "UnionOperation", "name": "Blade", "size": [4.84683, 0.23043, 0.05], "mat": "SmoothPlastic", "transp": 0.0}
P {"k": "UnionOperation", "name": "Tsuba", "size": [0.10269, 0.8, 0.64354], "mat": "SmoothPlastic", "transp": 0.0}
P {"k": "UnionOperation", "name": "Tsuka", "size": [0.14574, 1.50818, 0.24687], "mat": "SmoothPlastic", "transp": 0.0}
P {"k": "UnionOperation", "name": "Fuchi", "size": [0.26, 0.05, 0.156], "mat": "SmoothPlastic", "transp": 0.0}
P {"k": "UnionOperation", "name": "Kashira", "size": [0.15928, 0.14845, 0.27022], "mat": "SmoothPlastic", "transp": 0.0}
P {"k": "Part", "name": "Habaki", "size": [0.05004, 0.05004, 0.28023], "mat": "SmoothPlastic", "transp": 0.0}
```
