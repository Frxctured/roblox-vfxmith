# 818f3ffd4aef: RoVfx Flame Slop.rbxm :: Flame

- Category: **fire**; tags: fire
- Layers: 20 emitters, 0 beams, 0 trails, 0 mesh parts, 2 lights; estimated length 3.4 s
- Fired by: saved running (Enabled + Rate)
- Pack file: `190 OS (Oct 2024-Mar 2026)/RoVfx Flame Slop.rbxm` (instance referent 0): cut it into Studio with `kit/scripts/rbxcut.py "<pack>/190 OS (Oct 2024-Mar 2026)/RoVfx Flame Slop.rbxm" --ref 0 --out <studio content>/vfxlib/fx_818f3ffd4aef.rbxmx`
- Frames: `gallery/effects/fire/818f3ffd4aef.jpg`

## Layers (one line each, in firing order; E emitter, B beam, T trail, P part, S script)
```
E ParticleEmitte | tex 119272314820246 (D Grid4x4 ParticleEmit) | col #FF4823 | LE0 LI0 Br12 | life 0.3-0.5 | size grow 0->1.4 | tr 0.00..0.00 vis 0.00-0.00 ->1.00 | spd 1-5 | FacingCamera | squash const 0.3 | flip Grid4x4 OneShot 1 | locked | RATE 8 (continuous) | z 2
E ParticleEmitte | tex 107186854128142 | col #FF4823 | LE1 LI0 Br3 | life 1 | size grow 0->5.4 | tr 0.88..0.88 vis 0.00-0.00 ->1.00 | spd 0.001 | FacingCameraWorldUp | squash const 0.3 | locked | RATE 3 (continuous) | z 3
E ParticleEmitte | tex 126052664189577 (M Grid4x4 Wind45) | col #FF4823->#000000 | LE-8 LI0 Br12 | life 0.3-0.5 | size grow 0->3.4 | tr 0.97..0.97 vis 0.00-0.00 ->1.00 | spd 0.01 rotSpd -100-100 | VelocityParallel | squash const -0.3 | flip Grid4x4 OneShot 1 | locked | RATE 12 (continuous) | z 2.4
E ParticleEmitte | tex 15811547630 (D  New70) | col #FF4823->#000000 | LE-8 LI0 Br12 | life 0.3-0.5 | size grow 0->3.4 | tr 0.59..0.59 vis 0.00-0.00 ->1.00 | spd 0.01 rotSpd -100-100 | VelocityParallel | locked | RATE 5 (continuous) | z 2.4
E ParticleEmitte | tex 16708557658 (M Grid4x4 ParticleEmit) | col #FF4823 | LE0 LI0 Br5 | life 0.352-0.855 | size grow 0->1.4 | tr 0.72..0.72 vis 0.00-0.00 ->1.00 | spd 1-6 drag 4 spread 25 acc 0-12-0 | VelocityParallel | flip Grid4x4 OneShot 1 | locked | RATE 12 (continuous) | z 2.44
E ParticleEmitte | tex 16847071704 (D Grid4x4 Fire20) | col #FF4823 | LE0 LI0 Br8 | life 0.352-0.855 | size grow 0->1.4 | tr flat 0.00 | spd 1-6 drag 4 spread 25 acc 0-12-0 | VelocityParallel | flip Grid4x4 OneShot 1 | locked | RATE 5 (continuous) | z 2
E ParticleEmitte | tex 138270984714302 (M Grid4x4 12) | col #FF4823 | LE1 LI0 Br8 | life 0.352-0.855 | size grow 0->1 | tr 1.00..0.51 vis 0.21-0.21 ->1.00 | spd 1-6 drag 7 spread 190 acc 0-12-0 | FacingCamera | flip Grid4x4 OneShot 1 | locked | RATE 10 (continuous) | z 2.4
E ParticleEmitte | tex 16860461660 (D Grid4x4 ParticleEmit) | col #FF4823 | LE0 LI0 Br0 | life 1 | size grow 0->1 | tr 0.00..0.00 vis 0.00-0.00 ->1.00 | spd 1-5 drag 6 spread 90 acc 0-12-0 | FacingCamera | flip Grid4x4 OneShot 1 | locked | RATE 10 (continuous) | z 0.3
E ParticleEmitte | tex 115530057206994 | col #FF4823 | LE0 LI0 Br15 | life 1.88-3.4 | size shrink 0.1->0 | tr flat 0.00 | spd 3-5 drag 3 spread 150 acc 0-7.44-0 | VelocityParallel | flip Grid4x4 OneShot 1 | locked | RATE 8 (continuous) | z 1.45
E ParticleEmitte | tex 13367803563 | col #FF3B0A->#000000 | LE-2 LI0 Br8 | life 0.4-1 | size grow 0->2 | tr 0.94..0.94 vis 0.00-0.50 ->1.00 | spd 2-15 drag 6.23 spread 77 acc 0-8-0 | FacingCamera | flip Grid4x4 OneShot 1 | locked | EMIT 14.4 @0 | z 0.01
E ParticleEmitte | tex 103222240579945 | col #FF4823 | LE0 LI0 Br5 | life 1.34-2.88 | size shrink 0.5->0 | tr flat 0.00 | spd 3-5 drag 2 spread 150 acc 0-7.44-0 | FacingCamera | flip Grid4x4 OneShot 1 | locked | RATE 5 (continuous) | z 1.45
E ParticleEmitte | tex 72464786650138 | col #FF4823 | LE0 LI0 Br15 | life 0.352-0.855 | size shrink 0.3->0 | tr flat 0.00 | spd 8-15 drag 7 spread 190 acc 0-12-0 | VelocityParallel | squash grow 0->0.375 | flip Grid4x4 OneShot 1 | locked | RATE 10 (continuous) | z 2
E ParticleEmitte | tex 16847138652 (D Grid4x4 Fire21) | col #FF4823 | LE0 LI0 Br5 | life 0.352-0.855 | size grow 0->1.3 | tr 0.00..0.00 vis 0.00-0.00 ->1.00 | spd 1-6 drag 6 spread 190 acc 0-12-0 | FacingCamera | flip Grid4x4 OneShot 1 | locked | RATE 10 (continuous) | z 2
E ParticleEmitte | tex 138372515259698 | col #FF4823 | LE0 LI0 Br1 | life 0.66-1.45 | size const 2 | tr 1.00..0.84 vis 0.50-0.50 ->1.00 | spd 8 drag 15 acc 0-4.4-0 | FacingCamera | squash grow 0->0.562 | flip Grid4x4 OneShot 1 | locked | RATE 4 (continuous) | z 0.6
E ParticleEmitte | tex 122954463046434 (D Grid4x4 flame) | col #FF4823 | LE0 LI0 Br2 | life 0.66-1.45 | size grow 0->2.44 | tr 0.80..0.75 vis 0.55-0.55 ->1.00 | spd 0.8-6.2 drag 5 spread 177 acc 0-4.4-0 | FacingCamera | flip Grid4x4 OneShot 1 | locked | RATE 6 (continuous) | z 0.3
E ParticleEmitte | tex 11858203067 (M Grid4x4 Stylized Smo) | col #FF3B0A | LE0.3 LI0 Br0.33 | life 0.74-1.33 | size grow 0->1.44 | tr 0.84..0.71 vis 0.55-0.55 ->1.00 | spd 0.444-5.2 drag 3 spread 177 acc 0-4-0 | FacingCamera | flip Grid4x4 OneShot 1 | locked | RATE 10 (continuous) | z 1.22
E ParticleEmitte | tex 11858203067 (M Grid4x4 Stylized Smo) | col #FF3B0A | LE0.3 LI0 Br0.33 | life 0.74-1.33 | size grow 0->1.44 | tr 0.84..0.71 vis 0.55-0.55 ->1.00 | spd 0.444-5.2 drag 2 spread 177 acc 0-4-0 | FacingCamera | flip Grid4x4 OneShot 1 | locked | RATE 10 (continuous) | z 1.1
E ParticleEmitte | tex 16867342570 (D Grid4x4 Smoke2) | col #FFFFFF | LE-0.5 LI0 Br0 | life 0.66-1.45 | size grow 0->2.14 | tr 0.86..0.86 vis 0.00-0.00 ->1.00 | spd 0.8-6.2 drag 1.5 spread 177 acc 0-4.4-0 | FacingCamera | flip Grid4x4 OneShot 1 | locked | RATE 10 (continuous) | z 0.4
E ParticleEmitte | tex 15072761142 (M Grid4x4 Smoke) | col #FF3B0A | LE0 LI0 Br0.2 | life 0.33-1.1 | size grow 0->1.44 | tr 0.94..0.36 vis 0.72-0.72 ->1.00 | spd 0.444-5.2 drag 1.3 spread 177 acc 0-2-0 | FacingCamera | flip Grid4x4 OneShot 1 | locked | RATE 22 (continuous) | z 1.3
E ParticleEmitte | tex 16867492882 (D Grid4x4 ParticleEmit) | col #FFFFFF | LE0 LI0 Br0 | life 0.66-1.45 | size grow 0->2.14 | tr 0.86..0.86 vis 0.00-0.00 ->1.00 | spd 0.8-6.2 drag 1 spread 177 acc 0-4.4-0 | FacingCamera | flip Grid4x4 OneShot 1 | locked | RATE 10 (continuous) | z 0.5
```
