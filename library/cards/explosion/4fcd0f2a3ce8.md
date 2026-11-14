# 4fcd0f2a3ce8: errything.rbxm :: Model/TemplateR6

- Category: **explosion**; tags: beam, explosion, fire
- Layers: 12 emitters, 23 beams, 0 trails, 0 mesh parts, 0 lights; estimated length 7.54 s
- Fired by: its own scripts (not included in the card)
- Pack file: `Older OS (2025 and older)/November 2023/errything.rbxm` (instance referent 26818): cut it into Studio with `kit/scripts/rbxcut.py "<pack>/Older OS (2025 and older)/November 2023/errything.rbxm" --ref 26818 --out <studio content>/vfxlib/fx_4fcd0f2a3ce8.rbxmx`
- Frames: none captured yet (play it with kit/studio/VFXLibPlayer.luau)

## Layers (one line each, in firing order; E emitter, B beam, T trail, P part, S script)
```
E ParticleEmitte | tex 13736805356 (D Grid4x4 wavy') | col #0F0F0F | LE-3 LI0 Br40 | life 0.6-0.9 | size grow 0->40 | tr 1.00..0.77 vis 0.50-0.50 ->1.00 | spd 0.001 rotSpd -70-70 | VelocityPerpendicular | flip Grid4x4 Loop 15-20 | locked | RATE 7 (continuous)
E EyeLight       | tex 7216848960 (M  EyeLight) | col #FF0004 | LE-1 LI0 Br100 | life 4 | size const 0.5 | tr 1.00..0.01 vis 0.50-0.50 ->1.00 | spd 0.01 | FacingCamera | squash const -0.2 | locked | RATE 1 (continuous) | z 3
E ParticleEmitte | tex 14508109029 | col #FF0004 | LE-2 LI0 Br100 | life 0.7-1.2 | size swell 0->0.247@0.28->0 | tr 1.00..0.15 vis 0.08-0.90 ->1.00 | spd 1 drag 2.25 spread 50 acc 7--3-0 rotSpd 60 | FacingCamera | flip Grid4x4 Loop 25.8 | locked | RATE 20 (continuous) | z 2
E EyeLight       | tex 7216848960 (M  EyeLight) | col #FF0004 | LE-1 LI0 Br100 | life 4 | size const 0.5 | tr 1.00..0.01 vis 0.50-0.50 ->1.00 | spd 0.01 | FacingCamera | squash const -0.2 | locked | RATE 1 (continuous) | z 3
E ParticleEmitte | tex 14508109029 | col #FF0004 | LE-2 LI0 Br100 | life 0.7-1.2 | size swell 0->0.247@0.28->0 | tr 1.00..0.15 vis 0.08-0.90 ->1.00 | spd 1 drag 2.25 spread 50 acc -3-3-0 rotSpd 60 | FacingCamera | flip Grid4x4 Loop 25.8 | locked | RATE 20 (continuous) | z 2
B Leam           | tex 14654650241 (M  Leam) | col #FF0004 | LE0 LI0 Br5.5 | w 5-8 curve 2-0 seg 10 face | tr 1.00..0.00 vis 0.13-0.50 ->1.00 | tex Stretch 0.5 spd 0.8 | z -1
B Ream           | tex 14654650241 (M  Leam) | col #FF0004 | LE0 LI0 Br5.5 | w 5-8 curve -2-0 seg 10 face | tr 1.00..0.00 vis 0.50-0.50 ->1.00 | tex Stretch 0.5 spd 0.8 | z -1
B Beam           | tex 12781783939 | col #000000 | LE0 LI0 Br100 | w 2-15 curve 0-0 seg 10 face | tr 1.00..0.00 vis 0.27-0.50 ->1.00 | tex Stretch 2.38 spd 7 | z 1
B Beam           | tex 12781806168 (M  Beam) | col #FFFFFF | LE1 LI0 Br100 | w 2-10 curve 0-0 seg 10 face | tr 1.00..0.70 vis 0.50-0.50 ->1.00 | tex Stretch 1.25 spd 3 | z 0.5
B Beam           | tex 12781783939 | col #000000 | LE0 LI0 Br100 | w 16-15 curve 0-0 seg 10 face | tr 1.00..0.00 vis 0.27-0.50 ->1.00 | tex Stretch 2.38 spd 7 | z 1
B Beam           | tex 12781783939 | col #0011FF | LE0 LI0 Br100 | w 2-10 curve 0-0 seg 10 face | tr 1.00..0.00 vis 0.27-0.50 ->1.00 | tex Stretch 2.38 spd 7 | z 1
B Beam           | tex 12781825592 | col #FFFFFF | LE1 LI0 Br100 | w 2-6 curve 0-0 seg 10 face | tr 1.00..0.88 vis 0.19-0.19 ->1.00 | tex Stretch 1.5 spd 3
B Beam           | tex 12781825592 | col #FFFFFF | LE1 LI0 Br100 | w 2-15 curve 0-0 seg 10 face | tr 1.00..0.93 vis 0.50-0.50 ->1.00 | tex Stretch 1.5 spd 3
B Beam           | tex 12781783939 | col #000000 | LE0 LI0 Br100 | w 2-15 curve 0-0 seg 10 face | tr 1.00..0.00 vis 0.27-0.50 ->1.00 | tex Stretch 2.38 spd 7 | z 1
B Beam           | tex 12781783939 | col #000000 | LE0 LI0 Br100 | w 10-10 curve 0-0 seg 10 face | tr 1.00..0.00 vis 0.27-0.50 ->1.00 | tex Stretch 2.38 spd 7 | z 1
B Beam           | tex 12781806168 (M  Beam) | col #FFFFFF | LE1 LI1 Br100 | w 3-10 curve -4-0 seg 10 face | tr 1.00..0.49 vis 0.50-0.50 ->1.00 | tex Stretch 2.38 spd 7 | z 0.5
B Beam           | tex 12781783939 | col #000000 | LE0 LI0 Br100 | w 3-20 curve -4-0 seg 10 face | tr 1.00..0.00 vis 0.27-0.50 ->1.00 | tex Stretch 2.38 spd 7 | z 1
B Beam           | tex 12781783939 | col #000000 | LE0 LI0 Br100 | w 3-1 curve -4-0 seg 10 face | tr 1.00..0.00 vis 0.27-0.50 ->1.00 | tex Stretch 2.38 spd 7 | z 1
B Beam           | tex 12781825592 | col #FFFFFF | LE1 LI1 Br100 | w 3-10 curve -4-0 seg 10 face | tr 1.00..0.00 vis 0.22-0.65 ->1.00 | tex Stretch 2.38 spd 7
B Beam           | tex 12781825592 | col #FFFFFF | LE1 LI1 Br100 | w 3-20 curve -4-0 seg 10 face | tr 1.00..0.90 vis 0.50-0.50 ->1.00 | tex Stretch 2.38 spd 7
B Beam           | tex 12781783939 | col #0011FF | LE0 LI0 Br100 | w 3-20 curve -4-0 seg 10 face | tr 1.00..0.00 vis 0.27-0.50 ->1.00 | tex Stretch 2.38 spd 7 | z 1
B Beam           | tex 12781783939 | col #000000 | LE0 LI0 Br100 | w 3-15 curve -4-0 seg 10 face | tr 1.00..0.00 vis 0.27-0.50 ->1.00 | tex Stretch 2.38 spd 7 | z 1
B Beam           | tex 12781806168 (M  Beam) | col #FFFFFF | LE1 LI1 Br100 | w 10-4 curve 4-0 seg 10 face | tr 1.00..0.53 vis 0.50-0.50 ->1.00 | tex Stretch 2.38 spd 7 | z 0.5
B Beam           | tex 12781783939 | col #000000 | LE0 LI0 Br100 | w 3-10 curve 4-0 seg 10 face | tr 1.00..0.00 vis 0.27-0.50 ->1.00 | tex Stretch 2.38 spd 7 | z 1
B Beam           | tex 12781783939 | col #000000 | LE0 LI0 Br100 | w 3-10 curve 4-0 seg 10 face | tr 1.00..0.00 vis 0.27-0.50 ->1.00 | tex Stretch 2.38 spd 7 | z 1
B Beam           | tex 12781825592 | col #FFFFFF | LE1 LI1 Br100 | w 3-20 curve 4-0 seg 10 face | tr 1.00..0.00 vis 0.17-0.64 ->1.00 | tex Stretch 2.38 spd 7
B Beam           | tex 12781783939 | col #0011FF | LE0 LI0 Br100 | w 3-20 curve 4-0 seg 10 face | tr 1.00..0.00 vis 0.27-0.50 ->1.00 | tex Stretch 2.38 spd 7 | z 1
B Beam           | tex 12781783939 | col #000000 | LE0 LI0 Br100 | w 3-15 curve 4-0 seg 10 face | tr 1.00..0.00 vis 0.27-0.50 ->1.00 | tex Stretch 2.38 spd 7 | z 1
E explosion      | tex 12757089364 (D Grid4x4 explosion) | col #FF0004 | LE0 LI0 Br100 | life 0.5-1 | size shrink 0.556->0.309 | tr flat 0.00 | spd 2-3 drag 20 spread 80 rotSpd -30-30 | FacingCamera | flip Grid4x4 OneShot 1 | locked | EMIT 50 @0.08 | z -1
E explosion      | tex 12757089364 (D Grid4x4 explosion) | col #FF0004 | LE0 LI0 Br100 | life 0.5-1 | size shrink 0.556->0.309 | tr flat 0.00 | spd 2-3 drag 20 spread 80 rotSpd -30-30 | FacingCamera | flip Grid4x4 OneShot 1 | locked | EMIT 50 @0.08 | z -1
E explosion      | tex 12757089364 (D Grid4x4 explosion) | col #FF0004 | LE0 LI0 Br100 | life 0.5-1 | size shrink 0.556->0.309 | tr flat 0.00 | spd 2-3 drag 20 spread 80 rotSpd -30-30 | FacingCamera | flip Grid4x4 OneShot 1 | locked | EMIT 50 @0.08 | z -1
E explosion      | tex 12757089364 (D Grid4x4 explosion) | col #FF0004 | LE0 LI0 Br100 | life 0.5-1 | size shrink 0.556->0.309 | tr flat 0.00 | spd 2-3 drag 20 spread 80 rotSpd -30-30 | FacingCamera | flip Grid4x4 OneShot 1 | locked | EMIT 50 @0.08 | z -1
E explosion      | tex 12757089364 (D Grid4x4 explosion) | col #FF0004 | LE0 LI0 Br100 | life 0.5-1 | size shrink 0.556->0.309 | tr flat 0.00 | spd 2-3 drag 20 spread 80 rotSpd -30-30 | FacingCamera | flip Grid4x4 OneShot 1 | locked | EMIT 50 @0.08 | z -1
E explosion      | tex 12757089364 (D Grid4x4 explosion) | col #FF0004 | LE0 LI0 Br100 | life 0.5-1 | size shrink 0.556->0.309 | tr flat 0.00 | spd 2-8 drag 15 spread 360 rotSpd -30-30 | FacingCamera | flip Grid4x4 OneShot 1 | locked | EMIT 50 @0.08 | z -0.5
E clashcircle3   | tex 10558510611 (M  clashcircle2) | col #FFFFFF | LE-5 LI0 Br10 | life 1 | size grow 0->22 | tr 1.00..0.52 vis 0.50-0.50 ->1.00 | spd 3 spread 30 rotSpd 900-1.2e+03 | VelocityPerpendicular | locked | EMIT 10 @6.54 | z 2
P {"k": "Part", "name": "Right Leg", "size": [1.0, 2.0, 1.0], "mat": "Plastic", "transp": 0.0}
P {"k": "Part", "name": "Left Leg", "size": [1.0, 2.0, 1.0], "mat": "Plastic", "transp": 0.0}
P {"k": "Part", "name": "Right Arm", "size": [1.0, 2.0, 1.0], "mat": "Plastic", "transp": 0.0}
P {"k": "Part", "name": "Left Arm", "size": [1.0, 2.0, 1.0], "mat": "Plastic", "transp": 0.0}
P {"k": "Part", "name": "Torso", "size": [2.0, 2.0, 1.0], "mat": "Plastic", "transp": 0.0}
P {"k": "Part", "name": "Head", "size": [2.0, 1.0, 1.0], "mat": "Plastic", "transp": 0.0}
```
