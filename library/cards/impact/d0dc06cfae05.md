# d0dc06cfae05: Ranked.rbxl :: ReplicatedStorage/Assets/Effects/The Goliath/SuplexRun

- Category: **impact**; tags: impact, lightning, shockwave, smoke
- Layers: 16 emitters, 0 beams, 0 trails, 0 mesh parts, 0 lights; estimated length 1.5 s
- Fired by: EmitCount attributes
- Pack file: `190 OS (Oct 2024-Mar 2026)/Ranked.rbxl` (instance referent 3690): cut it into Studio with `kit/scripts/rbxcut.py "<pack>/190 OS (Oct 2024-Mar 2026)/Ranked.rbxl" --ref 3690 --out <studio content>/vfxlib/fx_d0dc06cfae05.rbxmx`
- Frames: none captured yet (play it with kit/studio/VFXLibPlayer.luau)

## Layers (one line each, in firing order; E emitter, B beam, T trail, P part, S script)
```
E TStripes       | tex 13802469635 | col #FFFFFF | LE0 LI0 Br2.7 | life 0.139-1 | size swell 0->1.73@0.35->0 | tr flat 0.90 | spd 20-45 drag 5.76 spread 3 | VelocityParallel | squash grow 0->0.554 | locked | EMIT 50 @0 | z 1 | attrs {"AgainstLowSpecs": true}
E Stripes2       | tex 7447358016 (A  Stripes) | col #FF6C22->#FF902F->#00D5FF | LE1 LI0 Br15 | life 0.17-0.23 | size swell 0->2.01@0.42->0 | tr flat 0.00 | spd 19.5-48.8 drag 3 | VelocityParallel/Disc | squash const 1 | RATE 25 (continuous) | z -3 | attrs {"Recolorable": true}
E Stripes        | tex 1315202524 (M  Stripes) | col #FF6C22->#FF902F->#00D5FF | LE1 LI0 Br5 | life 0.15-0.25 | size swell 0->3.5@0.11->0 | tr flat 0.00 | spd 35-75 drag 2 | VelocityParallel/Disc | squash shrink 2.33->0 | EMIT 35 @0 | z 1 | attrs {"Recolorable": true}
E BStripes       | tex 7447358016 (A  Stripes) | col #000000 | LE0 LI0 Br0 | life 0.17-0.23 | size swell 0->2.01@0.42->0 | tr flat 0.00 | spd 20-50 drag 3 | VelocityParallel/Disc | squash const 1 | RATE 25 (continuous) | z -3
E Dust           | tex 16519994606 | col #CCCCCC | LE1 LI0.35 Br1 | life 0.5 | size const 3 | tr 0.51..0.51 vis 0.00-0.00 ->1.00 | spd 1-100 drag 15 spread 2-5 | VelocityParallel | squash grow 0->-0.075 | flip Grid8x8 OneShot 1 | EMIT 15 @0 | z 1 | attrs {"AgainstLowSpecs": true}
E Shockwave2     | tex 8271495905 | col #FFFFFF | LE0.45 LI0 Br6.46 | life 0.2 | size grow 0->15 | tr 1.00..0.76 vis 0.20-0.20 ->1.00 | spd 0.001 | VelocityPerpendicular | EMIT 5 @0 | attrs {"emitRate": 3.0}
E Shockwave4     | tex 10316078099 (M  HalfRing1) | col #FFFFFF | LE0 LI0 Br10 | life 0.45-1.5 | size grow 0->18.1 | tr 0.89..0.89 vis 0.00-0.00 ->1.00 | spd 5-10 drag 7 spread 10 rotSpd -150-150 | VelocityPerpendicular | EMIT 20 @0 | attrs {"AgainstLowSpecs": true}
E Shockwave3     | tex 16824656937 | col #000000 | LE0 LI0.1 Br1 | life 0.1-0.25 | size grow 0->21.1 | tr 0.00..0.00 vis 0.00-0.00 ->1.00 | spd 0.0233 drag 2 | VelocityPerpendicular | EMIT 3 @0
E Shockwave      | tex 8048608283 (A  ParticleEmit) | col #515151 | LE1 LI0.1 Br1 | life 0.2-0.35 | size grow 0->27.6 | tr 0.00..0.00 vis 0.00-0.00 ->1.00 | spd 0.0839 drag 2 spread 5 | VelocityPerpendicular | EMIT 7 @0
E Sparks2        | tex 8970920735 (M  E12) | col #FF6C22 | LE0 LI0 Br0 | life 0.35-0.65 | size swell 0->1.44@0.12->0 | tr 0.00..0.00 vis 0.00-0.00 ->0.42 | spd 18-25 drag 4 spread 0-360 acc 0-0-150 | VelocityParallel | squash swell -1.61->0.15@0.56->-1.46 | locked | EMIT 0 @0 | attrs {"AgainstLowSpecs": true, "Recolorable": true}
E Sparks4        | tex 16879828729 (M Grid4x4 Spec34) | col #FFE047 | LE1 LI0.5 Br10 | life 0.28-0.37 | size swell 0->1.69@0.11->1.19 | tr 0.00..0.00 vis 0.00-0.18 ->1.00 | spd 35 drag 4 spread 0-180 acc 0-0-250 | VelocityParallel | squash grow 0->0.225 | locked | EMIT 0 @0 | z -2 | attrs {"AgainstLowSpecs": true, "Recolorable": true}
E Sparks3        | tex 16879828729 (M Grid4x4 Spec34) | col #FFE047 | LE1 LI0.5 Br10 | life 0.28-0.37 | size swell 0->1.69@0.11->0 | tr flat 0.00 | spd 35 drag 4 spread 0-180 acc 0-0-250 | VelocityParallel | squash grow 0->0.225 | locked | EMIT 0 @0 | z -2 | attrs {"AgainstLowSpecs": true, "Recolorable": true}
E Sparks         | tex 8970920735 (M  E12) | col #FF9D2E | LE1 LI0 Br8 | life 0.3-0.5 | size grow 0->2.94 | tr 0.00..0.00 vis 0.00-0.00 ->1.00 | spd 18-25 drag 4 spread 0-180 acc 0-0-150 | VelocityParallel | squash swell -1.61->0.15@0.56->-1.46 | locked | EMIT 0 @0 | z 3 | attrs {"AgainstLowSpecs": true, "Recolorable": true}
E Sparks2        | tex 8970920735 (M  E12) | col #FF6C22 | LE1 LI0.5 Br8 | life 0.35-0.65 | size swell 0->1.44@0.12->0 | tr 0.00..0.00 vis 0.00-0.00 ->0.42 | spd 18-25 drag 4 spread 0-180 acc 0-0-150 | VelocityParallel | squash swell -1.61->0.15@0.56->-1.46 | locked | EMIT 0 @0 | z 3 | attrs {"AgainstLowSpecs": true, "Recolorable": true}
E Smoke2         | tex 17302569371 | col #FF9D2E | LE1 LI0 Br10 | life 0.6 | size grow 0->7.12 | tr 1.00..0.86 vis 0.17-0.17 ->1.00 | spd 5-25 drag 4.5 spread 70 acc 0-0-30 | FacingCamera | locked | EMIT 0 @0 | z 1 | attrs {"AgainstLowSpecs": true, "Recolorable": true}
E Smoke          | tex 2360242557 (A  ParticleEmit) | col #FF9C2B | LE1 LI0 Br10 | life 0.45-0.5 | size grow 0->5.81 | tr 0.51..0.51 vis 0.00-0.00 ->1.00 | spd 10-20 spread 65 acc 0-0-25 rotSpd -100-100 | FacingCamera | locked | EMIT 0 @0 | z -4 | attrs {"Recolorable": true}
```
