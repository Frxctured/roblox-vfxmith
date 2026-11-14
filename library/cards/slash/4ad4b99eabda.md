# 4ad4b99eabda: SnowSlam.rbxm :: Snow

- Category: **slash**; tags: ice, impact, portal, slash, smoke, star
- Layers: 48 emitters, 0 beams, 2 trails, 5 mesh parts, 0 lights; estimated length 2.5 s
- Fired by: EmitCount attributes
- Pack file: `190 OS (Oct 2024-Mar 2026)/SnowSlam.rbxm` (instance referent 0). Watch it in Studio: `kit/scripts/rbxcut.py --id 4ad4b99eabda --studio`, then `P.load("fx_4ad4b99eabda")` (needs the pack: `kit/scripts/get_pack.py`)
- Frames: none captured yet (play it with kit/studio/VFXLibPlayer.luau)

## Layers (one line each, in firing order; E emitter, B beam, T trail, P part, S script)
```
E ParticleEmitte | tex 9997556038 (M  ParticleEmit) | col #3067FF | LE1 LI0 Br1 | life 0.5-0.9 | size swell 0->0.644@0.25->0 | tr 0.95..0.00 vis 0.25-0.76 ->1.00 | spd 9.2-31 drag 3 spread -360-360 rotSpd -360-360 | FacingCamera
E Spec1          | tex 16878181512 (D  Spec1) | col #FFFFFF | LE1 LI0 Br15 | life 0.4-1.5 | size swell 0->0.404@0.21->0 | tr 0.00..0.00 vis 0.00-1.00 ->0.00 | spd 9.68-16.9 drag 5 spread -360-360 rotSpd -100-100 | FacingCamera | EMIT 15 @0
E Spec1          | tex 16878181512 (D  Spec1) | col #3067FF | LE1 LI0 Br15 | life 0.4-1.5 | size swell 0->0.404@0.21->0 | tr 0.00..0.00 vis 0.00-1.00 ->0.00 | spd 9.68-16.9 drag 5 spread -360-360 rotSpd -100-100 | FacingCamera | EMIT 15 @0
E Smoke45        | tex 16867563190 (M Grid4x4 Smoke45) | col #3E7BFF | LE1 LI0 Br5 | life 0.25-0.45 | size grow 0->3.06 | tr 1.00..0.61 vis 0.10-0.10 ->1.00 | spd 2.42-4.84 spread -360-360 | FacingCamera | flip Grid4x4 OneShot 1 | z 0.154
E Smoke45        | tex 16867563190 (M Grid4x4 Smoke45) | col #FFFFFF | LE1 LI0 Br1 | life 0.5-1 | size grow 0->3.06 | tr 1.00..0.90 vis 0.07-0.07 ->1.00 | spd 2.42-4.84 spread -360-360 | FacingCamera | flip Grid4x4 OneShot 1 | locked
E Smoke45        | tex 16867563190 (M Grid4x4 Smoke45) | col #428EFF | LE1 LI0 Br5 | life 0.5-1 | size grow 0->3.06 | tr 1.00..0.61 vis 0.10-0.10 ->1.00 | spd 2.42-4.84 spread -360-360 | FacingCamera | flip Grid4x4 OneShot 1 | locked | z 0.154
E Impact112      | tex 15232757562 (A  Impact112) | col #9F9F9F | LE1 LI0 Br1 | life 0.25-1.3 | size grow 0->14.4 | tr 0.25..0.25 vis 0.00-0.00 ->1.00 | spd 0.00418 drag 5 | VelocityPerpendicular | locked | EMIT 2 @0 | attrs {"EmitEnabled": true}
E Circle2        | tex 15811619134 | col #9F9F9F | LE1 LI0 Br1 | life 0.25-1.3 | size grow 0->14.4 | tr 0.00..0.00 vis 0.00-0.00 ->1.00 | spd 0.00418 drag 5 | VelocityPerpendicular | locked | EMIT 2 @0 | attrs {"EmitEnabled": true}
E Basic 2x2      | tex 14050533905 (M Grid2x2 Basic 2x2) | col #9F9F9F | LE1 LI0 Br1 | life 0.25-1.3 | size grow 0->3.46 | tr 0.00..0.00 vis 0.00-0.00 ->1.00 | spd 23.8-47.5 drag 5 spread 0-360 | FacingCamera | flip Grid2x2 OneShot 1 | locked | EMIT 15 @0 | attrs {"EmitEnabled": true}
E New1           | tex 12922845759 (M  4) | col #6F6F6F | LE1 LI0 Br0.5 | life 0.3-1 | size grow 0->12.7 | tr 1.00..0.63 vis 0.15-0.15 ->1.00 | spd 0.199-0.994 spread -360 | VelocityParallel/Disc | locked | EMIT 3 @0
E Simple Gapped  | tex 16924410706 (D Grid4x4 Simple Gappe) | col #6F6F6F | LE1 LI0 Br0.5 | life 0.3-1 | size grow 0->12.7 | tr 1.00..0.41 vis 0.17-0.17 ->1.00 | spd 0.199-0.994 spread -360 | VelocityParallel/Disc | flip Grid4x4 OneShot 25.4 | locked | EMIT 3 @0
E CirclesFB5     | tex 131834556810162 (D Grid4x4 CirclesFB5) | col #4063FF | LE1 LI0 Br20 | life 0.08 | size shrink 16.1->0 | tr flat 0.00 | spd 0.00259 | FacingCamera | flip Grid4x4 OneShot 1 | EMIT 1 @0 | z 1.1
E Flare199New    | tex 15267986070 | col #4063FF | LE1 LI0 Br20 | life 0.08 | size shrink 16.1->0 | tr flat 0.00 | spd 0.00259 | FacingCamera | EMIT 1 @0 | z 1.1
E Spec27         | tex 16879808635 (M Grid4x4 Spec27) | col #375CFF | LE1 LI0 Br15 | life 0.4-1.5 | size swell 0->0.769@0.21->0 | tr 0.00..0.00 vis 0.00-1.00 ->0.00 | spd 27.5-71.5 drag 8 spread -150-150 acc 0--2.2-0 rotSpd -100-100 | FacingCamera | locked | EMIT 15 @0
E Spec1          | tex 16878181512 (D  Spec1) | col #FFFFFF | LE1 LI0 Br15 | life 0.4-1.5 | size swell 0->0.769@0.21->0 | tr 0.00..0.00 vis 0.00-1.00 ->0.00 | spd 27.5-71.5 drag 8 spread -150-150 acc 0--2.2-0 rotSpd -100-100 | FacingCamera | locked | EMIT 15 @0
E Spec1          | tex 16878181512 (D  Spec1) | col #375CFF | LE1 LI0 Br15 | life 0.4-1.5 | size swell 0->0.769@0.21->0 | tr 0.00..0.00 vis 0.00-1.00 ->0.00 | spd 27.5-71.5 drag 8 spread -150-150 acc 0--2.2-0 rotSpd -100-100 | FacingCamera | locked | EMIT 15 @0
E Impact321      | tex 18356099314 (A  rizzimpact) | col #959595 | LE1 LI0 Br1 | life 0.3-0.6 | size grow 0->9.18 | tr 1.00..0.65 vis 0.12-0.12 ->1.00 | spd 0.001 drag 2 spread 1 | VelocityPerpendicular | EMIT 1 @0 | z 0.831
E Impact321      | tex 18356099314 (A  rizzimpact) | col #959595 | LE1 LI0 Br1 | life 0.3-0.6 | size grow 0->19.2 | tr 1.00..0.74 vis 0.20-0.20 ->1.00 | spd 0.0021 drag 2 spread 5 | VelocityPerpendicular | EMIT 2 @0 | z 1.74
E Circle2        | tex 15811619134 | col #959595 | LE1 LI0 Br1 | life 0.3-0.6 | size grow 0->11.9 | tr 1.00..0.68 vis 0.02-0.02 ->1.00 | spd 0.0013 drag 2 | VelocityPerpendicular | EMIT 1 @0 | z 1.08
E Impact6122     | tex 115257157082446 (M Grid4x4 Impact61) | col #959595 | LE1 LI0 Br1 | life 0.185-0.235 | size grow 0->14.4 | tr 1.00..0.77 vis 0.10-0.10 ->1.00 | spd 0.00158 drag 2 spread 2 | VelocityPerpendicular | flip Grid4x4 OneShot 1 | EMIT 2 @0
E Circle2        | tex 15811619134 | col #FFFFFF | LE1 LI0 Br0.5 | life 0.197-0.59 | size grow 0->21.3 | tr 1.00..0.00 vis 0.09-0.09 ->1.00 | spd 0.333-1.67 spread 2 | VelocityPerpendicular/Disc | locked | EMIT 1 @0
E Greyish Smoke  | tex 16172858603 (M Grid4x4 Greyish Smok) | col #6B6B6B | LE0.9 LI0 Br1 | life 0.5-1.6 | size grow 0->10.6 | tr 1.00..0.79 vis 0.04-0.04 ->1.00 | spd 39.5-72.7 drag 6 spread 0-360 acc 0--9.78-0 | FacingCamera | flip Grid4x4 OneShot 1 | locked | EMIT 13 @0 | attrs {"EmitEnabled": true}
E Basic          | tex 14050526759 (M Grid2x2 Dust) | col #9F9F9F | LE1 LI0 Br1 | life 0.25-1.3 | size grow 0->3.46 | tr 1.00..0.75 vis 0.08-0.08 ->1.00 | spd 23.8-47.5 drag 4.55 spread 0-360 | FacingCamera | flip Grid2x2 OneShot 1 | locked | EMIT 10 @0 | attrs {"EmitEnabled": true}
E Smokey Crescen | tex 17085222506 (M Grid4x4 Black Cresen) | col #6F6F6F | LE1 LI0 Br0.5 | life 0.222-0.65 | size grow 0->19.4 | tr 1.00..0.00 vis 0.12-0.12 ->1.00 | spd 0.303-1.52 spread 6 | VelocityPerpendicular/Disc | flip Grid4x4 OneShot 25.4 | locked | EMIT 4 @0
E Slash3         | tex 15811547630 (D  New70) | col #B4B4B4 | LE1 LI0 Br0.5 | life 0.222-0.65 | size grow 0->19.4 | tr 1.00..0.00 vis 0.09-0.09 ->1.00 | spd 0.303-1.52 drag 1 spread 6 | VelocityPerpendicular/Disc | locked | EMIT 4 @0
E Basic 2x2      | tex 14050533905 (M Grid2x2 Basic 2x2) | col #9F9F9F | LE1 LI0 Br1 | life 0.25-1.3 | size grow 0->3.46 | tr 0.00..0.00 vis 0.00-0.00 ->1.00 | spd 23.8-47.5 drag 5 spread 0-90 | FacingCamera | flip Grid2x2 OneShot 1 | locked | EMIT 15 @0 | attrs {"EmitEnabled": true}
E Energy Spec    | tex 131880846582449 | col #4063FF | LE1 LI0 Br15 | life 0.1-0.15 | size swell 0->8.42@0.50->0 | tr flat 0.00 | spd 124-156 drag 200 | VelocityParallel | squash const 2 | flip Grid4x4 OneShot 1.44 | EMIT 1 @0 | attrs {"EmitEnabled": true}
E 90             | tex 16879608903 (M Grid4x4 Spec13) | col #4063FF | LE1 LI0 Br15 | life 0.1-0.15 | size swell 0->8.42@0.50->0 | tr flat 0.00 | spd 124-156 drag 200 | VelocityParallel | squash const 2 | flip Grid4x4 OneShot 1.44 | EMIT 1 @0 | attrs {"EmitEnabled": true}
E Noised Spec    | tex 110239611390706 | col #4063FF | LE1 LI0 Br15 | life 0.1-0.15 | size swell 0->8.42@0.50->0 | tr flat 0.00 | spd 124-156 drag 200 | VelocityParallel | squash const -1 | flip Grid8x8 OneShot 1.44 | EMIT 1 @0 | attrs {"EmitEnabled": true}
E CirclesFB5     | tex 131834556810162 (D Grid4x4 CirclesFB5) | col #4063FF | LE1 LI0 Br10 | life 0.1 | size grow 0->13.7 | tr flat 0.00 | spd 0.00161 | FacingCamera | flip Grid4x4 OneShot 1 | EMIT 1 @0
E Flare147New    | tex 9509570418 (A  Flare147New) | col #2256FF | LE1 LI0 Br5 | life 0.08 | size grow 0->24.4 | tr flat 0.00 | spd 6.94 spread 6 | VelocityPerpendicular | EMIT 5 @0
E Slash31        | tex 91842381194398 | col #3463FF | LE1 LI0 Br17 | life 0.555-1.8 | size grow 0->16.2 | tr 0.00..0.00 vis 0.00-0.12 ->1.00 | spd 1.46-3.24 drag 0.5 spread 8 rotSpd -100-100 | VelocityPerpendicular/Disc | flip Grid4x4 OneShot 25.4 | locked | EMIT 3 @0
E Spinning Shard | tex 16924875355 (M Grid4x4 Spinning Sha) | col #FFFFFF | LE1 LI0 Br10 | life 0.4-2.5 | size swell 0->0.433@0.21->0 | tr 0.00..0.00 vis 0.00-1.00 ->0.00 | spd 33-88 drag 7.5 spread 120 acc 0--16.5-0 rotSpd -100-100 | FacingCamera | flip Grid4x4 OneShot 1 | locked | EMIT 17 @0
E Finished fade  | tex 13781849388 (M Grid4x4 Finished fad) | col #3067FF | LE1 LI0 Br3 | life 0.87-1.55 | size const 13.3 | tr 0.00..0.00 vis 0.00-0.30 ->1.00 | spd 0.00133 | VelocityPerpendicular | flip Grid4x4 OneShot 1 | EMIT 1 @0 | z 1
E Smoke32        | tex 16867490141 (M Grid4x4 Smoke) | col #4787FF | LE1 LI0 Br5 | life 1-1.55 | size grow 0->6.42 | tr 1.00..0.88 vis 0.04-0.04 ->1.00 | spd 11-77 drag 11 spread -260-260 acc 0--10-0 | FacingCamera | flip Grid4x4 OneShot 1 | EMIT 20 @0 | z -0.00115
E Snowfall       | tex 16511071584 (M Grid8x8 Snowfall) | col #4063FF | LE1 LI0 Br15 | life 0.4-1.4 | size grow 0->3.71 | tr 0.00..0.00 vis 0.00-0.52 ->1.00 | spd 21-52.5 drag 7.25 spread 115 acc 0--9.45-0 | FacingCamera | flip Grid8x8 OneShot 1 | locked | EMIT 22 @0
E SmokeUp        | tex 10180479311 (M  Smoke) | col #3E7BFF | LE1 LI0 Br5 | life 1-1.55 | size grow 0->6.42 | tr 0.00..0.00 vis 0.00-0.00 ->1.00 | spd 11-77 drag 11 spread -260-260 acc 0--33-0 | FacingCamera | squash const -1 | EMIT 20 @0 | z -0.00115
E Smokey Crescen | tex 17085222506 (M Grid4x4 Black Cresen) | col #3471FF | LE1 LI0 Br17 | life 0.44-1.5 | size grow 0->24.6 | tr 0.00..0.00 vis 0.00-0.12 ->1.00 | spd 1.54-3.07 drag 0.5 spread 8 rotSpd -100-100 | VelocityPerpendicular/Disc | flip Grid4x4 OneShot 25.4 | locked | EMIT 5 @0
E Snowflake      | tex 68072538 | col #3755FF | LE1 LI0 Br12 | life 0.4-1.15 | size swell 0->0.786@0.22->0 | tr flat 0.00 | spd 30.2-54.5 drag 5 spread 120 acc 0--5.5-0 rotSpd -50-50 | FacingCamera | flip Grid8x8 OneShot 1 | EMIT 8 @0
E Spinning Shard | tex 16924875355 (M Grid4x4 Spinning Sha) | col #224BFF | LE1 LI0 Br15 | life 0.4-2.5 | size swell 0->0.769@0.21->0 | tr 0.00..0.00 vis 0.00-1.00 ->0.00 | spd 36.3-96.8 drag 7.9 spread 120 acc 0--18.1-0 rotSpd -100-100 | FacingCamera | flip Grid4x4 OneShot 1 | locked | EMIT 17 @0
E Splat          | tex 16892272385 (M  Impact28) | col #3978FF | LE1 LI0 Br15 | life 0.2-0.45 | size grow 0->20.6 | tr 0.00..0.00 vis 0.00-0.00 ->1.00 | spd 0.00099 spread 2 | VelocityPerpendicular | EMIT 2 @0 | z 0.4
E Smoke45        | tex 16867563190 (M Grid4x4 Smoke45) | col #3791FF->#417AFF->#FFFFFF | LE1 LI0 Br5 | life 1-1.55 | size grow 0->7.11 | tr 0.00..0.00 vis 0.00-0.00 ->1.00 | spd 24.2-79.1 drag 6 spread 0-360 acc 0-5.5-0 rotSpd -100-100 | FacingCamera | flip Grid4x4 OneShot 1 | EMIT 25 @0 | z -0.00115
E soft impact    | tex 88836910549343 (A  wind) | col #3791FF->#63A9FF->#FFFFFF | LE1 LI0 Br2 | life 0.258-0.774 | size grow 0->24.9 | tr 0.69..0.69 vis 0.00-0.00 ->1.00 | spd 0.161 rotSpd -5.81-5.81 | VelocityPerpendicular | EMIT 1 @0
E Star           | tex 17062451640 (M  Star) | col #3067FF | LE1 LI0 Br10 | life 1-2 | size swell 0->1.16@0.20->0 | tr flat 0.00 | spd 36.6-65.9 drag 6 spread 100 acc 0--6.66-0 | FacingCamera | locked | EMIT 10 @0 | z 1.15
E Fading Snowfla | tex 13243734535 | col #3067FF | LE1 LI0 Br20 | life 1-2 | size const 13.3 | tr 0.00..0.00 vis 0.00-0.30 ->1.00 | spd 0.00133 | VelocityPerpendicular | flip Grid4x4 OneShot 1 | EMIT 1 @0 | z 1
E Snowflake      | tex 87559021239332 | col #2256FF | LE1 LI0 Br20 | life 0.4-1.15 | size swell 0->0.786@0.22->0 | tr flat 0.00 | spd 30.2-54.5 drag 5 spread 120 acc 0--11-0 rotSpd -50-50 | FacingCamera | flip Grid8x8 OneShot 1 | EMIT 20 @0
E Lower Res Snow | tex 14186189742 | col #3067FF | LE1 LI0 Br15 | life 0.4-1.15 | size swell 0->0.262@0.20->0 | tr 0.00..0.00 vis 0.00-0.60 ->1.00 | spd 30.2-54.5 drag 5 spread 120 | FacingCamera | flip Grid8x8 OneShot 1 | EMIT 10 @0
E ParticleEmitte | tex 14124153904 (M  ParticleEmit) | col #2E7EFF | LE1 LI0 Br3 | life 0.75 | size grow 0->3.69 | tr 1.00..0.00 vis 0.49-0.49 ->1.00 | spd 0 | FacingCamera | locked | RATE 3 (continuous) | z 1
T Trail          | tex 11829306338 | col #4699FF | LE1 LI0 Br5 | life 0.195 width shrink 1->0 | tr 1.00..0.50 vis 0.30-1.00 ->0.50 | tex Static 3 spd None
T Trail          | tex 14633984190 (A  Beam) | col #4699FF | LE1 LI0 Br5 | life 0.195 width shrink 1->0 | tr 1.00..0.50 vis 0.30-1.00 ->0.50 | tex Stretch 1 spd None
P {"k": "Part", "name": "Right Leg", "size": [1.0, 2.0, 1.0], "mat": "Plastic", "transp": 0.0}
P {"k": "Part", "name": "Left Leg", "size": [1.0, 2.0, 1.0], "mat": "Plastic", "transp": 0.0}
P {"k": "Part", "name": "Right Arm", "size": [1.0, 2.0, 1.0], "mat": "Plastic", "transp": 0.0}
P {"k": "Part", "name": "Left Arm", "size": [1.0, 2.0, 1.0], "mat": "Plastic", "transp": 0.0}
P {"k": "Part", "name": "Torso", "size": [2.0, 2.0, 1.0], "mat": "Plastic", "transp": 0.0}
P {"k": "Part", "name": "Head", "size": [2.0, 1.0, 1.0], "mat": "Plastic", "transp": 0.0}
P {"k": "MeshPart", "name": "Meshes/222_Cylinder.003", "size": [0.74038, 1.98453, 8.62025], "mat": "DiamondPlate", "transp": 0.0, "mesh": 137711024302501}
P {"k": "MeshPart", "name": "Meshes/222_Plane.004", "size": [0.91153, 3.8016, 11.32374], "mat": "DiamondPlate", "transp": 0.0, "mesh": 113176034118823}
P {"k": "MeshPart", "name": "Meshes/222_Cylinder", "size": [0.63381, 0.63381, 7.01103], "mat": "DiamondPlate", "transp": 0.0, "mesh": 108287658583351}
P {"k": "MeshPart", "name": "Meshes/222_Cylinder.001", "size": [0.36794, 2.17631, 2.84071], "mat": "DiamondPlate", "transp": 0.0, "mesh": 71602299389997}
P {"k": "MeshPart", "name": "Meshes/222_Sphere", "size": [0.39258, 2.7574, 1.94443], "mat": "Neon", "transp": 0.35, "mesh": 83153462590663}
P {"k": "Part", "name": "Handle", "size": [1.03, 1.0, 1.67], "mat": "Plastic", "transp": 0.0}
P {"k": "SpecialMesh", "name": "Mesh", "mesh": 319337852, "meshTex": 376189070, "scale": [0.55, 0.55, 0.55]}
```
