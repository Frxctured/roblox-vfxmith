# b8bd2fdedc43: Ranked.rbxl :: ReplicatedStorage/Assets/Effects/The Goliath/LegSweep

- Category: **slash**; tags: flash, impact, lightning, portal, shockwave, slash, smoke
- Layers: 41 emitters, 0 beams, 0 trails, 0 mesh parts, 0 lights; estimated length 1.75 s
- Fired by: EmitCount attributes
- Pack file: `190 OS (Oct 2024-Mar 2026)/Ranked.rbxl` (instance referent 2478): cut it into Studio with `kit/scripts/rbxcut.py "<pack>/190 OS (Oct 2024-Mar 2026)/Ranked.rbxl" --ref 2478 --out <studio content>/vfxlib/fx_b8bd2fdedc43.rbxmx`
- Frames: none captured yet (play it with kit/studio/VFXLibPlayer.luau)

## Layers (one line each, in firing order; E emitter, B beam, T trail, P part, S script)
```
E Specs          | tex 8187306179 (M  Specs) | col #FFCF54 | LE0 LI0 Br5 | life 0.45-0.85 | size swell 0.413->0.875@0.13->0 | tr flat 0.00 | spd 25-75 drag 5 spread -120-120 rotSpd -15-15 | FacingCamera | squash swell 0->0.0375@0.50->0 | EMIT 35 @0 | z 1.25
E Glow           | tex 12159555294 (M  Glow) | col #FFAB4A | LE0 LI0 Br5 | life 0.2 | size grow 0->15 | tr 0.00..0.00 vis 0.00-0.20 ->1.00 | spd 0.01 spread 360 rotSpd -360-20 | FacingCamera | EMIT 1 @0 | z 1
E Hit            | tex 16582645239 | col #FFAB4A | LE0.3 LI0 Br4 | life 0.1 | size grow 0->15 | tr flat 0.00 | spd 0.001 | FacingCamera | EMIT 1 @0
E Smoke          | tex 12539687967 | col #FFFFFF | LE1 LI0 Br1 | life 0.45-1.25 | size grow 0->5.71 | tr 0.72..0.72 vis 0.00-0.00 ->1.00 | spd 3-80 drag 8.5 spread 360 rotSpd -110-110 | FacingCamera | flip Grid4x4 Loop 11-15 | EMIT 45 @0 | attrs {"AgainstLowSpecs": true}
E Shockwave2     | tex 10682949743 | col #FFAB4A | LE0.3 LI0 Br5 | life 0.11-0.17 | size grow 0->17.2 | tr 0.51..0.51 vis 0.00-0.00 ->1.00 | spd 0.00218 spread 360 | VelocityPerpendicular | EMIT 5 @0
E Shockwave      | tex 11536435403 (M  Shockwave) | col #FFAB4A | LE0.2 LI0 Br5 | life 0.1-0.2 | size grow 0->15 | tr 0.00..0.00 vis 0.00-0.45 ->1.00 | spd 0 | FacingCamera | EMIT 3 @0 | z 5.59
E Sparks         | tex 7922645282 (A  SparksLinger) | col #FFAB4A | LE1 LI0 Br4 | life 0.25-0.45 | size swell 0->0.719@0.47->0 | tr flat 0.00 | spd 25-65 drag 5 spread -360-360 | VelocityParallel | squash const -0.5 | locked | EMIT 35 @0 | z 4.8 | attrs {"Amount": 0.0}
E Specs2         | tex 1084996976 (A  ParticleEmit) | col #FFAB4A | LE1 LI0 Br5 | life 0.5-1.25 | size shrink 1.81->0 | tr flat 0.00 | spd 45-75 drag 7 spread -90-90 acc 0--10-0 rotSpd -200-200 | FacingCamera/Disc | squash const 0.3 | EMIT 25 @0
E Shards         | tex 10439119562 (M  Shards) | col #FFCF54 | LE0.3 LI0 Br5 | life 0.15-0.45 | size swell 0->4.15@0.26->0 | tr flat 0.00 | spd 65-150 drag 8 spread -360-360 | VelocityParallel | squash shrink 0.188->0.075 | locked | EMIT 35 @0 | attrs {"AgainstLowSpecs": true}
E Specs3         | tex 16583833022 | col #F7FF55 | LE0 LI0 Br5 | life 0.45-1.25 | size swell 0->0.496@0.10->0 | tr flat 0.00 | spd 35-65 drag 7 spread -75-75 acc 0--10-0 | FacingCamera | flip Grid4x4 OneShot 0 | EMIT 35 @0 | z 0.1
E BSpecs         | tex 16583833022 | col #000000 | LE0 LI0 Br1 | life 0.45-1.25 | size swell 0->0.496@0.10->0 | tr flat 0.00 | spd 35-65 drag 7 spread -75-75 acc 0--10-0 | FacingCamera | flip Grid4x4 OneShot 0 | EMIT 35 @0 | z 0.1
E Specs2         | tex 1084996976 (A  ParticleEmit) | col #FFAB4A | LE1 LI0 Br5 | life 0.5-1.25 | size shrink 1.81->0 | tr flat 0.00 | spd 45-75 drag 7 spread -90-90 acc 0--10-0 rotSpd -200-200 | FacingCamera/Disc | squash const 0.3 | EMIT 25 @0
E Specs          | tex 10205180639 (M  Specs3) | col #FDCA73 | LE-1 LI0 Br5 | life 0.35-0.75 | size swell 0->0.94@0.51->0 | tr flat 0.00 | spd 35-65 drag 7 spread -150-150 rotSpd -125-125 | VelocityParallel | locked | EMIT 50 @0 | attrs {"AgainstLowSpecs": true}
E Slash          | tex 9181667895 | col #FFBB0F->#000000 | LE1 LI0 Br10 | life 0.4 | size const 6 | tr flat 0.00 | spd 0.003 spread -5-5 rotSpd 500 | VelocityPerpendicular | flip Grid4x4 OneShot 30 | EMIT 2 @0 | z 1
E Slash3         | tex 13674360091 | col #FFAB4A | LE0 LI0 Br5 | life 0.41 | size const 5 | tr 1.00..0.91 vis 0.14-0.51 ->1.00 | spd 0.001 spread -10-10 rotSpd 100 | VelocityPerpendicular | squash const 0.1 | flip Grid4x4 OneShot 1 | EMIT 20 @0
E Slash2         | tex 10893072914 | col #FFFFFF | LE0 LI0 Br0 | life 0.3 | size const 8 | tr 1.00..0.76 vis 0.50-0.50 ->1.00 | spd 0.01 spread -5-5 rotSpd 655 | VelocityPerpendicular | locked | EMIT 5 @0 | z 1
E Shockwave2     | tex 9610856825 | col #FFAB4A | LE0 LI0 Br10 | life 0.25-0.45 | size grow 0->15 | tr 0.89..0.89 vis 0.00-0.00 ->1.00 | spd 0.1 drag 8.5 spread 10 | VelocityPerpendicular | EMIT 10 @0 | z 2.43 | attrs {"AgainstLowSpecs": true}
E Wind           | tex 13495778231 | col #FFFFFF | LE1 LI1 Br1 | life 0.45-0.95 | size grow 0->7.14 | tr 1.00..0.83 vis 0.22-0.22 ->1.00 | spd 0.302 spread 10 rotSpd -650--250 | VelocityPerpendicular | EMIT 10 @0 | z 1
E Wind2          | tex 13736013969 | col #FFFFFF | LE1 LI1 Br1 | life 0.25-0.65 | size grow 0->5.66 | tr 1.00..0.92 vis 0.50-0.50 ->1.00 | spd 0.03 drag 2 spread -10-10 rotSpd -750--250 | VelocityPerpendicular | EMIT 15 @0 | z 1
E Swirl          | tex 10316078099 (M  HalfRing1) | col #FFFFFF | LE0 LI0 Br10 | life 0.35-1.25 | size grow 0->12.2 | tr 0.89..0.89 vis 0.00-0.00 ->1.00 | spd 0.1 drag 8.5 spread 10 rotSpd -250-250 | VelocityPerpendicular | EMIT 20 @0 | z 1 | attrs {"AgainstLowSpecs": true}
E Shockwave3     | tex 11583743575 | col #FFAB4A | LE1 LI0 Br5 | life 0.15 | size grow 0->15 | tr 1.00..0.87 vis 0.38-0.38 ->1.00 | spd 0.0143-0.142 rotSpd 10 | VelocityPerpendicular | locked | EMIT 10 @0 | z 1
E Shockwave      | tex 8505111714 | col #FFFFFF | LE1 LI0 Br1 | life 0.21-0.3 | size grow 0->13.9 | tr 0.73..0.73 vis 0.00-0.00 ->1.00 | spd 0.00199 spread 11 | VelocityPerpendicular | EMIT 7 @0 | z 5
E Dust2          | tex 15145403239 | col #888888 | LE0 LI0 Br5 | life 0.35-1 | size grow 0->5 | tr 0.24..0.24 vis 0.00-0.00 ->1.00 | spd 60 drag 10 spread 0-150 acc 0-10-0 | FacingCamera | EMIT 25 @0 | z 1
E Impact         | tex 9659008631 (A  Shock) | col #FFFFFF | LE1 LI0 Br1 | life 0.25 | size grow 0->11.7 | tr 1.00..0.93 vis 0.10-0.10 ->1.00 | spd 0.00263 | VelocityPerpendicular | locked | EMIT 7 @0
E Thick          | tex 16570586760 | col #F2F2F2 | LE0.1 LI0.45 Br0.9 | life 0.189-0.425 | size grow 0->9.37 | tr 0.00..0.00 vis 0.00-0.00 ->1.00 | spd 0.427-1.39 drag 0.49 spread -12.5-12.5 rotSpd 154-358 | VelocityPerpendicular | EMIT 10 @0 | z 1.1
E Impact2        | tex 13366469414 | col #BABABA->#252525 | LE1 LI0.45 Br5 | life 0.2 | size grow 0->14.9 | tr 0.00..0.00 vis 0.00-0.00 ->1.00 | spd 0.427-1.39 drag 0.49 | VelocityPerpendicular | EMIT 4 @0 | z 0.1
E Dust           | tex 15145403239 | col #CCCCCC | LE0.1 LI0 Br0.9 | life 0.5-1.75 | size grow 0->6 | tr 1.00..0.48 vis 0.20-0.20 ->1.00 | spd 36.1-41.6 drag 6.86 spread 0--180 rotSpd -10-10 | FacingCamera | EMIT 45 @0 | z 0.1 | attrs {"AgainstLowSpecs": true}
E Smoke          | tex 13710158881 | col #CCCCCC | LE0 LI0 Br1 | life 0.7 | size grow 0->10 | tr 0.68..0.68 vis 0.00-0.00 ->1.00 | spd 0.001 | VelocityPerpendicular | squash shrink -1.55->-1.84 | flip Grid4x4 OneShot 1 | locked | EMIT 5 @0 | attrs {"AgainstLowSpecs": true}
E Smoke          | tex 13710158881 | col #CCCCCC | LE0 LI0 Br1 | life 0.7 | size grow 0->10 | tr 0.68..0.68 vis 0.00-0.00 ->1.00 | spd 0.001 | VelocityPerpendicular | squash shrink -1.55->-1.84 | flip Grid4x4 OneShot 1 | locked | EMIT 5 @0 | attrs {"AgainstLowSpecs": true}
E Impact         | tex 9659008631 (A  Shock) | col #FFFFFF | LE1 LI0 Br1 | life 0.25 | size grow 0->11.7 | tr 1.00..0.93 vis 0.10-0.10 ->1.00 | spd 0.00263 | VelocityPerpendicular | locked | EMIT 5 @0
E Crescents3     | tex 15620313312 (A  Crescents3) | col #BABABA->#252525 | LE1 LI0.45 Br15 | life 0.4-1 | size grow 0->16.9 | tr 1.00..0.00 vis 0.05-0.05 ->1.00 | spd 0.427-1.39 drag 0.49 spread -16-16 rotSpd 92.2-205 | VelocityPerpendicular | EMIT 7 @0 | z 0.1
E Crescents2     | tex 15486083983 (A  ParticleEmit) | col #BABABA->#252525 | LE1 LI0.45 Br1 | life 0.1-0.3 | size grow 0->15 | tr 0.00..0.00 vis 0.00-0.00 ->1.00 | spd 0.427-1.39 drag 0.49 spread -16-16 rotSpd 92.2-205 | VelocityPerpendicular | EMIT 5 @0 | z 0.1
E Thick          | tex 16570586760 | col #F2F2F2 | LE0.1 LI0.45 Br0.9 | life 0.189-0.425 | size grow 0->9.37 | tr 0.00..0.00 vis 0.00-0.00 ->1.00 | spd 0.427-1.39 drag 0.49 spread -12.5-12.5 rotSpd 154-358 | VelocityPerpendicular | EMIT 10 @0 | z 1.1
E Crescents      | tex 15426684133 | col #BABABA->#000000 | LE1 LI0.45 Br5 | life 0.374-0.936 | size grow 0->15 | tr 1.00..0.00 vis 0.05-0.05 ->1.00 | spd 0.427-1.39 drag 0.49 spread -16-16 rotSpd 184-410 | VelocityPerpendicular | EMIT 10 @0 | z 0.1
E Impact2        | tex 13366469414 | col #BABABA->#252525 | LE1 LI0.45 Br5 | life 0.2 | size grow 0->14.9 | tr 0.00..0.00 vis 0.00-0.00 ->1.00 | spd 0.427-1.39 drag 0.49 | VelocityPerpendicular | EMIT 3 @0 | z 0.1
E Dust           | tex 15145403239 | col #CCCCCC | LE0.1 LI0 Br0.9 | life 0.5-1.75 | size grow 0->6 | tr 1.00..0.48 vis 0.20-0.20 ->1.00 | spd 36.1-41.6 drag 6.86 spread 0-150 rotSpd -10-10 | FacingCamera | EMIT 45 @0 | z 0.1 | attrs {"AgainstLowSpecs": true}
E Debris         | tex 16572400340 | col #E1E1E1->#989898 | LE0 LI0.35 Br0.9 | life 0.45-1.5 | size swell 0->0.246@0.10->0 | tr flat 0.00 | spd 35-65 drag 6 spread 50-115 acc 0--25-0 rotSpd -10-10 | FacingCamera | flip Grid2x2 Random 0 | EMIT 35 @0 | z 0.1
E Reappear       | tex 10184824645 | col #000000 | LE0 LI0 Br1 | life 0.11 | size grow 0->12.6 | tr 0.00..0.00 vis 0.00-0.00 ->1.00 | spd 0 | FacingCamera | EMIT 3 @0 | z 1
E 2              | tex 14674185956 | col #000000 | LE0 LI0 Br1 | life 0.2-0.4 | size const 4 | tr 1.00..0.00 vis 0.50-0.50 ->1.00 | spd 0 drag 1.5 | FacingCamera | squash const -0.65 | flip Grid4x4 OneShot 1 | EMIT 10 @0 | z 1
E 3              | tex 13471193819 | col #000000 | LE0 LI0 Br5 | life 0.2-0.4 | size grow 0->4.61 | tr 0.00..0.00 vis 0.00-0.00 ->1.00 | spd 0 | FacingCameraWorldUp | squash grow 0->1.5 | flip Grid8x8 OneShot 1 | EMIT 1 @0 | z 2
E 1              | tex 14674185956 | col #000000 | LE0 LI0 Br1 | life 0.2-0.4 | size const 4 | tr 1.00..0.00 vis 0.50-0.50 ->1.00 | spd 0 drag 1.5 | FacingCamera | squash const -0.65 | flip Grid4x4 OneShot 1 | EMIT 10 @0 | z 1
```
