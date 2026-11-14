# 8eeeefde61cb: bloody orbs.rbxl :: ReplicatedStorage/Gezzu's VFX/GFX pack/Assets

- Category: **beam**; tags: beam, blood, ice, projectile
- Layers: 37 emitters, 87 beams, 0 trails, 381 mesh parts, 2 lights; estimated length 7.0 s
- Fired by: saved running (Enabled + Rate)
- Pack file: `190 OS (Oct 2024-Mar 2026)/bloody orbs.rbxl` (instance referent 326): cut it into Studio with `kit/scripts/rbxcut.py "<pack>/190 OS (Oct 2024-Mar 2026)/bloody orbs.rbxl" --ref 326 --out <studio content>/vfxlib/fx_8eeeefde61cb.rbxmx`
- Frames: none captured yet (play it with kit/studio/VFXLibPlayer.luau)

## Layers (one line each, in firing order; E emitter, B beam, T trail, P part, S script)
```
E ParticleEmitte | tex 75202463 (A  Shine) | col #AAAAAA | LE1 LI1 Br1 | life 2-3 | size const 1.5 | tr 0.60..0.10 vis 0.40-0.40 ->1.00 | spd 0 rotSpd 50 | FacingCamera | locked | RATE 5 (continuous)
E ParticleEmitte | tex 5726444189 (A  Air) | col #AAAAAA | LE0.6 LI1 Br1 | life 5 | size grow 0->3.68 | tr 1.00..0.00 vis 0.40-0.40 ->1.00 | spd 1 spread 3 rotSpd -500 | VelocityPerpendicular | locked | RATE 20 (continuous)
E ParticleEmitte | tex 243728166 | col #AAAAAA | LE0.6 LI1 Br1 | life 2-3 | size swell 1->2@0.50->1 | tr 0.60..0.10 vis 0.40-0.40 ->1.00 | spd 0 rotSpd 50 | FacingCamera | locked | RATE 5 (continuous)
E ParticleEmitte | tex 1084999891 (A  ParticleEmit) | col #AAAAAA | LE1 LI1 Br1 | life 2-3 | size swell 2->3@0.50->2 | tr 1.00..0.00 vis 0.20-0.80 ->1.00 | spd 0 rotSpd 60 | FacingCamera | locked | RATE 3 (continuous)
E ParticleEmitte | tex 2122546039 | col #959595 | LE0.4 LI1 Br1 | life 3-4 | size grow 0->2.22 | tr 1.00..0.56 vis 0.74-0.74 ->1.00 | spd 1.5 drag 0.2 spread 15 rotSpd -20-20 | FacingCamera | locked | RATE 10 (continuous)
E Snow           | tex 1084976679 (A Grid4x4 ParticleEmit) | col #FFFFFF | LE1 LI1 Br1 | life 2-3 | size shrink 2->1.25 | tr 1.00..0.70 vis 0.20-0.20 ->1.00 | spd 2-3 drag 0.2 spread 20--20 rotSpd -100-100 | FacingCamera | locked | RATE 6 (continuous) | z 3
E ParticleEmitte | tex 3916186365 (D  Particles) | col #AAAAAA | LE0.6 LI1 Br1 | life 5 | size const 2 | tr 1.00..0.10 vis 0.40-0.40 ->1.00 | spd 0 rotSpd 50 | FacingCamera | locked | RATE 1 (continuous) | z 1
E ParticleEmitte | tex 243728104 | col #AAAAAA | LE1 LI1 Br1 | life 2-3 | size swell 1->1.5@0.50->1 | tr 0.60..0.10 vis 0.40-0.40 ->1.00 | spd 0 rotSpd 50 | FacingCamera | locked | RATE 5 (continuous) | z 1
E ParticleEmitte | tex 243098098 (M  ParticleEmit) | col #FFFFFF | LE1 LI1 Br1 | life 0.4 | size const 1 | tr 1.00..0.20 vis 0.30-0.70 ->1.00 | spd 0 spread -20-20 rotSpd -100-100 | FacingCamera | locked | RATE 25 (continuous) | z 1
E ParticleEmitte | tex 6475162564 | col #5A5A5A | LE0.6 LI1 Br1 | life 4-5 | size const 0.3 | tr 0.90..0.00 vis 0.40-0.40 ->1.00 | spd 0.5 drag 1 spread 100--100 acc 2--3-0 rotSpd -50-50 | FacingCamera | locked | RATE 10 (continuous)
E ParticleEmitte | tex 915916073 | col #B3B3B3 | LE0.5 LI1 Br1 | life 4-5 | size const 0.4 | tr 0.90..0.00 vis 0.43-0.81 ->1.00 | spd 0.5 drag 1 spread 100--100 acc 2--3-0 rotSpd -50-50 | FacingCamera | locked | RATE 10 (continuous)
E ParticleEmitte | tex 42427179 | col #FFFFFF | LE1 LI1 Br1 | life 3-4 | size const 0.05 | tr 0.90..0.59 vis 0.41-0.41 ->1.00 | spd 1 rotSpd -50-50 | FacingCamera | locked | RATE 15 (continuous)
E ParticleEmitte | tex 6479253935 | col #959595 | LE1 LI1 Br1 | life 3-4 | size grow 0->2.22 | tr 1.00..0.56 vis 0.74-0.74 ->1.00 | spd 1.5 drag 0.2 spread 15 rotSpd -20-20 | FacingCamera | locked | RATE 10 (continuous)
E ParticleEmitte | tex 669133414 | col #AAAAAA | LE1 LI1 Br1 | life 1 | size swell 1->2@0.54->1 | tr 1.00..0.00 vis 0.20-0.80 ->1.00 | spd 0 rotSpd 160 | FacingCamera | locked | RATE 0.5 (continuous)
E ParticleEmitte | tex 1053548563 (A  Star1b) | col #AAAAAA | LE1 LI1 Br1 | life 2-3 | size swell 1->2@0.50->1 | tr 1.00..0.10 vis 0.40-0.40 ->1.00 | spd 0 rotSpd -50-50 | FacingCamera | locked | RATE 7 (continuous)
E ParticleEmitte | tex 448862775 (M  Dark) | col #AAAAAA | LE0.6 LI1 Br1 | life 2-3 | size const 3 | tr 1.00..0.10 vis 0.40-0.40 ->1.00 | spd 1 rotSpd 50 | FacingCamera | locked | RATE 3 (continuous) | z 2
E ParticleEmitte | tex 933102662 | col #959595 | LE0.4 LI1 Br1 | life 3-4 | size grow 0->4.16 | tr 1.00..0.56 vis 0.74-0.74 ->1.00 | spd 2 drag 0.2 spread 20--20 rotSpd -20-20 | FacingCamera | locked | RATE 5 (continuous)
E ParticleEmitte | tex 1454292685 | col #AAAAAA | LE1 LI1 Br1 | life 2-3 | size swell 0->2.5@0.50->0 | tr 0.60..0.10 vis 0.40-0.40 ->1.00 | spd 0 rotSpd 50 | FacingCamera | locked | RATE 5 (continuous) | z 1
E ParticleEmitte | tex 1084975295 (A  Rays) | col #AAAAAA | LE1 LI1 Br1 | life 2-3 | size swell 1->2@0.50->1 | tr 0.60..0.10 vis 0.40-0.40 ->1.00 | spd 0 rotSpd 50 | FacingCamera | locked | RATE 5 (continuous) | z 1
E ParticleEmitte | tex 5068632904 | col #FFFFFF | LE1 LI1 Br1 | life 1.75 | size swell 1->1.48@0.05->0.556 | tr 1.00..0.03 vis 0.15-0.15 ->1.00 | spd 2 spread 10 | FacingCamera | locked | RATE 5 (continuous)
E ParticleEmitte | tex 243728206 | col #AAAAAA | LE1 LI1 Br1 | life 2-3 | size swell 1->2.5@0.50->1 | tr 0.60..0.10 vis 0.40-0.40 ->1.00 | spd 0 rotSpd 50 | FacingCamera | locked | RATE 5 (continuous) | z 1
E ParticleEmitte | tex 419625073 (D  Blood) | col #1CC293 | LE0.2 LI1 Br1 | life 0.5-1 | size const 0.4 | tr 0.90..0.35 vis 0.40-0.40 ->1.00 | spd 10 drag 1 acc 0--10-0 | FacingCameraWorldUp | locked | RATE 15 (continuous)
E ParticleEmitte | tex 6479313834 | col #FFFFFF | LE1 LI1 Br1 | life 1 | size swell 1->2@0.45->1 | tr 1.00..0.20 vis 0.30-0.70 ->1.00 | spd 0 spread -10-10 rotSpd -100-100 | FacingCamera | locked | RATE 22 (continuous) | z 1
E ParticleEmitte | tex 6479250779 | col #AAAAAA | LE0.8 LI1 Br1 | life 5 | size const 2 | tr 1.00..0.10 vis 0.40-0.40 ->1.00 | spd 0 rotSpd 50 | FacingCamera | locked | RATE 5 (continuous) | z 1
E ParticleEmitte | tex 6602413638 | col #FFC3ED | LE0.5 LI1 Br1 | life 4-5 | size const 0.4 | tr 0.90..0.35 vis 0.40-0.40 ->1.00 | spd 0.5 drag 1 spread 100--100 acc 2--3-0 rotSpd -50-50 | FacingCamera | locked | RATE 1 (continuous)
E ParticleEmitte | tex 1946917526 (A  smoke) | col #959595 | LE0.4 LI1 Br1 | life 3-4 | size const 2.75 | tr 1.00..0.56 vis 0.74-0.74 ->1.00 | spd 2 drag 0.2 spread 30 rotSpd -20-20 | FacingCamera | locked | RATE 8 (continuous)
E ParticleEmitte | tex 528256032 (M  hlow) | col #959595 | LE0.6 LI1 Br1 | life 3-4 | size const 2.75 | tr 1.00..0.56 vis 0.74-0.74 ->1.00 | spd 2 drag 0.2 spread 30 rotSpd -20-20 | FacingCamera | locked | RATE 8 (continuous)
E ParticleEmitte | tex 6602421253 | col #FFC3ED | LE0.5 LI1 Br1 | life 4-5 | size const 0.4 | tr 0.90..0.35 vis 0.40-0.40 ->1.00 | spd 0.5 drag 1 spread 100--100 acc 2--3-0 rotSpd -50-50 | FacingCamera | locked | RATE 1 (continuous)
E Snow           | tex 4382847970 | col #FFFFFF | LE1 LI1 Br1 | life 2-3 | size shrink 2->1.25 | tr 1.00..0.70 vis 0.20-0.20 ->1.00 | spd 2-3 drag 0.2 spread 20--20 rotSpd -100-100 | FacingCamera | locked | RATE 5 (continuous) | z 3
E ParticleEmitte | tex 1084965356 (A  Wave) | col #AAAAAA | LE1 LI1 Br1 | life 7 | size const 2 | tr 1.00..0.00 vis 0.40-0.40 ->1.00 | spd 0 rotSpd 50 | FacingCamera | locked | RATE 1 (continuous) | z 1
E ParticleEmitte | tex 755925534 | col #959595 | LE0.8 LI1 Br1 | life 3-4 | size grow 0->2.22 | tr 1.00..0.56 vis 0.74-0.74 ->1.00 | spd 1.5 drag 0.2 spread 15 rotSpd -20-20 | FacingCamera | locked | RATE 10 (continuous)
E ParticleEmitte | tex 448862775 (M  Dark) | col #AAAAAA | LE0.6 LI1 Br1 | life 2-3 | size const 3 | tr 1.00..0.10 vis 0.40-0.40 ->1.00 | spd 1 rotSpd 50 | FacingCamera | locked | RATE 3 (continuous) | z 2
E ParticleEmitte | tex 917186750 | col #AAAAAA | LE0.6 LI1 Br1 | life 2-3 | size swell 2->2.5@0.50->2 | tr 0.60..0.10 vis 0.40-0.40 ->1.00 | spd 0 rotSpd 50 | FacingCamera | locked | RATE 5 (continuous) | z 1
E ParticleEmitte | tex 6479341134 | col #FFFFFF | LE1 LI1 Br1 | life 0.4 | size swell 0.6->0.6@0.00->0.6 | tr 1.00..0.20 vis 0.30-0.70 ->1.00 | spd 0 spread -10-10 rotSpd -360-360 | FacingCamera | locked | RATE 22 (continuous) | z 0.1
E ParticleEmitte | tex 6479341134 | col #FFFFFF | LE1 LI1 Br1 | life 0.4 | size swell 0.5->0.5@0.00->0.5 | tr 1.00..0.20 vis 0.30-0.70 ->1.00 | spd 2 spread -360-360 rotSpd -360-360 | FacingCamera | locked | RATE 22 (continuous)
E ParticleEmitte | tex 867619398 (M  Glow) | col #AAAAAA | LE0.4 LI1 Br1 | life 2-3 | size const 3 | tr 1.00..0.10 vis 0.40-0.40 ->1.00 | spd 1 rotSpd 50 | FacingCamera | locked | RATE 3 (continuous) | z 2
E ParticleEmitte | tex 242292288 | col #AAAAAA | LE0.6 LI1 Br1 | life 2-3 | size const 2 | tr 1.00..0.10 vis 0.40-0.40 ->1.00 | spd 1 rotSpd 50 | FacingCamera | locked | RATE 3 (continuous) | z 2
B Beam           | tex 5320395820 | col #FFFFFF | LE1 LI1 Br1 | w 4-4 curve 0-0 seg 10 | tr 0.00..0.00 vis 0.00-0.00 ->1.00 | tex Stretch 1 spd 1
B Beam           | tex 8089452023 | col #FFFFFF | LE1 LI1 Br1 | w 4-4 curve 0-0 seg 10 | tr 0.00..0.00 vis 0.00-0.00 ->1.00 | tex Stretch 1 spd -1
B Beam           | tex 8091408769 (A  BeamGlowing ) | col #FFFFFF | LE1 LI1 Br1 | w 4-4 curve 0-0 seg 10 | tr 0.00..0.00 vis 0.00-0.00 ->1.00 | tex Stretch 1 spd -1
B Beam           | tex 8089467613 | col #FFFFFF | LE1 LI1 Br1 | w 4-4 curve 0-0 seg 10 | tr 0.00..0.00 vis 0.00-0.00 ->1.00 | tex Stretch 1 spd -1
B Beam           | tex 8089421301 | col #FFFFFF | LE1 LI1 Br1 | w 4-4 curve 0-0 seg 10 | tr 0.00..0.00 vis 0.00-0.00 ->1.00 | tex Stretch 1 spd -1
B Beam           | tex 6933806553 | col #FFFFFF | LE1 LI1 Br1 | w 4-4 curve 0-0 seg 10 | tr 0.00..0.00 vis 0.00-0.00 ->1.00 | tex Stretch 1.12 spd -0.6
B Beam           | tex 6531295492 | col #FFFFFF | LE1 LI1 Br1 | w 5-5 curve 0-0 seg 10 | tr 0.00..0.00 vis 0.00-0.00 ->1.00 | tex Stretch 0.1 spd -0.7
B Beam           | tex 8091475665 | col #FFFFFF | LE1 LI1 Br1 | w 4-4 curve 0-0 seg 10 | tr 0.00..0.00 vis 0.00-0.00 ->1.00 | tex Stretch 0.625 spd -0.5
B Beam           | tex 6933783148 | col #FFFFFF | LE1 LI1 Br1 | w 4-4 curve 0-0 seg 10 | tr 0.00..0.00 vis 0.00-0.00 ->1.00 | tex Stretch 0.1 spd -0.6
B Beam           | tex 245996148 | col #FFFFFF | LE1 LI1 Br1 | w 4-4 curve 0-0 seg 10 | tr 0.00..0.00 vis 0.00-0.00 ->1.00 | tex Stretch 0.1 spd -1
B Beam           | tex 8098345726 (A  Beam) | col #FFFFFF | LE1 LI1 Br1 | w 6-6 curve 0-0 seg 10 | tr 0.00..0.00 vis 0.00-0.00 ->1.00 | tex Stretch 1.25 spd -0.5
B Beam           | tex 5320461870 | col #FFFFFF | LE1 LI1 Br1 | w 4-4 curve 0-0 seg 10 | tr 0.00..0.00 vis 0.00-0.00 ->1.00 | tex Stretch 1 spd 1
B Beam           | tex 8089495857 | col #FFFFFF | LE1 LI1 Br1 | w 4-4 curve 0-0 seg 10 | tr 0.00..0.00 vis 0.00-0.00 ->1.00 | tex Stretch 1 spd -1
B Beam           | tex 6528210403 | col #FFFFFF | LE1 LI1 Br1 | w 4-4 curve 0-0 seg 10 | tr 0.00..0.00 vis 0.00-0.00 ->1.00 | tex Stretch 0.1 spd -0.6
B Beam           | tex 5320396458 | col #FFFFFF | LE1 LI1 Br1 | w 4-4 curve 0-0 seg 10 | tr 0.00..0.00 vis 0.00-0.00 ->1.00 | tex Stretch 1 spd 1
B Beam           | tex 5655747881 | col #FFFFFF | LE1 LI1 Br1 | w 4-4 curve 0-0 seg 10 | tr 0.00..0.00 vis 0.00-0.00 ->1.00 | tex Stretch 0.1 spd -1
B Beam           | tex 5059527230 | col #FFFFFF | LE1 LI1 Br1 | w 4-4 curve 0-0 seg 10 | tr 0.00..0.00 vis 0.00-0.00 ->1.00 | tex Stretch 0.1 spd 0.1
B Beam           | tex 5697446711 | col #FFFFFF | LE0.3 LI1 Br1 | w 4-4 curve 0-0 seg 10 | tr 0.00..0.00 vis 0.00-0.00 ->1.00 | tex Stretch 0.1 spd -0.5
B Beam           | tex 5319760646 | col #FFFFFF | LE1 LI1 Br1 | w 4-4 curve 0-0 seg 10 | tr 0.00..0.00 vis 0.00-0.00 ->1.00 | tex Stretch 1 spd 1
B Beam           | tex 5309397920 | col #FFFFFF | LE1 LI1 Br1 | w 4-4 curve 0-0 seg 10 | tr 0.00..0.00 vis 0.00-0.00 ->1.00 | tex Stretch 1 spd 1
B Beam           | tex 5320409098 | col #FFFFFF | LE1 LI1 Br1 | w 4-4 curve 0-0 seg 10 | tr 0.00..0.00 vis 0.00-0.00 ->1.00 | tex Stretch 1 spd 1
B Beam           | tex 5319767042 | col #FFFFFF | LE1 LI1 Br1 | w 4-4 curve 0-0 seg 10 | tr 0.00..0.00 vis 0.00-0.00 ->1.00 | tex Stretch 1 spd 1
B Beam           | tex 5319763670 | col #FFFFFF | LE1 LI1 Br1 | w 4-4 curve 0-0 seg 10 | tr 0.00..0.00 vis 0.00-0.00 ->1.00 | tex Stretch 1 spd 1
B Beam           | tex 5319764523 | col #FFFFFF | LE1 LI1 Br1 | w 4-4 curve 0-0 seg 10 | tr 0.00..0.00 vis 0.00-0.00 ->1.00 | tex Stretch 1 spd 1
B Beam           | tex 1274380363 | col #FFFFFF | LE1 LI1 Br1 | w 4-4 curve 0-0 seg 10 | tr 0.00..0.00 vis 0.00-0.00 ->1.00 | tex Stretch 1 spd 1
B Beam           | tex 5259350470 | col #FFFFFF | LE1 LI1 Br1 | w 4-4 curve 0-0 seg 10 | tr 0.00..0.00 vis 0.00-0.00 ->1.00 | tex Stretch 1 spd 1
B Beam           | tex 1134824633 | col #FFFFFF | LE1 LI1 Br1 | w 4-4 curve 0-0 seg 10 | tr 0.00..0.00 vis 0.00-0.00 ->1.00 | tex Stretch 1 spd 1
B Beam           | tex 446111271 | col #FFFFFF | LE1 LI1 Br1 | w 4-4 curve 0-0 seg 10 | tr 0.00..0.00 vis 0.00-0.00 ->1.00 | tex Stretch 1 spd 1
B Beam           | tex 5059416965 | col #FFFFFF | LE1 LI1 Br1 | w 4-4 curve 0-0 seg 10 | tr 0.00..0.00 vis 0.00-0.00 ->1.00 | tex Stretch 1 spd 1
B Beam           | tex 5309397437 | col #FFFFFF | LE1 LI1 Br1 | w 4-4 curve 0-0 seg 10 | tr 0.00..0.00 vis 0.00-0.00 ->1.00 | tex Stretch 1 spd 1
B Beam           | tex 5325351689 | col #FFFFFF | LE1 LI1 Br1 | w 4-4 curve 0-0 seg 10 | tr 0.00..0.00 vis 0.00-0.00 ->1.00 | tex Stretch 1 spd 1
B Beam           | tex 5319767945 | col #FFFFFF | LE1 LI1 Br1 | w 4-4 curve 0-0 seg 10 | tr 0.00..0.00 vis 0.00-0.00 ->1.00 | tex Stretch 1 spd 1
B Beam           | tex 5889875399 (A  Decal 1) | col #FFFFFF | LE1 LI1 Br1 | w 4-4 curve 0-0 seg 10 | tr 0.00..0.00 vis 0.00-0.00 ->1.00 | tex Stretch 0.1 spd 1
B Beam           | tex 5638199267 | col #FFFFFF | LE1 LI1 Br1 | w 4-4 curve 0-0 seg 10 | tr 0.00..0.00 vis 0.00-0.00 ->1.00 | tex Stretch 1 spd 1
B Beam           | tex 241779220 | col #FFFFFF | LE1 LI1 Br1 | w 4-4 curve 0-0 seg 10 | tr 0.00..0.00 vis 0.00-0.00 ->1.00 | tex Stretch 0.1 spd 1
B Beam           | tex 5319759478 | col #FFFFFF | LE1 LI1 Br1 | w 4-4 curve 0-0 seg 10 | tr 0.00..0.00 vis 0.00-0.00 ->1.00 | tex Stretch 1 spd 1
B Beam           | tex 5319765539 | col #FFFFFF | LE1 LI1 Br1 | w 4-4 curve 0-0 seg 10 | tr 0.00..0.00 vis 0.00-0.00 ->1.00 | tex Stretch 1 spd 1
B Beam           | tex 5319761683 | col #FFFFFF | LE1 LI1 Br1 | w 4-4 curve 0-0 seg 10 | tr 0.00..0.00 vis 0.00-0.00 ->1.00 | tex Stretch 0.1 spd 0.1
B Beam           | tex 5059556437 | col #FFFFFF | LE1 LI1 Br1 | w 4-4 curve 0-0 seg 10 | tr 0.00..0.00 vis 0.00-0.00 ->1.00 | tex Stretch 1 spd 1
B Beam           | tex 5889857268 | col #FFFFFF | LE0.3 LI1 Br1 | w 4-4 curve 0-0 seg 10 | tr 0.00..0.00 vis 0.00-0.00 ->1.00 | tex Stretch 1 spd 1
B Beam           | tex 5319756636 | col #FFFFFF | LE1 LI1 Br1 | w 4-4 curve 0-0 seg 10 | tr 0.00..0.00 vis 0.00-0.00 ->1.00 | tex Stretch 1 spd 1
B Beam           | tex 5889822396 | col #FFFFFF | LE1 LI1 Br1 | w 4-4 curve 0-0 seg 10 | tr 0.00..0.00 vis 0.00-0.00 ->1.00 | tex Stretch 0.1 spd 0.2
B Beam           | tex 5320396964 | col #FFFFFF | LE1 LI1 Br1 | w 4-4 curve 0-0 seg 10 | tr 0.00..0.00 vis 0.00-0.00 ->1.00 | tex Stretch 1 spd 1
B Beam           | tex 5259392291 | col #FFFFFF | LE1 LI1 Br1 | w 4-4 curve 0-0 seg 10 | tr 0.00..0.00 vis 0.00-0.00 ->1.00 | tex Stretch 1 spd 1
B Beam           | tex 4975465603 | col #FFFFFF | LE1 LI1 Br1 | w 4-4 curve 0-0 seg 10 | tr 0.00..0.00 vis 0.00-0.00 ->1.00 | tex Stretch 1 spd 1
B Beam           | tex 5889807991 | col #FFFFFF | LE1 LI1 Br1 | w 4-4 curve 0-0 seg 10 | tr 0.00..0.00 vis 0.00-0.00 ->1.00 | tex Stretch 1 spd 1
B Beam           | tex 5638169137 | col #FFFFFF | LE1 LI1 Br1 | w 4-4 curve 0-0 seg 10 | tr 0.00..0.00 vis 0.00-0.00 ->1.00 | tex Stretch 1 spd 1
B Beam           | tex 2382169232 | col #FFFFFF | LE1 LI1 Br1 | w 4-4 curve 0-0 seg 10 | tr 0.00..0.00 vis 0.00-0.00 ->1.00 | tex Stretch 1 spd -1
B Beam           | tex 5311020240 | col #FFFFFF | LE1 LI1 Br1 | w 4-4 curve 0-0 seg 10 | tr 0.00..0.00 vis 0.00-0.00 ->1.00 | tex Stretch 1 spd 1
B Beam           | tex 1274378728 | col #FFFFFF | LE1 LI1 Br1 | w 4-4 curve 0-0 seg 10 | tr 0.00..0.00 vis 0.00-0.00 ->1.00 | tex Stretch 1 spd -1
B Beam           | tex 5309396094 | col #FFFFFF | LE1 LI1 Br1 | w 4-4 curve 0-0 seg 10 | tr 0.00..0.00 vis 0.00-0.00 ->1.00 | tex Stretch 1 spd 1
B Beam           | tex 5638168890 | col #FFFFFF | LE1 LI1 Br1 | w 4-4 curve 0-0 seg 10 | tr 0.00..0.00 vis 0.00-0.00 ->1.00 | tex Stretch 1 spd 1
B Beam           | tex 5311019692 | col #FFFFFF | LE1 LI1 Br1 | w 4-4 curve 0-0 seg 10 | tr 0.00..0.00 vis 0.00-0.00 ->1.00 | tex Stretch 1 spd 1
B Beam           | tex 5311021013 | col #FFFFFF | LE1 LI1 Br1 | w 4-4 curve 0-0 seg 10 | tr 0.00..0.00 vis 0.00-0.00 ->1.00 | tex Stretch 1 spd 1
B Beam           | tex 5638168605 | col #FFFFFF | LE1 LI1 Br1 | w 4-4 curve 0-0 seg 10 | tr 0.00..0.00 vis 0.00-0.00 ->1.00 | tex Stretch 1 spd 1
B Beam           | tex 3186190770 | col #FFFFFF | LE1 LI1 Br1 | w 4-4 curve 0-0 seg 10 | tr 0.00..0.00 vis 0.00-0.00 ->1.00 | tex Stretch 1 spd 1
B Beam           | tex 5638167113 | col #FFFFFF | LE1 LI1 Br1 | w 4-4 curve 0-0 seg 10 | tr 0.00..0.00 vis 0.00-0.00 ->1.00 | tex Stretch 1 spd 1
B Beam           | tex 5259455940 | col #FFFFFF | LE1 LI1 Br1 | w 4-4 curve 0-0 seg 10 | tr 0.00..0.00 vis 0.00-0.00 ->1.00 | tex Stretch 1 spd 1
B Beam           | tex 79443127 | col #FFFFFF | LE1 LI1 Br1 | w 4-4 curve 0-0 seg 10 | tr 0.00..0.00 vis 0.00-0.00 ->1.00 | tex Stretch 1 spd 1
B Beam           | tex 5259589000 | col #FFFFFF | LE1 LI1 Br1 | w 4-4 curve 0-0 seg 10 | tr 0.00..0.00 vis 0.00-0.00 ->1.00 | tex Stretch 1 spd 1
B Beam           | tex 5320401463 | col #FFFFFF | LE1 LI1 Br1 | w 4-4 curve 0-0 seg 10 | tr 0.00..0.00 vis 0.00-0.00 ->1.00 | tex Stretch 1 spd 1
B Beam           | tex 123310848 | col #FFFFFF | LE1 LI1 Br1 | w 4-4 curve 0-0 seg 10 | tr 0.00..0.00 vis 0.00-0.00 ->1.00 | tex Stretch 1 spd 1
B Beam           | tex 5259486177 | col #FFFFFF | LE1 LI1 Br1 | w 4-4 curve 0-0 seg 10 | tr 0.00..0.00 vis 0.00-0.00 ->1.00 | tex Stretch 1 spd 1
B Beam           | tex 457102813 (A  Beam) | col #FFFFFF | LE1 LI1 Br1 | w 4-4 curve 0-0 seg 10 | tr 0.00..0.00 vis 0.00-0.00 ->1.00 | tex Stretch 1 spd 1
B Beam           | tex 5320407484 | col #FFFFFF | LE1 LI1 Br1 | w 4-4 curve 0-0 seg 10 | tr 0.00..0.00 vis 0.00-0.00 ->1.00 | tex Stretch 1 spd 1
B Beam           | tex 5320399816 | col #FFFFFF | LE1 LI1 Br1 | w 4-4 curve 0-0 seg 10 | tr 0.00..0.00 vis 0.00-0.00 ->1.00 | tex Stretch 1 spd 1
B Beam           | tex 5320400553 | col #FFFFFF | LE1 LI1 Br1 | w 4-4 curve 0-0 seg 10 | tr 0.00..0.00 vis 0.00-0.00 ->1.00 | tex Stretch 1 spd 1
B Beam           | tex 5889822044 | col #FFFFFF | LE1 LI1 Br1 | w 4-4 curve 0-0 seg 10 | tr 0.00..0.00 vis 0.00-0.00 ->1.00 | tex Stretch 1 spd 1
B Beam           | tex 5320411483 | col #FFFFFF | LE1 LI1 Br1 | w 4-4 curve 0-0 seg 10 | tr 0.00..0.00 vis 0.00-0.00 ->1.00 | tex Stretch 1 spd 1
B Beam           | tex 5638167770 | col #FFFFFF | LE1 LI1 Br1 | w 4-4 curve 0-0 seg 10 | tr 0.00..0.00 vis 0.00-0.00 ->1.00 | tex Stretch 2.62 spd 3
B Beam           | tex 5320395241 | col #FFFFFF | LE1 LI1 Br1 | w 4-4 curve 0-0 seg 10 | tr 0.00..0.00 vis 0.00-0.00 ->1.00 | tex Stretch 1 spd 1
B Beam           | tex 5311021681 | col #FFFFFF | LE1 LI1 Br1 | w 4-4 curve 0-0 seg 10 | tr 0.00..0.00 vis 0.00-0.00 ->1.00 | tex Stretch 1 spd 1
B Beam           | tex 5320412694 | col #FFFFFF | LE1 LI1 Br1 | w 4-4 curve 0-0 seg 10 | tr 0.00..0.00 vis 0.00-0.00 ->1.00 | tex Stretch 1 spd 1
B Beam           | tex 5320412027 | col #FFFFFF | LE1 LI1 Br1 | w 4-4 curve 0-0 seg 10 | tr 0.00..0.00 vis 0.00-0.00 ->1.00 | tex Stretch 1 spd 1
B Beam           | tex 5059575678 | col #FFFFFF | LE1 LI1 Br1 | w 4-4 curve 0-0 seg 10 | tr 0.00..0.00 vis 0.00-0.00 ->1.00 | tex Stretch 1 spd 1
B Beam           | tex 5320460025 | col #FFFFFF | LE1 LI1 Br1 | w 4-4 curve 0-0 seg 10 | tr 0.00..0.00 vis 0.00-0.00 ->1.00 | tex Stretch 0.1 spd 1
B Beam           | tex 5059545109 | col #FFFFFF | LE1 LI1 Br1 | w 4-4 curve 0-0 seg 10 | tr 0.00..0.00 vis 0.00-0.00 ->1.00 | tex Stretch 1 spd 1
B Beam           | tex 5309396574 | col #FFFFFF | LE1 LI1 Br1 | w 4-4 curve 0-0 seg 10 | tr 0.00..0.00 vis 0.00-0.00 ->1.00 | tex Stretch 1 spd 1
B Beam           | tex 5259318941 | col #FFFFFF | LE1 LI1 Br1 | w 4-4 curve 0-0 seg 10 | tr 0.00..0.00 vis 0.00-0.00 ->1.00 | tex Stretch 1 spd 1
B Beam           | tex 4979919970 | col #FFFFFF | LE1 LI1 Br1 | w 4-4 curve 0-0 seg 10 | tr 0.00..0.00 vis 0.00-0.00 ->1.00 | tex Stretch 1 spd 1
B Beam           | tex 3517446796 (A  Beam) | col #FFFFFF | LE1 LI1 Br1 | w 4-4 curve 0-0 seg 10 | tr 0.00..0.00 vis 0.00-0.00 ->1.00 | tex Stretch 1 spd 1
B Beam           | tex 3517446796 (A  Beam) | col #FFFFFF | LE1 LI1 Br1 | w 4-4 curve 0-0 seg 10 | tr 0.00..0.00 vis 0.00-0.00 ->1.00 | tex Stretch 1 spd 1
B Beam           | tex 5259529792 | col #FFFFFF | LE1 LI1 Br1 | w 4-4 curve 0-0 seg 10 | tr 0.00..0.00 vis 0.00-0.00 ->1.00 | tex Stretch 1 spd 1
B Beam           | tex 5259508588 | col #FFFFFF | LE1 LI1 Br1 | w 4-4 curve 0-0 seg 10 | tr 0.00..0.00 vis 0.00-0.00 ->1.00 | tex Stretch 1 spd 1
B Beam           | tex 5638169715 | col #FFFFFF | LE1 LI1 Br1 | w 4-4 curve 0-0 seg 10 | tr 0.00..0.00 vis 0.00-0.00 ->1.00 | tex Stretch 1 spd 1
B Beam           | tex 5319757616 | col #FFFFFF | LE1 LI1 Br1 | w 4-4 curve 0-0 seg 10 | tr 0.00..0.00 vis 0.00-0.00 ->1.00 | tex Stretch 1 spd 1
B Beam           | tex 5638170046 | col #FFFFFF | LE1 LI1 Br1 | w 4-4 curve 0-0 seg 10 | tr 0.00..0.00 vis 0.00-0.00 ->1.00 | tex Stretch 1 spd 1
P {"k": "Part", "name": "Part", "size": [2.0, 2.0, 38.0], "mat": "Plastic", "transp": 0.0}
P {"k": "Part", "name": "Base", "size": [31.0, 1.0, 34.0], "mat": "Neon", "transp": 0.0}
P {"k": "Part", "name": "Base", "size": [79.99999, 1.0, 32.0], "mat": "Neon", "transp": 0.0}
P {"k": "Part", "name": "Part", "size": [2.0, 2.0, 12.0], "mat": "Plastic", "transp": 0.0}
P {"k": "Part", "name": "Part", "size": [69.0, 2.0, 2.0], "mat": "Plastic", "transp": 0.0}
P {"k": "Part", "name": "Base", "size": [66.99999, 1.0, 14.0], "mat": "Neon", "transp": 0.0}
P {"k": "Part", "name": "Base", "size": [82.0, 1.0, 32.0], "mat": "Neon", "transp": 0.0}
P {"k": "Part", "name": "Part", "size": [25.0, 1.0, 2.0], "mat": "Plastic", "transp": 0.0}
P {"k": "Part", "name": "Part", "size": [2.0, 1.0, 3.0], "mat": "Plastic", "transp": 0.0}
P {"k": "Part", "name": "Part", "size": [163.0, 2.0, 2.0], "mat": "Plastic", "transp": 0.0}
P {"k": "Part", "name": "Part", "size": [2.0, 1.0, 58.0], "mat": "Plastic", "transp": 0.0}
P {"k": "Part", "name": "Part", "size": [2.0, 2.0, 112.0], "mat": "Plastic", "transp": 0.0}
P {"k": "Part", "name": "Base", "size": [163.0, 1.0, 62.0], "mat": "Neon", "transp": 0.0}
P {"k": "Part", "name": "Part", "size": [27.0, 1.0, 2.0], "mat": "Plastic", "transp": 0.0}
P {"k": "Part", "name": "Part", "size": [2.0, 2.0, 96.0], "mat": "Plastic", "transp": 0.0}
P {"k": "Part", "name": "Part", "size": [2.0, 1.0, 61.0], "mat": "Plastic", "transp": 0.0}
P {"k": "Part", "name": "Part", "size": [82.0, 1.0, 2.0], "mat": "Plastic", "transp": 0.0}
P {"k": "Part", "name": "Part", "size": [112.0, 1.0, 2.0], "mat": "Plastic", "transp": 0.0}
P {"k": "Part", "name": "Part", "size": [2.0, 1.0, 94.0], "mat": "Plastic", "transp": 0.0}
P {"k": "Part", "name": "Part", "size": [2.0, 1.0, 34.0], "mat": "Plastic", "transp": 0.0}
S Script README len546 flags=
S Script CREDITS len62 flags=
S Script Plugins len2547 flags=
S Script CREDITS len300 flags=
S Script CREDITS len109 flags=
S Script CREDITS len226 flags=
S Script CREDITS len110 flags=
S Script CREDITS len231 flags=
S Script CREDITS len140 flags=
S Script CREDITS len148 flags=debris
S Script CREDITS len158 flags=
```
