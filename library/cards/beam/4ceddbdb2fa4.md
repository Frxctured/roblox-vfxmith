# 4ceddbdb2fa4: Ranked.rbxl :: ReplicatedStorage/Assets/Effects/Emotes

- Category: **beam**; tags: aura, beam, impact, lightning, projectile, shockwave, smoke, star
- Layers: 51 emitters, 12 beams, 1 trails, 7 mesh parts, 3 lights; estimated length 1.2 s
- Fired by: saved running (Enabled + Rate)
- Pack file: `190 OS (Oct 2024-Mar 2026)/Ranked.rbxl` (instance referent 5737): cut it into Studio with `kit/scripts/rbxcut.py "<pack>/190 OS (Oct 2024-Mar 2026)/Ranked.rbxl" --ref 5737 --out <studio content>/vfxlib/fx_4ceddbdb2fa4.rbxmx`
- Frames: none captured yet (play it with kit/studio/VFXLibPlayer.luau)

## Layers (one line each, in firing order; E emitter, B beam, T trail, P part, S script)
```
E ParticleEmitte | tex 17292142101 | col #FFFFFF | LE0 LI0 Br1 | life 1 | size swell 0->0.375@0.30->0 | tr flat 0.00 | spd 0.01 | FacingCamera | flip Grid8x8 OneShot 1 | locked | RATE 20 (continuous)
E Star           | tex 17292130619 | col #5DFF4B | LE0 LI0 Br6 | life 0.3 | size grow 0->1.62 | tr 1.00..0.00 vis 0.25-0.77 ->1.00 | spd 0.01 | FacingCamera | locked | RATE 5 (continuous) | z 1
E Shockwave4     | tex 17292091511 | col #A8FF79 | LE0 LI0 Br4 | life 0.3 | size grow 0->2.5 | tr 0.95..0.44 vis 0.49-0.49 ->1.00 | spd 0.01 rotSpd -1e+03-1e+03 | FacingCamera | locked | RATE 25 (continuous)
E Shockwave3     | tex 17292084744 | col #5DFF4B | LE0 LI0 Br15 | life 0.3 | size grow 0->2.88 | tr 0.95..0.49 vis 0.46-0.46 ->1.00 | spd 0.01 | FacingCamera | locked | RATE 10 (continuous)
E Shockwave2     | tex 17292068667 | col #5DFF4B | LE0 LI0 Br15 | life 1 | size grow 0->2.62 | tr 0.95..0.39 vis 0.46-0.46 ->1.00 | spd 0.01 | FacingCamera | locked | RATE 2 (continuous)
E Shockwave1     | tex 17292042733 | col #5DFF4B | LE0 LI0 Br15 | life 1 | size grow 0->5 | tr 0.00..0.00 vis 0.00-0.00 ->1.00 | spd 0.01 | FacingCamera | locked | RATE 3 (continuous)
E Circle         | tex 17289785605 | col #98CDFF | LE0 LI0 Br5 | life 1 | size shrink 0.1->0 | tr flat 0.00 | spd 0.01-0.5 drag 5 spread 16 | VelocityParallel | squash const -0.4 | locked | RATE 3 (continuous) | z 0.15
E Circle         | tex 17289785605 | col #98CDFF | LE0 LI0 Br5 | life 1 | size shrink 0.1->0 | tr flat 0.00 | spd 0.01-0.5 drag 5 spread 16 | VelocityParallel | squash const -0.4 | locked | RATE 3 (continuous) | z 0.15
E Tear           | tex 17289795080 | col #98CDFF | LE-2 LI0 Br1 | life 0.2 | size swell 0->0.625@0.20->0 | tr flat 0.00 | spd 6 spread 75-0 acc 0--15-0 | VelocityParallel | locked | RATE 20 (continuous)
E Circle         | tex 17289785605 | col #98CDFF | LE0 LI0 Br5 | life 1 | size const 0.17 | tr flat 0.00 | spd 0.01 | VelocityPerpendicular | locked | RATE 3 (continuous) | z 0.25
E Outline        | tex 17289785605 | col #FFFFFF | LE0 LI0 Br0 | life 1 | size const 0.2 | tr flat 0.00 | spd 0.01 | VelocityPerpendicular | locked | RATE 3 (continuous)
E Tear           | tex 17289795080 | col #98CDFF | LE-2 LI0 Br1 | life 0.2 | size swell 0->0.625@0.20->0 | tr flat 0.00 | spd 6 spread 75-0 acc 0--15-0 | VelocityParallel | locked | RATE 20 (continuous)
E Circle         | tex 17289785605 | col #98CDFF | LE0 LI0 Br5 | life 1 | size const 0.17 | tr flat 0.00 | spd 0.01 | VelocityPerpendicular | locked | RATE 3 (continuous) | z 0.25
E Outline        | tex 17289785605 | col #FFFFFF | LE0 LI0 Br0 | life 1 | size const 0.2 | tr flat 0.00 | spd 0.01 | VelocityPerpendicular | locked | RATE 3 (continuous)
E Circle         | tex 12329058133 | col #FFFFFF | LE1 LI0 Br2 | life 0.8-1.1 | size grow 0->9.18 | tr 1.00..0.95 vis 0.15-0.15 ->1.00 | spd 5.85-17.5 drag 3 spread 5 rotSpd 240-480 | VelocityPerpendicular | locked | EMIT 25 @0
E Wave           | tex 15311971152 (A  Impact599) | col #FFFFFF | LE1 LI0 Br1 | life 0.8-1.1 | size grow 0->6.51 | tr 1.00..0.87 vis 0.64-0.64 ->1.00 | spd 5.85-17.5 drag 3 spread 12 rotSpd -360--240 | VelocityPerpendicular | locked | EMIT 1 @0
E ParticleEmitte | tex 16452556260 | col #E1FF4A->#AAAAFF | LE1 LI0 Br1 | life 1 | size grow 0->6.91 | tr 1.00..0.45 vis 0.20-0.20 ->1.00 | spd 0.001 | FacingCamera | locked | EMIT 0 @0 | z 1
E ParticleEmitte | tex 12105193694 (A  Flare170New) | col #FFFFFF | LE1 LI0 Br1 | life 1 | size const 5.5 | tr 1.00..0.00 vis 0.50-0.50 ->1.00 | spd 0 drag 1 spread -1e+03-1e+03 | FacingCamera | RATE 2 (continuous) | z 1
E Wind           | tex 15048784530 (M Grid4x4 Absorb Swirl) | col #FFEA4E | LE1 LI0 Br5 | life 0.65-0.85 | size const 10 | tr 1.00..0.93 vis 0.15-0.15 ->1.00 | spd 0.00555 spread 360--360 rotSpd -2-2 | VelocityParallel | squash const 0.35 | flip Grid4x4 OneShot 1 | locked | EMIT 2 @0 | z -0.5
E ParticleEmitte | tex 17291629895 | col #FFFFFF | LE0 LI0 Br2 | life 0.5 | size swell 0->1.31@0.37->0 | tr flat 0.00 | spd 0.01 rotSpd -200-200 | FacingCamera | RATE 10 (continuous) | z 2
E ParticleEmitte | tex 17291621339 | col #FFFFFF | LE0 LI0 Br2 | life 1 | size const 1 | tr flat 0.00 | spd 0.01 | FacingCamera | flip Grid4x4 OneShot 1 | RATE 4 (continuous) | z 2
E Arrow          | tex 17291123439 | col #FFFFFF | LE0 LI0 Br1.3 | life 0.3 | size const 3.5 | tr 1.00..0.00 vis 0.50-0.50 ->1.00 | spd 0.007 | VelocityPerpendicular | locked | RATE 15 (continuous) | z 0.4
E Cube           | tex 17291053390 | col #3D7AFF | LE0 LI0 Br1.3 | life 0.3 | size const 1.82 | tr 1.00..0.00 vis 0.50-0.50 ->1.00 | spd 0.007 | VelocityPerpendicular | locked | RATE 15 (continuous)
E Arrow          | tex 17291123439 | col #FFFFFF | LE0 LI0 Br1.3 | life 0.3 | size const 3.5 | tr 1.00..0.00 vis 0.50-0.50 ->1.00 | spd 0.007 | VelocityPerpendicular | locked | RATE 15 (continuous) | z 0.4
E Cube           | tex 17291053390 | col #3D7AFF | LE0 LI0 Br1.3 | life 0.3 | size const 1.82 | tr 1.00..0.00 vis 0.50-0.50 ->1.00 | spd 0.007 | VelocityPerpendicular | locked | RATE 15 (continuous)
E Arrow          | tex 17291123439 | col #FFFFFF | LE0 LI0 Br1.3 | life 0.3 | size const 3.5 | tr 1.00..0.00 vis 0.50-0.50 ->1.00 | spd 0.007 | VelocityPerpendicular | locked | RATE 15 (continuous) | z 0.4
E Cube           | tex 17291053390 | col #FF557F | LE0 LI0 Br1.3 | life 0.3 | size const 1.82 | tr 1.00..0.00 vis 0.50-0.50 ->1.00 | spd 0.007 | VelocityPerpendicular | locked | RATE 15 (continuous)
E Arrow          | tex 17291123439 | col #FFFFFF | LE0 LI0 Br1.3 | life 0.3 | size const 3.5 | tr 1.00..0.00 vis 0.50-0.50 ->1.00 | spd 0.007 | VelocityPerpendicular | locked | RATE 15 (continuous) | z 0.4
E Cube           | tex 17291053390 | col #FF557F | LE0 LI0 Br1.3 | life 0.3 | size const 1.82 | tr 1.00..0.00 vis 0.50-0.50 ->1.00 | spd 0.007 | VelocityPerpendicular | locked | RATE 15 (continuous)
E Smoke2         | tex 16851495704 | col #949494 | LE0 LI0 Br2 | life 1 | size grow 0->1.75 | tr 1.00..0.42 vis 0.50-0.50 ->1.00 | spd 0.01 spread 15 acc 0-2-0 | FacingCamera/Disc | RATE 55 (continuous)
E Rain2          | tex 16851445750 | col #FFFFFF | LE0 LI0 Br1 | life 0.7-1.2 | size swell 0->0.625@0.77->0 | tr 1.00..0.63 vis 0.50-0.50 ->1.00 | spd 12 drag 0.25 | VelocityParallel | squash swell 1.46->2.1@1.00->2.1 | RATE 50 (continuous)
E Rain1          | tex 16851445750 | col #FFFFFF | LE0 LI0 Br0.5 | life 0.5-1 | size swell 0->0.625@0.77->0 | tr 1.00..0.00 vis 0.48-0.48 ->1.00 | spd 12 drag 0.25 | VelocityParallel | squash grow 0->0.675 | RATE 45 (continuous)
E Smoke1         | tex 16851518238 | col #B0B0B0 | LE0 LI0 Br1 | life 1 | size grow 0->2.31 | tr 1.00..0.77 vis 0.50-0.50 ->1.00 | spd 5-20 drag 7 spread 25-180 acc 0-3-0 | FacingCamera/Disc | flip Grid4x4 OneShot 1 | RATE 25 (continuous) | z 0.1
E Splat5         | tex 16851669869 | col #FFFFFF->#000000 | LE1 LI0 Br0.1 | life 0.3 | size grow 0->2.31 | tr 1.00..0.00 vis 0.50-0.50 ->1.00 | spd 0.01 spread 15 | VelocityPerpendicular/Disc | flip Grid4x4 OneShot 1 | RATE 25 (continuous)
E Splat4         | tex 16851644901 | col #FFFFFF | LE0 LI0 Br1 | life 0.3 | size grow 0->1 | tr 1.00..0.00 vis 0.50-0.50 ->1.00 | spd 0.01 spread 15 | VelocityParallel | flip Grid4x4 OneShot 1 | RATE 25 (continuous) | z 1
E Splat3         | tex 16851612276 | col #FFFFFF | LE0 LI0 Br1 | life 0.3 | size const 1 | tr 1.00..0.00 vis 0.50-0.50 ->1.00 | spd 0.01 | FacingCamera | flip Grid4x4 OneShot 1 | RATE 10 (continuous) | z 1
E Splat2         | tex 16851569400 | col #FFFFFF->#000000 | LE1 LI0 Br0.1 | life 0.3 | size grow 0->1 | tr 1.00..0.00 vis 0.50-0.50 ->1.00 | spd 0.01 | VelocityPerpendicular/Disc | flip Grid4x4 OneShot 1 | RATE 10 (continuous)
E Splat1         | tex 16851554715 | col #FFFFFF->#000000 | LE1 LI0 Br0.1 | life 0.3 | size grow 0->1 | tr 1.00..0.00 vis 0.50-0.50 ->1.00 | spd 0.01 | VelocityPerpendicular/Disc | flip Grid4x4 OneShot 1 | RATE 10 (continuous)
E Splat6         | tex 16851669869 | col #FFFFFF->#000000 | LE1 LI0 Br0.1 | life 0.3 | size grow 0->3.56 | tr 1.00..0.00 vis 0.50-0.50 ->1.00 | spd 0.01 | VelocityPerpendicular/Disc | flip Grid4x4 OneShot 1 | RATE 25 (continuous)
E Spec2          | tex 16789748606 | col #42FF38 | LE-5 LI0 Br25 | life 0.7-1.2 | size swell 0->0.625@0.30->0 | tr 1.00..0.00 vis 0.50-0.50 ->1.00 | spd 15-35 drag 8 spread 36 acc 0-3-0 rotSpd -720-720 | FacingCamera/Disc | locked | EMIT 45 @0 | z 0.5 | attrs {"AgainstLowSpecs": true}
E Lightning2     | tex 16864546245 | col #109F10 | LE0 LI0 Br25 | life 0.15-0.25 | size const 3.81 | tr 1.00..0.00 vis 0.37-0.77 ->1.00 | spd 25 drag 4.25 | FacingCameraWorldUp/Disc | squash const -0.5 | flip Grid4x4 OneShot 1 | locked | EMIT 35 @0 | z 0.5 | attrs {"AgainstLowSpecs": true}
E Lightning1     | tex 16864546245 | col #109F10 | LE0 LI0 Br25 | life 0.15-0.25 | size const 3 | tr 1.00..0.00 vis 0.37-0.77 ->1.00 | spd 0.01 drag 4.25 | FacingCameraWorldUp/Disc | squash shrink 0.675->-0.525 | flip Grid4x4 OneShot 1 | locked | EMIT 35 @0 | z 0.5
E Rock           | tex 16823746996 | col #7C7C7C | LE0 LI0 Br1 | life 1 | size swell 0->0.188@0.20->0 | tr flat 0.00 | spd 5 drag 1 | FacingCamera/Disc | flip Grid2x2 PingPong 0 | locked | RATE 6 (continuous)
E Shards1        | tex 17099781198 | col #5DFF62 | LE-3 LI0 Br5 | life 0.15-0.24 | size swell 0->0.75@0.20->0 | tr flat 0.00 | spd 5-25 drag 3 spread 5 | VelocityParallel/Disc | RATE 100 (continuous) | attrs {"AgainstLowSpecs": true}
E Shards2        | tex 17099820570 | col #5DFF62 | LE0 LI0 Br9 | life 0.45-0.56 | size const 3.5 | tr 0.00..0.00 vis 0.00-0.56 ->1.00 | spd 45-75 drag 7 spread 75-180 | VelocityParallel | squash const 0.4 | flip Grid4x4 OneShot 1 | RATE 100 (continuous) | z -5 | attrs {"AgainstLowSpecs": true}
E Shards1        | tex 17099781198 | col #5DFF62 | LE-3 LI0 Br5 | life 0.15-0.24 | size swell 0->2.69@0.20->0 | tr flat 0.00 | spd 45-75 drag 7 spread 75-180 | VelocityParallel | RATE 100 (continuous) | z -5 | attrs {"AgainstLowSpecs": true}
E Shock1         | tex 16835229732 | col #30FF60 | LE0 LI0 Br7 | life 0.3-0.4 | size grow 0->11.7 | tr flat 0.00 | spd 0.01 | VelocityPerpendicular | flip Grid4x4 OneShot 16 | locked | RATE 5 (continuous)
E Shockwave2     | tex 17099724622 | col #55FF7F | LE1 LI0 Br5 | life 0.15-0.25 | size grow 0->10.7 | tr 1.00..0.00 vis 0.26-0.26 ->1.00 | spd 0.01 spread 10 | VelocityPerpendicular | RATE 25 (continuous) | z 0.2
E Shockwave1     | tex 17099704475 | col #55FF7F | LE0 LI0 Br5 | life 0.4-0.7 | size grow 0->10 | tr 1.00..0.00 vis 0.55-0.55 ->1.00 | spd 0.01 spread 10 | VelocityPerpendicular | flip Grid4x4 OneShot 1 | RATE 25 (continuous)
E Aura2          | tex 17099846228 | col #69FF7A | LE0 LI0 Br3 | life 0.2 | size const 7 | tr 1.00..0.07 vis 0.50-0.50 ->1.00 | spd 5-15 | FacingCamera | flip Grid2x2 Loop 25 | locked | RATE 10 (continuous) | z -3
E Aura1          | tex 16823634298 | col #30FF4F | LE0 LI0 Br2 | life 1 | size const 6 | tr 1.00..0.00 vis 0.50-0.50 ->1.00 | spd 0.01 | VelocityParallel | squash const -0.1 | flip Grid2x2 Loop 25 | locked | RATE 3 (continuous) | z -0.9
B Beam3          | tex 17289883577 | col #6593FF | LE0 LI0 Br1 | w 0.2-0.2 curve 0.2--0.2 seg 20 | tr flat 0.00 | tex Static 1 spd 4 | z 0.1
B Beam2          | tex 17289878692 | col #FFFFFF | LE0 LI0 Br0 | w 0.2-0.2 curve 0.2--0.2 seg 20 | tr flat 0.00 | tex Static 2 spd 4 | z 0.1
B Beam           | tex 17289832450 | col #98CDFF | LE0 LI0 Br1 | w 0.4-0.3 curve 0.2--0.2 seg 20 | tr flat 0.00 | tex Stretch 1 spd 1
B Beam3          | tex 17289883577 | col #6593FF | LE0 LI0 Br1 | w 0.2-0.2 curve 0.2--0.2 seg 20 | tr flat 0.00 | tex Static 1 spd 4 | z 0.1
B Beam2          | tex 17289878692 | col #FFFFFF | LE0 LI0 Br0 | w 0.2-0.2 curve 0.2--0.2 seg 20 | tr flat 0.00 | tex Static 2 spd 4 | z 0.1
B Beam           | tex 17289832450 | col #98CDFF | LE0 LI0 Br1 | w 0.4-0.3 curve 0.2--0.2 seg 20 | tr flat 0.00 | tex Stretch 1 spd 1
B Beam           | tex 16399856722 | col #FCFF3E | LE1 LI0 Br1 | w 11-11 curve 0-0 seg 10 face | tr 1.00..0.50 vis 0.40-0.60 ->1.00 | tex Stretch 0.5 spd 0.5 | z -2
B Beam           | tex 12781853708 (A  BeamThinner ) | col #FCFF3E | LE1 LI0 Br1 | w 11-11 curve 0-0 seg 10 face | tr 1.00..0.50 vis 0.30-0.60 ->1.00 | tex Stretch 0.5 spd 0.5 | z -1
B Beam           | tex 12781804519 (A  lol3) | col #FFAB4A | LE1 LI0 Br2 | w 15-15 curve 0-0 seg 15 face | tr 1.00..0.00 vis 0.20-0.70 ->1.00 | tex Stretch 2 spd 1 | z -0.5
T Trail          | col #FFFFFF | LE0 LI1 Br1 | life 0.2 width shrink 0.519->0 | tr 0.85..0.85 vis 0.00-0.00 ->1.00 | tex Stretch 1.93 spd None
B Beam1          | col #FFB060 | LE0 LI0 Br2.7 | w 0.1-5 curve 0-0 seg 10 face | tr 0.39..0.39 vis 0.00-0.00 ->1.00 | tex Stretch 1 spd 1 | z -1
B Beam1          | col #47FF4D | LE0 LI0 Br2.7 | w 0.1-7 curve 0-0 seg 10 face | tr 0.39..0.39 vis 0.00-0.00 ->1.00 | tex Stretch 1 spd 1 | z -1
B Beam1          | col #FF557F | LE0 LI0 Br2.7 | w 0.1-5 curve 0-0 seg 10 face | tr 0.39..0.39 vis 0.00-0.00 ->1.00 | tex Stretch 1 spd 1 | z -1
P {"k": "Part", "name": "Burger", "size": [1.0, 0.8, 1.0], "mat": "Plastic", "transp": 0.0}
P {"k": "SpecialMesh", "name": "Mesh", "mesh": 16646125, "meshTex": 16432575, "scale": [1.0, 1.0, 1.0]}
P {"k": "Part", "name": "Banana", "size": [4.8, 1.2, 2.4], "mat": "Plastic", "transp": 0.0}
P {"k": "SpecialMesh", "name": "Mesh", "mesh": 4948442539, "meshTex": 4948440385, "scale": [1.2, 1.2, 1.2]}
P {"k": "Part", "name": "Cola", "size": [1.0, 1.2, 1.0], "mat": "Plastic", "transp": 0.0}
P {"k": "SpecialMesh", "name": "Mesh", "mesh": 10470609, "meshTex": 10470600, "scale": [1.2, 1.2, 1.2]}
P {"k": "Part", "name": "Handle", "size": [0.4, 0.4, 0.2], "mat": "Plastic", "transp": 0.0}
P {"k": "Part", "name": "Part", "size": [0.11, 1.0, 0.17], "mat": "Glass", "transp": 0.0}
P {"k": "Part", "name": "Part", "size": [0.14, 0.24, 0.17], "mat": "Glass", "transp": 0.0}
P {"k": "MeshPart", "name": "MeshPart", "size": [0.12, 0.19, 0.13], "mat": "Glass", "transp": 0.0, "mesh": 442062399}
P {"k": "MeshPart", "name": "MeshPart", "size": [0.07, 0.09, 0.07], "mat": "SmoothPlastic", "transp": 0.0, "mesh": 442062399}
P {"k": "Part", "name": "Handle", "size": [0.6, 0.2, 0.1], "mat": "Plastic", "transp": 0.0}
P {"k": "MeshPart", "name": "12140_Skull_v3_teeth_lower", "size": [0.53787, 0.43267, 0.14256], "mat": "Plastic", "transp": 0.0, "mesh": 14470197751}
P {"k": "MeshPart", "name": "12140_Skull_v3_teeth", "size": [0.5752, 0.45869, 0.13416], "mat": "Plastic", "transp": 0.0, "mesh": 14470197722}
P {"k": "MeshPart", "name": "12140_Skull_v3_jaw", "size": [0.93508, 0.83541, 0.66467], "mat": "Plastic", "transp": 0.0, "mesh": 14470197773}
P {"k": "MeshPart", "name": "12140_Skull_v3", "size": [1.20189, 1.77316, 1.27624], "mat": "Plastic", "transp": 0.0, "mesh": 14470197653}
P {"k": "Part", "name": "Handle", "size": [0.3, 0.3, 0.3], "mat": "Plastic", "transp": 0.0}
P {"k": "Part", "name": "Part", "size": [0.56, 0.09, 1.01], "mat": "SmoothPlastic", "transp": 0.0}
P {"k": "Part", "name": "Part", "size": [0.56, 0.09, 1.01], "mat": "SmoothPlastic", "transp": 0.0}
P {"k": "Part", "name": "Part", "size": [0.56, 0.09, 1.01], "mat": "SmoothPlastic", "transp": 0.0}
```
