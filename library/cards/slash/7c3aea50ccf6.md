# 7c3aea50ccf6: Demon Sword (Goldx made this).rbxm :: Plane.003

- Category: **slash**; tags: beam, dark, slash
- Layers: 16 emitters, 5 beams, 0 trails, 1 mesh parts, 1 lights; estimated length 1.2 s
- Fired by: saved running (Enabled + Rate)
- Pack file: `Older OS (2025 and older)/Oct 2024 - Jan 2025/Demon Sword (Goldx made this).rbxm` (instance referent 0): cut it into Studio with `kit/scripts/rbxcut.py "<pack>/Older OS (2025 and older)/Oct 2024 - Jan 2025/Demon Sword (Goldx made this).rbxm" --ref 0 --out <studio content>/vfxlib/fx_7c3aea50ccf6.rbxmx`
- Frames: none captured yet (play it with kit/studio/VFXLibPlayer.luau)

## Layers (one line each, in firing order; E emitter, B beam, T trail, P part, S script)
```
E Fe             | tex 80016616144746 | col #FF4747 | LE-1.2 LI0 Br15 | life 0.6-0.8 | size const 0.7 | tr 1.00..0.00 vis 0.30-0.70 ->1.00 | spd 0.001 spread -360-360 | FacingCamera | flip Grid4x4 OneShot 1 | RATE 7 (continuous) | z 0.5
E Fe             | tex 15166317733 | col #FF4747 | LE-1.2 LI0 Br15 | life 0.6-0.8 | size const 1.2 | tr flat 0.00 | spd 0.001 spread -360-360 | FacingCamera | flip Grid4x4 OneShot 1 | RATE 3 (continuous) | z 0.5
E Fe             | tex 11187840108 (D Grid4x4 Specs) | col #FF4747 | LE-0.5 LI0 Br15 | life 0.6-0.8 | size swell 0->0.3@0.40->0 | tr flat 0.00 | spd 1-2 spread -360-360 acc 0-2-0 | FacingCamera | RATE 10 (continuous) | z 1
E Fe             | tex 14496415643 (D Grid4x4 ParticleEmit) | col #FF4747->#E03E3E->#000000 | LE-0.5 LI0 Br15 | life 0.6-0.8 | size const 1 | tr flat 0.00 | spd 0.001 spread -360-360 | VelocityPerpendicular | flip Grid4x4 OneShot 1 | RATE 15 (continuous)
E ParticleEmitte | tex 867619398 (M  Glow) | col #FF4747 | LE-1 LI0 Br1 | life 1 | size const 0.1 | tr 1.00..0.00 vis 0.50-0.50 ->1.00 | spd 0.0007 | VelocityPerpendicular | locked | RATE 2 (continuous)
E ParticleEmitte | tex 867619398 (M  Glow) | col #FF4747 | LE-1 LI0 Br1 | life 1 | size const 0.1 | tr 1.00..0.00 vis 0.50-0.50 ->1.00 | spd 0.0007 | VelocityPerpendicular | locked | RATE 2 (continuous)
E ParticleEmitte | tex 10335418884 (A  stars) | col #FF4747 | LE1 LI0 Br15 | life 0.15 | size swell 3->3@0.00->3 | tr flat 0.00 | spd 0.0015 | VelocityParallel | squash const -0.5 | locked | RATE 10 (continuous) | z 1
E ParticleEmitte | tex 867619398 (M  Glow) | col #FF4747 | LE1 LI0 Br15 | life 1 | size const 2 | tr 1.00..0.86 vis 0.50-0.50 ->1.00 | spd 0.0007 | VelocityParallel | squash const 1.5 | locked | RATE 2 (continuous) | z -0.01
E ParticleEmitte | tex 11392234336 | col #FF4747 | LE1 LI0 Br15 | life 1 | size const 2 | tr 1.00..0.10 vis 0.50-0.50 ->1.00 | spd 0.0007 | VelocityParallel | squash const 0.8 | locked | RATE 2 (continuous) | z 2
E Fe             | tex 16924740376 | col #FF4747 | LE0 LI0 Br15 | life 0.6-0.8 | size grow 0->1 | tr 1.00..0.00 vis 0.30-0.50 ->1.00 | spd 0.001 spread -360-360 | FacingCamera | flip Grid4x4 OneShot 1 | RATE 7 (continuous) | z 1.2
E Fe             | tex 12602224662 (M Grid8x8 rainbow) | col #FF4747 | LE1 LI0 Br15 | life 0.6-0.8 | size grow 0->2 | tr 1.00..0.00 vis 0.30-0.50 ->1.00 | spd 0.001 spread -360-360 | FacingCamera | flip Grid8x8 OneShot 1 | RATE 7 (continuous)
E Fe             | tex 13712002536 (M Grid4x4 Wiggling fad) | col #FF4747 | LE0 LI0 Br0 | life 0.6-0.8 | size grow 0->2.2 | tr 1.00..0.00 vis 0.45-0.50 ->1.00 | spd 0.001 | FacingCamera | flip Grid4x4 OneShot 1 | RATE 15 (continuous) | z -1
E Fe             | tex 13712002536 (M Grid4x4 Wiggling fad) | col #FF4747 | LE1 LI0 Br35 | life 0.6-0.8 | size grow 0->2.2 | tr 1.00..0.00 vis 0.45-0.50 ->1.00 | spd 0.001 | FacingCamera | flip Grid4x4 OneShot 1 | RATE 15 (continuous) | z -1
E ParticleEmitte | tex 17558269216 | col #FF4747 | LE1 LI0 Br1 | life 1.2 | size const 2.5 | tr 1.00..0.50 vis 0.50-0.50 ->1.00 | spd 0.0015 | FacingCamera | squash const 1.2 | locked | RATE 1.55 (continuous) | z -1
E ParticleEmitte | tex 17558269216 | col #FF4747 | LE1 LI0 Br1 | life 1.2 | size const 3 | tr 1.00..0.78 vis 0.50-0.50 ->1.00 | spd 0.0015 | FacingCamera | locked | RATE 1.55 (continuous) | z -1
E ParticleEmitte | tex 10335418884 (A  stars) | col #FF4747 | LE1 LI0 Br15 | life 0.15 | size swell 1.5->1.5@0.00->1.5 | tr flat 0.00 | spd 0.00075 | VelocityParallel | squash const -0.5 | locked | RATE 10 (continuous) | z 1
B Beam           | tex 17578654533 | col #FF4747 | LE1 LI0 Br5 | w 2-1 curve 0-0 seg 10 face | tr 1.00..0.00 vis 0.30-0.70 ->1.00 | tex Stretch 2 spd 2 | z 0.001
B Beam           | tex 17578654533 | col #FF4747 | LE0 LI0 Br0 | w 2-1 curve 0-0 seg 10 face | tr 1.00..0.00 vis 0.30-0.70 ->1.00 | tex Stretch 1 spd 1 | z 0.09
B Beam           | tex 17578654533 | col #FF4747 | LE1 LI0 Br5 | w 1.5-1 curve 0-0 seg 10 face | tr 1.00..0.00 vis 0.30-0.70 ->1.00 | tex Stretch 0.5 spd 0.5 | z 0.01
B Beam           | tex 17561368425 | col #FF4747 | LE0 LI0 Br5 | w 1-0.5 curve 0-0 seg 10 face | tr 1.00..0.50 vis 0.20-0.80 ->1.00 | tex Stretch 0.5 spd 0.5
B Beam           | tex 17561356776 | col #FF4747 | LE0 LI0 Br5 | w 2-0 curve 0-0 seg 10 face | tr 1.00..0.72 vis 0.20-0.20 ->1.00 | tex Stretch 0.5 spd 0.5
P {"k": "MeshPart", "name": "Plane.003", "size": [1.93365, 8.95053, 0.28559], "mat": "Neon", "transp": 0.0, "mesh": 17640907532}
```
