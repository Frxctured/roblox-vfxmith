# b9319fccafb2: oldstuff doesnt work well.rbxl :: ReplicatedStorage/Gojo_Skills

- Category: **beam**; tags: beam, fire, lightning, shockwave
- Layers: 37 emitters, 3 beams, 1 trails, 3 mesh parts, 3 lights; estimated length 7.0 s
- Fired by: saved running (Enabled + Rate)
- Pack file: `Older OS (2025 and older)/November 2023/oldstuff doesnt work well.rbxl` (instance referent 50040): cut it into Studio with `kit/scripts/rbxcut.py "<pack>/Older OS (2025 and older)/November 2023/oldstuff doesnt work well.rbxl" --ref 50040 --out <studio content>/vfxlib/fx_b9319fccafb2.rbxmx`
- Frames: none captured yet (play it with kit/studio/VFXLibPlayer.luau)

## Layers (one line each, in firing order; E emitter, B beam, T trail, P part, S script)
```
E Particle       | tex 1084996536 (A  Wave) | col #AA00FF | LE1 LI1 Br1 | life 1-1.5 | size const 12 | tr 1.00..0.40 vis 0.50-0.50 ->1.00 | spd 0.01 spread -360-360 rotSpd 250-500 | VelocityPerpendicular | locked | RATE 20 (continuous) | z 5
E Bolts          | tex 1084959112 | col #AA00FF | LE1 LI1 Br1 | life 0.333 | size const 20 | tr 0.88..0.13 vis 0.22-0.22 ->1.00 | spd 0 | FacingCamera | locked | RATE 6 (continuous) | z 5
E Bolts          | tex 1084959583 | col #AA00FF | LE1 LI1 Br1 | life 0.333 | size const 10 | tr 0.88..0.13 vis 0.22-0.22 ->1.00 | spd 0 | FacingCamera | locked | RATE 6 (continuous) | z 5
E Wave           | tex 376023896 | col #AA00FF | LE0 LI1 Br1 | life 1-1.5 | size const 10 | tr flat 0.80 | spd 0.01 spread -360-360 rotSpd 250-500 | VelocityPerpendicular | locked | RATE 100 (continuous) | z 5
E Particle       | tex 1084996536 (A  Wave) | col #FF0000 | LE1 LI1 Br1 | life 1-1.5 | size const 4 | tr 1.00..0.40 vis 0.50-0.50 ->1.00 | spd 0 rotSpd 250-500 | FacingCamera | locked | RATE 20 (continuous)
E Wave           | tex 376023896 | col #FF0000 | LE0.9 LI1 Br1 | life 1-1.5 | size const 3 | tr flat 0.90 | spd 0 rotSpd 250-500 | FacingCamera | locked | RATE 100 (continuous) | z -1
E Core           | tex 1084962479 (A  Core) | col #FF0000 | LE1 LI1 Br1 | life 1 | size const 4 | tr 1.00..0.00 vis 0.50-0.50 ->1.00 | spd 0 | FacingCamera | locked | RATE 3 (continuous) | z 1.1
E Wave           | tex 376023896 | col #0004FF | LE0.9 LI1 Br1 | life 1-1.5 | size const 3 | tr flat 0.90 | spd 0 rotSpd 250-500 | FacingCamera | locked | RATE 100 (continuous) | z -1
E Bolts          | tex 1084959112 | col #0004FF | LE1 LI1 Br1 | life 0.333 | size const 6 | tr 0.88..0.13 vis 0.22-0.22 ->1.00 | spd 0 | FacingCamera | locked | RATE 6 (continuous)
E Bolts          | tex 1084959583 | col #0004FF | LE1 LI1 Br1 | life 0.333 | size const 4 | tr 0.88..0.13 vis 0.22-0.22 ->1.00 | spd 0 | FacingCamera | locked | RATE 6 (continuous)
E Bolts          | tex 1084959312 (A  Bolts) | col #0004FF | LE1 LI1 Br1 | life 0.333 | size const 1 | tr 0.88..0.13 vis 0.22-0.22 ->1.00 | spd 0 | FacingCamera | locked | RATE 6 (continuous)
E Core           | tex 1084962479 (A  Core) | col #0004FF | LE1 LI1 Br1 | life 1 | size const 4 | tr 1.00..0.00 vis 0.50-0.50 ->1.00 | spd 0 | FacingCamera | locked | RATE 3 (continuous) | z 1.1
E ParticleEmitte | tex 619393574 (D Grid4x4 bg-clouds) | col #8CC6BE | LE0.5 LI0 Br1 | life 7 | size swell 8.47->9.45@0.84->0 | tr 1.00..0.71 vis 0.50-0.50 ->1.00 | spd 5 spread 10 rotSpd -10-10 | FacingCamera | RATE 20 (continuous) | z -0.5
E ParticleEmitte | tex 619393574 (D Grid4x4 bg-clouds) | col #8CC6BE | LE0.5 LI0 Br1 | life 7 | size swell 8.47->9.45@0.84->0 | tr 1.00..0.71 vis 0.50-0.50 ->1.00 | spd 5 spread 10 rotSpd -10-10 | FacingCamera | RATE 20 (continuous) | z -0.5
E Wave4          | tex 1084996536 (A  Wave) | col #5EFFB4 | LE1 LI0 Br1 | life 1-1.5 | size const 29 | tr 1.00..0.40 vis 0.50-0.50 ->1.00 | spd 0 rotSpd 20 | FacingCamera | locked | RATE 5 (continuous) | z 1
E Wave3          | tex 1084996536 (A  Wave) | col #9AFF6F | LE1 LI0 Br1 | life 1-1.5 | size const 27 | tr 1.00..0.40 vis 0.50-0.50 ->1.00 | spd 0 rotSpd 20 | FacingCamera | locked | RATE 5 (continuous) | z 1
E Wave2          | tex 1084996536 (A  Wave) | col #FFFFFF | LE1 LI1 Br1 | life 2 | size const 25 | tr 1.00..0.40 vis 0.50-0.50 ->1.00 | spd 0 | FacingCamera | locked | RATE 20 (continuous) | z 1
E Wave1          | tex 1084996536 (A  Wave) | col #35483D | LE1 LI1 Br1 | life 2 | size const 12 | tr 1.00..0.40 vis 0.50-0.50 ->1.00 | spd 0 | FacingCamera | locked | RATE 20 (continuous) | z 1
E Core           | tex 6827389541 | col #000000 | LE0 LI0 Br1 | life 1 | size const 8 | tr 1.00..0.00 vis 0.50-0.50 ->1.00 | spd 0 | FacingCamera | locked | RATE 10 (continuous) | z 1
E Wave           | tex 1084996536 (A  Wave) | col #0004FF | LE1 LI1 Br1 | life 1-1.5 | size const 1 | tr 1.00..0.40 vis 0.50-0.50 ->1.00 | spd 0 rotSpd 250-500 | FacingCamera | locked | RATE 100 (continuous)
E Bolts          | tex 1084959583 | col #0004FF | LE1 LI1 Br1 | life 0.333 | size const 0.7 | tr 0.88..0.13 vis 0.22-0.22 ->1.00 | spd 0 | FacingCamera | locked | RATE 6 (continuous)
E Bolts          | tex 1084959112 | col #0004FF | LE1 LI1 Br1 | life 0.333 | size const 1.25 | tr 0.88..0.13 vis 0.22-0.22 ->1.00 | spd 0 | FacingCamera | locked | RATE 6 (continuous)
E Bolts          | tex 1084959312 (A  Bolts) | col #0004FF | LE1 LI1 Br1 | life 0.333 | size const 1 | tr 0.88..0.13 vis 0.22-0.22 ->1.00 | spd 0 | FacingCamera | locked | RATE 6 (continuous)
E Circle         | tex 3467149276 | col #1100FF | LE1 LI1 Br1 | life 0.5 | size shrink 10->0 | tr flat 0.00 | spd 0 | FacingCamera | locked
E Bit            | tex 1084997326 (A  Bits_Small) | col #1100FF | LE1 LI1 Br1 | life 0.5 | size shrink 10->0 | tr 1.00..0.00 vis 0.15-1.00 ->0.00 | spd 0 | FacingCamera | locked
E Wave           | tex 1084996536 (A  Wave) | col #0004FF | LE1 LI1 Br1 | life 1-1.5 | size const 2 | tr 1.00..0.40 vis 0.50-0.50 ->1.00 | spd 0 rotSpd 250-500 | FacingCamera | locked | RATE 100 (continuous)
E Bolts          | tex 1084959112 | col #0004FF | LE1 LI1 Br1 | life 0.333 | size const 1.25 | tr 0.88..0.13 vis 0.22-0.22 ->1.00 | spd 0 | FacingCamera | locked | RATE 6 (continuous)
E Bolts          | tex 1084959583 | col #0004FF | LE1 LI1 Br1 | life 0.333 | size const 0.7 | tr 0.88..0.13 vis 0.22-0.22 ->1.00 | spd 0 | FacingCamera | locked | RATE 6 (continuous)
E Bolts          | tex 1084959312 (A  Bolts) | col #0004FF | LE1 LI1 Br1 | life 0.333 | size const 1 | tr 0.88..0.13 vis 0.22-0.22 ->1.00 | spd 0 | FacingCamera | locked | RATE 6 (continuous)
E Core           | tex 1084962479 (A  Core) | col #0004FF | LE1 LI1 Br1 | life 1 | size const 0.75 | tr 1.00..0.00 vis 0.50-0.50 ->1.00 | spd 0 | FacingCamera | locked | RATE 3 (continuous) | z 1.1
E ParticleEmitte | col #7E7E7E | LE0 LI1 Br1 | life 1 | size grow 0->1.64 | tr 0.00..0.00 vis 0.00-0.00 ->1.00 | spd 20 drag 6 | FacingCamera | RATE 15 (continuous) | z 1
E ParticleEmitte | col #7E7E7E | LE0 LI1 Br1 | life 1 | size grow 0->1.64 | tr 0.00..0.00 vis 0.00-0.00 ->1.00 | spd 20 drag 6 | FacingCamera | RATE 15 (continuous) | z 1
E Particle       | tex 1084961641 | col #FF0000 | LE1 LI0 Br1 | life 1-2 | size grow 0->5 | tr 0.00..0.00 vis 0.00-0.00 ->1.00 | spd 0 rotSpd -75-75 | FacingCameraWorldUp | locked | RATE 5 (continuous)
E Particle       | tex 1053548563 (A  Star1b) | col #FF0000 | LE1 LI0 Br1 | life 1-2 | size grow 0->5 | tr 0.00..0.00 vis 0.00-0.00 ->1.00 | spd 0 rotSpd -75-75 | FacingCameraWorldUp | locked | RATE 5 (continuous)
E Particle       | tex 1084996536 (A  Wave) | col #FF0000 | LE1 LI1 Br1 | life 1-1.5 | size shrink 0.874->0 | tr 1.00..0.40 vis 0.50-0.50 ->1.00 | spd 0 rotSpd 250-500 | FacingCamera | locked | RATE 20 (continuous)
E Particle       | tex 376023896 | col #FFFFFF | LE1 LI0 Br1 | life 0.5 | size const 0.25 | tr 0.00..0.00 vis 0.00-0.00 ->1.00 | spd 0 spread 360 rotSpd -50-50 | FacingCamera | locked | RATE 60 (continuous) | z -1
E Glass          | tex 281633012 | col #FFFFFF | LE1 LI1 Br1 | life 1-2 | size const 10 | tr 0.00..0.00 vis 0.00-0.50 ->1.00 | spd 15 spread 360 acc 0--100-0 rotSpd -200-200 | FacingCamera | z 5
T Trail          | col #1D00FF | LE1 LI1 Br1 | life 1.5 width shrink 1->0 | tr 0.00..0.00 vis 0.00-0.00 ->1.00 | tex Stretch 1 spd None
B Beam2          | tex 3517446796 (A  Beam) | col #FF0000 | LE1 LI1 Br1 | w 0.35-0.35 curve 1-0 seg 10 face | tr flat 0.00 | tex Wrap 3 spd -1
B Beam3          | tex 3517446796 (A  Beam) | col #FF0000 | LE1 LI1 Br1 | w 0.35-0.35 curve 0-1 seg 10 face | tr flat 0.00 | tex Wrap 3 spd -1
B Beam1          | tex 3517446796 (A  Beam) | col #FF0000 | LE1 LI1 Br1 | w 0.35-0.35 curve 0-1 seg 10 face | tr flat 0.00 | tex Wrap 3 spd -1
P {"k": "Part", "name": "Line", "size": [10.0, 0.05, 0.05], "mat": "Neon", "transp": 0.0}
P {"k": "Part", "name": "Blue2", "size": [0.37881, 0.37881, 0.37881], "mat": "Neon", "transp": 0.0}
P {"k": "MeshPart", "name": "Outline", "size": [0.38828, 0.38828, 0.38828], "mat": "Neon", "transp": 0.0, "mesh": 4773168060}
P {"k": "Part", "name": "Rock", "size": [3.0, 3.0, 3.0], "mat": "Plastic", "transp": 0.0}
P {"k": "Part", "name": "Red", "size": [0.37881, 0.37881, 0.37881], "mat": "Neon", "transp": 0.0}
P {"k": "MeshPart", "name": "Outline", "size": [0.38828, 0.38828, 0.38828], "mat": "Neon", "transp": 0.0, "mesh": 4773168060}
P {"k": "MeshPart", "name": "Barrier", "size": [160.0, 160.0, 160.0], "mat": "Neon", "transp": 0.0, "mesh": 7220375352}
S Script Script len287 flags=delay
```
