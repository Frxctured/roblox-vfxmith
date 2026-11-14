# c4c74bdee9d5: excalibur morgan stuff.rbxl :: Workspace/ExcaliburStartup

- Category: **slash**; tags: beam, flash, lightning, portal, shockwave, slash, star
- Layers: 37 emitters, 28 beams, 0 trails, 1 mesh parts, 0 lights; estimated length 4.4 s
- Fired by: its own scripts (not included in the card)
- Pack file: `2026 OS Mar-April/excalibur morgan stuff.rbxl` (instance referent 571). Watch it in Studio: `kit/scripts/rbxcut.py --id c4c74bdee9d5 --studio`, then `P.load("fx_c4c74bdee9d5")` (needs the pack: `kit/scripts/get_pack.py`)
- Frames: none captured yet (play it with kit/studio/VFXLibPlayer.luau)

## Layers (one line each, in firing order; E emitter, B beam, T trail, P part, S script)
```
E Flare1         | tex 14834478801 (D  Stars) | col #FF1C20->#7C30FF->#3908FF | LE-5 LI0 Br500 | life 0.05 | size shrink 5->0 | tr flat 0.00 | spd 0.001 spread 360 | FacingCamera/Disc | locked | EMIT 25 @0
E Flare2         | tex 13908198788 | col #FF2125 | LE0 LI0 Br45 | life 0.05 | size shrink 8->0 | tr flat 0.00 | spd 0.001 | VelocityParallel/Disc | RATE 5 (continuous) | z 5
E Halftone       | tex 109985324958700 | col #FF4C4F | LE1 LI0 Br15 | life 0.05 | size const 45 | tr flat 0.00 | spd 0.001 | FacingCamera/Disc | z 25
E Glow1          | tex 187823474 | col #4635FF | LE1 LI0 Br0.2 | life 0.1 | size grow 0->45 | tr 1.00..0.66 vis 0.50-0.50 ->1.00 | spd 0.001 | FacingCamera/Disc | z 5
E Spec1          | tex 13828261486 | col #7E14FF | LE0 LI0 Br15 | life 0.2 | size swell 0->1.31@0.25->0 | tr flat 0.00 | spd 5-75 | VelocityParallel | squash const 1 | RATE 15 (continuous)
E Spec1          | tex 13828261486 | col #000000 | LE0 LI0 Br15 | life 0.2 | size swell 0->1.31@0.25->0 | tr flat 0.00 | spd 5-75 | VelocityParallel | squash const 1 | RATE 15 (continuous)
E Spec1          | tex 13828261486 | col #FF1749 | LE0 LI0 Br15 | life 0.2 | size swell 0->1.31@0.25->0 | tr flat 0.00 | spd 5-75 | VelocityParallel | squash const 1 | RATE 15 (continuous)
E Speedline2     | tex 8120278361 | col #FFFFFF | LE0 LI0 Br0 | life 0.1 | size shrink 4->2 | tr flat 0.70 | spd 45-100 | VelocityParallel/Disc | squash grow 0->2 | EMIT 0 @0 for 4 | attrs {"_lemonadeUniqueId": "ucS1FEbTucS1"}
E Speedline2     | tex 11938379208 | col #FFFFFF | LE0 LI0 Br0 | life 0.1 | size shrink 4->2 | tr 1.00..0.19 vis 0.19-0.19 ->1.00 | spd 45-100 | VelocityParallel/Disc | squash grow 0->2 | EMIT 0 @0 for 4 | attrs {"_lemonadeUniqueId": "L5DQ5ptBL5DQ"}
E Speedline1     | tex 16879830338 | col #FFFFFF | LE0 LI0 Br0 | life 0.1 | size shrink 4->2 | tr 1.00..0.19 vis 0.19-0.19 ->1.00 | spd 45 | VelocityParallel/Disc | squash grow 0->5 | EMIT 0 @0 for 4 | attrs {"_lemonadeUniqueId": "YyXN5nSSYyXN"}
E LightningRise  | tex 89116956652289 (D Grid4x4 lightning2) | col #FB4EB6 | LE0 LI0 Br15 | life 0.2-0.4 | size const 4 | tr flat 0.00 | spd 0.1-1 | VelocityParallel/Disc | squash shrink 0->-4 | flip Grid4x4 OneShot 1 | EMIT 0 @0 for 4 | z 1 | attrs {"_lemonadeUniqueId": "GqF0j3lpGqF0"}
E Main           | col #FFFFFF | LE0 LI0 Br0 | life 1 | size const 1 | tr 0.00..0.00 vis 0.00-0.00 ->1.00 | spd 0 drag 1 | FacingCamera | squash const 1.5 | flip Grid4x4 OneShot 1
E X              | col #FFFFFF | LE0 LI0 Br0 | life 0 | size const 0 | tr flat 0.00 | spd 0 | FacingCamera | squash shrink 0->-250
E Y              | col #FFFFFF | LE0 LI0 Br0 | life 0 | size const 0 | tr flat 0.00 | spd 0 | FacingCamera
E Z              | col #FFFFFF | LE0 LI0 Br0 | life 0 | size const 0 | tr flat 0.00 | spd 0 | FacingCamera
E Z              | col #000000 | LE0 LI0 Br0 | life 0 | size grow 0->1 | tr flat 0.00 | spd 0 | FacingCamera
E Y              | col #000000 | LE0 LI0 Br0 | life 0 | size grow 0->1 | tr flat 0.00 | spd 0 | FacingCamera
E X              | col #000000 | LE0 LI0 Br0 | life 0 | size const 0.8 | tr flat 0.00 | spd 0 | FacingCamera
E X              | col #000000 | LE0 LI0 Br0 | life 0 | size const 0 | tr flat 0.00 | spd 0 | FacingCamera
E Y              | col #000000 | LE0 LI0 Br0 | life 0 | size const 0 | tr flat 0.00 | spd 0 | FacingCamera
E Z              | col #000000 | LE0 LI0 Br0 | life 0 | size const 0 | tr flat 0.00 | spd 0 | FacingCamera
E Images/Detaile | tex 101617226554537 | col #FFFFFF | LE0.5 LI0.9 Br1 | life 0.5-0.7 | size grow 0->17 | tr 0.70..0.70 vis 0.00-0.00 ->1.00 | spd 0.001 spread 35 rotSpd -600 | VelocityPerpendicular | RATE 15 (continuous)
E flipbook       | tex 16026345008 (A Grid4x4 decay8) | col #FFFFFF | LE0.5 LI0.9 Br1 | life 0.5-0.7 | size grow 0->17 | tr 0.70..0.70 vis 0.00-0.00 ->1.00 | spd 0.001 spread 35 rotSpd -600 | VelocityPerpendicular | flip Grid4x4 OneShot 1 | RATE 15 (continuous) | z 2
E Glow1          | tex 187823474 | col #FF1323->#380CA5 | LE0 LI0 Br25 | life 0.2 | size grow 0->10 | tr 0.00..0.00 vis 0.00-0.00 ->1.00 | spd 0.001 | VelocityPerpendicular | RATE 45 (continuous)
E Shocke1        | tex 16892240388 (M  Impact2) | col #FF1323->#380CA5 | LE1 LI0 Br1 | life 0.2 | size grow 0->17 | tr 0.00..0.00 vis 0.00-0.00 ->1.00 | spd 0.001 | VelocityPerpendicular | RATE 15 (continuous) | z 0.001
E Main           | col #FFFFFF | LE0 LI0 Br0 | life 0.5 | size const 1 | tr 1.00..0.97 vis 0.23-0.23 ->1.00 | spd 0 drag 1 | FacingCamera | squash const 1 | flip Grid4x4 OneShot 1
E X              | col #FFFFFF | LE0 LI0 Br0 | life 0 | size const 0 | tr flat 0.00 | spd 0 | FacingCamera
E Y              | col #FFFFFF | LE0 LI0 Br0 | life 0 | size const 0 | tr flat 0.00 | spd 0 | FacingCamera | squash grow 0->150
E Z              | col #FFFFFF | LE0 LI0 Br0 | life 0 | size const 0 | tr flat 0.00 | spd 0 | FacingCamera
E Z              | col #000000 | LE0 LI0 Br0 | life 0 | size grow 0->15 | tr flat 0.00 | spd 0 | FacingCamera
E Y              | col #000000 | LE0 LI0 Br0 | life 0 | size grow 0->5 | tr flat 0.00 | spd 0 | FacingCamera
E X              | col #000000 | LE0 LI0 Br0 | life 0 | size grow 0->15 | tr flat 0.00 | spd 0 | FacingCamera
E X              | col #000000 | LE0 LI0 Br0 | life 0 | size const 0 | tr flat 0.00 | spd 0 | FacingCamera
E Y              | col #000000 | LE0 LI0 Br0 | life 0 | size const 0 | tr flat 0.00 | spd 0 | FacingCamera
E Z              | col #000000 | LE0 LI0 Br0 | life 0 | size const 0 | tr flat 0.00 | spd 0 | FacingCamera
B Wave2          | tex 13712010201 (M  BeamBeam399) | col #FF1323->#380CA5 | LE1 LI0 Br150 | w 2.49-4.97 curve 0-0 seg 10 | tr 0.90..0.90 vis 0.00-0.00 ->1.00 | tex Static 5 spd 4 | z 0.002
B Wave2          | tex 13712010201 (M  BeamBeam399) | col #FF1323->#380CA5 | LE1 LI0 Br150 | w 2.49-4.97 curve 0-0 seg 10 | tr 0.90..0.90 vis 0.00-0.00 ->1.00 | tex Static 5 spd 4 | z 0.002
B Wave2          | tex 13712010201 (M  BeamBeam399) | col #FF1323->#380CA5 | LE1 LI0 Br150 | w 2.49-4.97 curve 0-0 seg 10 | tr 0.90..0.90 vis 0.00-0.00 ->1.00 | tex Static 5 spd 4 | z 0.002
B Wave2          | tex 13712010201 (M  BeamBeam399) | col #FF1323->#380CA5 | LE1 LI0 Br150 | w 2.49-4.97 curve 0-0 seg 10 | tr 0.90..0.90 vis 0.00-0.00 ->1.00 | tex Static 5 spd 4 | z 0.002
B Wave2          | tex 13712010201 (M  BeamBeam399) | col #FF1323->#380CA5 | LE1 LI0 Br150 | w 2.49-4.97 curve 0-0 seg 10 | tr 0.90..0.90 vis 0.00-0.00 ->1.00 | tex Static 5 spd 4 | z 0.002
B Wave2          | tex 13712010201 (M  BeamBeam399) | col #FF1323->#380CA5 | LE1 LI0 Br150 | w 2.49-4.97 curve 0-0 seg 10 | tr 0.90..0.90 vis 0.00-0.00 ->1.00 | tex Static 5 spd 4 | z 0.002
B Wave2          | tex 13712010201 (M  BeamBeam399) | col #FF1323->#380CA5 | LE1 LI0 Br150 | w 2.49-4.97 curve 0-0 seg 10 | tr 0.90..0.90 vis 0.00-0.00 ->1.00 | tex Static 5 spd 4 | z 0.002
B Wave2          | tex 13712010201 (M  BeamBeam399) | col #FF1323->#380CA5 | LE1 LI0 Br150 | w 2.49-4.97 curve 0-0 seg 10 | tr 0.90..0.90 vis 0.00-0.00 ->1.00 | tex Static 5 spd 4 | z 0.002
B Wave1          | tex 77189927291566 (M  Beam97) | col #FF1323->#380CA5 | LE1 LI0 Br15 | w 2.49-4.97 curve 0-0 seg 10 | tr 0.50..0.50 vis 0.00-0.00 ->2.00 | tex Static 15 spd 4 | z 0.001
B Wave1          | tex 77189927291566 (M  Beam97) | col #FF1323->#380CA5 | LE1 LI0 Br15 | w 2.49-4.97 curve 0-0 seg 10 | tr 0.50..0.50 vis 0.00-0.00 ->2.00 | tex Static 15 spd 4 | z 0.001
B Wave1          | tex 77189927291566 (M  Beam97) | col #FF1323->#380CA5 | LE1 LI0 Br15 | w 2.49-4.97 curve 0-0 seg 10 | tr 0.50..0.50 vis 0.00-0.00 ->2.00 | tex Static 15 spd 4 | z 0.001
B Wave1          | tex 77189927291566 (M  Beam97) | col #FF1323->#380CA5 | LE1 LI0 Br15 | w 2.49-4.97 curve 0-0 seg 10 | tr 0.50..0.50 vis 0.00-0.00 ->2.00 | tex Static 15 spd 4 | z 0.001
B Wave1          | tex 77189927291566 (M  Beam97) | col #FF1323->#380CA5 | LE1 LI0 Br15 | w 2.49-4.97 curve 0-0 seg 10 | tr 0.50..0.50 vis 0.00-0.00 ->2.00 | tex Static 15 spd 4 | z 0.001
B Wave1          | tex 77189927291566 (M  Beam97) | col #FF1323->#380CA5 | LE1 LI0 Br15 | w 2.49-4.97 curve 0-0 seg 10 | tr 0.50..0.50 vis 0.00-0.00 ->2.00 | tex Static 15 spd 4 | z 0.001
B Wave1          | tex 77189927291566 (M  Beam97) | col #FF1323->#380CA5 | LE1 LI0 Br15 | w 2.49-4.97 curve 0-0 seg 10 | tr 0.50..0.50 vis 0.00-0.00 ->2.00 | tex Static 15 spd 4 | z 0.001
B Wave1          | tex 77189927291566 (M  Beam97) | col #FF1323->#380CA5 | LE1 LI0 Br15 | w 2.49-4.97 curve 0-0 seg 10 | tr 0.50..0.50 vis 0.00-0.00 ->2.00 | tex Static 15 spd 4 | z 0.001
B MainBeam1      | tex 4506771946 | col #FF1323->#380CA5 | LE0 LI0 Br10 | w 2.49-4.97 curve 0-0 seg 10 | tr 0.70..0.70 vis 0.00-0.00 ->1.00 | tex Stretch 1 spd 0
B MainBeam1      | tex 4506771946 | col #FF1323->#380CA5 | LE0 LI0 Br10 | w 2.49-4.97 curve 0-0 seg 10 | tr 0.70..0.70 vis 0.00-0.00 ->1.00 | tex Stretch 1 spd 0
B MainBeam1      | tex 4506771946 | col #FF1323->#380CA5 | LE0 LI0 Br10 | w 2.49-4.97 curve 0-0 seg 10 | tr 0.70..0.70 vis 0.00-0.00 ->1.00 | tex Stretch 1 spd 0
B MainBeam1      | tex 4506771946 | col #FF1323->#380CA5 | LE0 LI0 Br10 | w 2.49-4.97 curve 0-0 seg 10 | tr 0.70..0.70 vis 0.00-0.00 ->1.00 | tex Stretch 1 spd 0
B MainBeam1      | tex 4506771946 | col #FF1323->#380CA5 | LE0 LI0 Br10 | w 2.49-4.97 curve 0-0 seg 10 | tr 0.70..0.70 vis 0.00-0.00 ->1.00 | tex Stretch 1 spd 0
B MainBeam1      | tex 4506771946 | col #FF1323->#380CA5 | LE0 LI0 Br10 | w 2.49-4.97 curve 0-0 seg 10 | tr 0.70..0.70 vis 0.00-0.00 ->1.00 | tex Stretch 1 spd 0
B MainBeam1      | tex 4506771946 | col #FF1323->#380CA5 | LE0 LI0 Br10 | w 2.49-4.97 curve 0-0 seg 10 | tr 0.70..0.70 vis 0.00-0.00 ->1.00 | tex Stretch 1 spd 0
B MainBeam1      | tex 4506771946 | col #FF1323->#380CA5 | LE0 LI0 Br10 | w 2.49-4.97 curve 0-0 seg 10 | tr 0.70..0.70 vis 0.00-0.00 ->1.00 | tex Stretch 1 spd 0
B WindBeam1      | tex 102278053538352 | col #FFFFFF | LE1 LI0.9 Br10 | w 2-4 curve -5-5 seg 10 face | tr 1.00..0.93 vis 0.28-0.28 ->1.00 | tex Static 25 spd 2
B WindBeam1      | tex 102278053538352 | col #FFFFFF | LE1 LI0.9 Br10 | w 2-4 curve -5-5 seg 10 face | tr 1.00..0.93 vis 0.28-0.28 ->1.00 | tex Static 25 spd 2
B WindBeam1      | tex 102278053538352 | col #FFFFFF | LE1 LI0.9 Br10 | w 2-4 curve -5-5 seg 10 face | tr 1.00..0.93 vis 0.28-0.28 ->1.00 | tex Static 25 spd 2
B WindBeam1      | tex 102278053538352 | col #FFFFFF | LE1 LI0.9 Br10 | w 2-4 curve -5-5 seg 10 face | tr 1.00..0.93 vis 0.28-0.28 ->1.00 | tex Static 25 spd 2
E Swirl1         | tex 13395479051 (D Grid4x4 Particle_) | col #FF1323->#380CA5 | LE0 LI0 Br25 | life 0.6-0.8 | size grow 0->15 | tr flat 0.00 | spd 1-25 drag 2 spread 5 rotSpd -500 | VelocityPerpendicular | flip Grid4x4 OneShot 1 | locked | EMIT 5 @0.05
E LightningRay   | tex 14659557472 | col #FB4EB6 | LE0 LI0 Br15 | life 0.2-0.5 | size grow 0->10 | tr flat 0.00 | spd 0.001 spread 35 | VelocityParallel/Disc | flip Grid4x4 OneShot 1 | EMIT 7 @0.15 | z 0.125
P {"k": "SpecialMesh", "name": "Mesh", "mesh": 8501563708, "meshTex": null, "scale": [4e-05, 3e-05, 3e-05]}
P {"k": "MeshPart", "name": "Swirl2", "size": [0.001, 0.001, 0.001], "mat": "Neon", "transp": 0.8, "mesh": 5922652307}
```
