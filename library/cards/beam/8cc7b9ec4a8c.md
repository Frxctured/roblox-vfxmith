# 8cc7b9ec4a8c: Missile Sequence.rbxm :: Missiles

- Category: **beam**; tags: beam, flash, ice, impact, projectile, shockwave, smoke, star
- Layers: 50 emitters, 0 beams, 8 trails, 1 mesh parts, 4 lights; estimated length 8.0 s
- Fired by: EmitCount attributes
- Pack file: `190 OS (Oct 2024-Mar 2026)/Missile Sequence.rbxm` (instance referent 0). Watch it in Studio: `kit/scripts/rbxcut.py --id 8cc7b9ec4a8c --studio`, then `P.load("fx_8cc7b9ec4a8c")` (needs the pack: `kit/scripts/get_pack.py`)
- Frames: none captured yet (play it with kit/studio/VFXLibPlayer.luau)

## Layers (one line each, in firing order; E emitter, B beam, T trail, P part, S script)
```
E Rotating Star  | tex 129871600983536 | col #5364FF->#2C25FF | LE0 LI0 Br3 | life 0.3-0.6 | size shrink 0.557->0 | tr flat 0.00 | spd 4.46-8.17 drag 1 | FacingCamera/Sphere | flip Grid4x4 Loop 20-30 | RATE 10 (continuous) | z -0.1
E Glowing Bezier | tex 16056965573 (M Grid4x4 Glowing Bezi) | col #5364FF->#2C25FF | LE0 LI0 Br3 | life 0.4-1.5 | size shrink 0.743->0.334 | tr flat 0.00 | spd 2.97-14.9 drag 2 spread -15-15 | VelocityParallel | squash const 0.1 | flip Grid4x4 OneShot 20-30 | RATE 25 (continuous) | z -1.1
E Glowing Bezier | tex 16056965573 (M Grid4x4 Glowing Bezi) | col #5364FF->#2C25FF | LE0 LI0 Br10 | life 0.3-1.35 | size shrink 0.743->0.334 | tr flat 0.00 | spd 2.97-14.9 drag 2 spread -15-15 | VelocityParallel | squash const 0.1 | flip Grid4x4 OneShot 20-30 | RATE 25 (continuous) | z -1
E Rotating Star  | tex 129871600983536 | col #5364FF->#2C25FF | LE0 LI0 Br6 | life 0.3-0.6 | size shrink 0.557->0 | tr flat 0.00 | spd 4.46-8.17 drag 1 | FacingCamera/Sphere | flip Grid4x4 Loop 20-30 | RATE 10 (continuous)
E Slightly Round | tex 3057073083 | col #5364FF | LE0 LI0 Br6 | life 2 | size const 1.2 | tr flat 0.00 | spd 0.00149 | FacingCamera | locked | RATE 2 (continuous)
E Basic Blurry S | tex 77024587778878 (M  Basic Blurry) | col #5364FF->#2C25FF | LE0.9 LI0 Br0.1 | life 0.4-2 | size grow 0->4.25 | tr 1.00..0.00 vis 0.15-0.55 ->1.00 | spd 0.00082 | VelocityPerpendicular/Cylinder | squash grow 0->3 | locked | EMIT 4 @0
E Basic Hit      | tex 14379750639 (D Grid4x4 Basic Hit) | col #5364FF->#2C25FF | LE0 LI0 Br6 | life 2.4 | size grow 0->16 | tr flat 0.00 | spd 0.001 | VelocityPerpendicular | flip Grid4x4 OneShot 1 | EMIT 1 @0 | z 1
E Fast spiky wav | tex 17612128831 (D Grid4x4 Fast spiky w) | col #5364FF->#2C25FF | LE0 LI0 Br6 | life 1 | size grow 0->18 | tr flat 0.00 | spd 0.001 | VelocityPerpendicular | flip Grid4x4 OneShot 1 | EMIT 1 @0 | z 1
E InstantStar    | tex 98196282003681 | col #5061FF | LE0 LI0 Br5.5 | life 2 | size const 10 | tr 0.00..0.00 vis 0.00-0.69 ->1.00 | spd 0.001 | VelocityPerpendicular | locked | EMIT 4 @0
E Star           | tex 98196282003681 | col #5061FF | LE0 LI0 Br5.5 | life 1.6 | size const 10 | tr 1.00..0.00 vis 0.50-0.50 ->1.00 | spd 0.001 | VelocityPerpendicular | locked | EMIT 4 @0
E Slightly glowi | tex 14152113700 (M Grid4x4 Slightly glo) | col #5364FF->#2C25FF | LE0 LI0 Br6 | life 1-1.1 | size const 14.5 | tr 1.00..0.00 vis 0.18-0.18 ->1.00 | spd 0.001 | VelocityPerpendicular | flip Grid4x4 OneShot 1 | locked | EMIT 4 @0
E Instant Spec   | tex 77024587778878 (M  Basic Blurry) | col #5061FF | LE0 LI0 Br0.4 | life 2 | size const 14 | tr 0.00..0.00 vis 0.00-0.50 ->1.00 | spd 0.001 | VelocityPerpendicular | locked | EMIT 4 @0
E Basic Blurry S | tex 77024587778878 (M  Basic Blurry) | col #5061FF | LE0 LI0 Br0.4 | life 2 | size const 14 | tr 1.00..0.00 vis 0.50-0.50 ->1.00 | spd 0.001 | VelocityPerpendicular | locked | EMIT 4 @0
E thick ring     | tex 4936211373 | col #5061FF | LE0 LI0 Br2 | life 2 | size const 10 | tr 1.00..0.00 vis 0.50-0.50 ->1.00 | spd 0.001 | VelocityPerpendicular | locked | EMIT 4 @0
E Circle outline | tex 93664782251648 | col #5364FF->#2C25FF | LE0 LI0 Br3 | life 1-2 | size grow 0->20 | tr 1.00..0.78 vis 0.18-0.18 ->1.00 | spd 0.001 | VelocityPerpendicular | flip Grid2x2 OneShot 1 | locked | EMIT 4 @0
E Smooth Circle  | tex 82634208863762 (M  Smooth Circl) | col #5061FF | LE0.2 LI0 Br6 | life 2 | size const 10 | tr 1.00..0.00 vis 0.50-0.50 ->1.00 | spd 0.001 | VelocityPerpendicular | locked | EMIT 4 @0
E Basic Blurry S | tex 77024587778878 (M  Basic Blurry) | col #5364FF->#2C25FF | LE1 LI0 Br0.05 | life 0.7 | size const 3 | tr 1.00..0.00 vis 0.50-0.50 ->1.00 | spd 0 | FacingCamera | locked | EMIT 1 @0 | z 5
E Fading Smoke H | tex 18326864825 (A Grid4x4 Smoke) | col #5364FF->#2C25FF | LE0.7 LI0 Br2 | life 0.6-1.9 | size grow 0->5.22 | tr 0.74..0.74 vis 0.00-0.00 ->1.00 | spd 17.4-26.1 drag 10 acc 0--3.04-0 rotSpd -7-7 | FacingCamera/Sphere | flip Grid4x4 OneShot 20-30 | EMIT 12 @0
E Snowfall       | tex 16511071584 (M Grid8x8 Snowfall) | col #5364FF->#2C25FF | LE0 LI0 Br6 | life 0.7-1.4 | size const 3 | tr 0.66..0.66 vis 0.00-0.00 ->1.00 | spd 20-30 drag 10 acc 0--3.5-0 | FacingCamera/Sphere | flip Grid8x8 OneShot 20-30 | EMIT 20 @0 | z -1
E Snowfall       | tex 16511071584 (M Grid8x8 Snowfall) | col #5364FF->#2C25FF | LE0 LI0 Br3 | life 0.7-1.4 | size const 3 | tr 0.66..0.66 vis 0.00-0.00 ->1.00 | spd 20-30 drag 10 acc 0--3.5-0 | FacingCamera/Sphere | flip Grid8x8 OneShot 20-30 | EMIT 20 @0 | z -1.1
E Rotating Star  | tex 129871600983536 | col #5364FF->#2C25FF | LE0 LI0 Br3 | life 0.5-1.1 | size shrink 0.375->0 | tr flat 0.00 | spd 20-30 drag 10 acc 0--3.5-0 | FacingCamera/Sphere | flip Grid4x4 Loop 20-30 | EMIT 13 @0 | z 0.9
E Rotating Star  | tex 129871600983536 | col #5364FF->#2C25FF | LE0 LI0 Br6 | life 0.4-1 | size shrink 0.375->0 | tr flat 0.00 | spd 20-30 drag 10 acc 0--3.5-0 | FacingCamera/Sphere | flip Grid4x4 Loop 20-30 | EMIT 13 @0 | z 1
E Fading Smoke H | tex 18326864825 (A Grid4x4 Smoke) | col #5364FF->#2C25FF | LE0.7 LI0 Br2 | life 0.6-2.2 | size grow 0->5.65 | tr 0.70..0.70 vis 0.00-0.00 ->1.00 | spd 24.9-43.4 drag 10 spread -360-360 acc 0--3.3-0 rotSpd -7-7 | FacingCamera | flip Grid4x4 OneShot 20-30 | EMIT 15 @0
E Snowfall       | tex 16511071584 (M Grid8x8 Snowfall) | col #5364FF->#2C25FF | LE0 LI0 Br3 | life 0.5-1.1 | size const 5 | tr 0.66..0.66 vis 0.00-0.00 ->1.00 | spd 40-60 drag 10 spread -360-360 acc 0--3.5-0 | FacingCamera | flip Grid4x4 Loop 20-30 | EMIT 16 @0 | z 0.9
E Snowfall       | tex 16511071584 (M Grid8x8 Snowfall) | col #5364FF->#2C25FF | LE0 LI0 Br6 | life 0.4-1 | size const 5 | tr 0.66..0.66 vis 0.00-0.00 ->1.00 | spd 40-60 drag 10 spread -360-360 acc 0--3.5-0 | FacingCamera | flip Grid4x4 Loop 20-30 | EMIT 16 @0 | z 1
E Rotating Star  | tex 129871600983536 | col #5364FF->#2C25FF | LE0 LI0 Br6 | life 0.4-1 | size shrink 0.375->0 | tr flat 0.00 | spd 40-60 drag 10 spread -360-360 acc 0--3.5-0 | FacingCamera | flip Grid4x4 Loop 20-30 | EMIT 16 @0 | z 1
E Rotating Star  | tex 129871600983536 | col #5364FF->#2C25FF | LE0 LI0 Br3 | life 0.5-1.1 | size shrink 0.375->0 | tr flat 0.00 | spd 40-60 drag 10 spread -360-360 acc 0--3.5-0 | FacingCamera | flip Grid4x4 Loop 20-30 | EMIT 16 @0 | z 0.9
E Slightly Round | tex 3057073083 | col #5364FF | LE0 LI0 Br4 | life 4.1 | size shrink 1.5->1.3 | tr 0.00..0.00 vis 0.00-0.88 ->1.00 | spd 0.00149 rotSpd 35 | FacingCamera | locked | EMIT 1 @0 | z 5
E Star102        | tex 17391818367 (M  Star102) | col #5364FF->#2C25FF | LE1 LI0 Br6 | life 0.04 | size shrink 6.09->0 | tr flat 0.00 | spd 0 | FacingCamera | squash const -2 | EMIT 1 @0
E Impact40       | tex 16892332741 (D  Impact40) | col #5364FF->#2C25FF | LE0 LI0 Br5 | life 0.1 | size shrink 8.53->0 | tr flat 0.00 | spd 0 | FacingCamera | EMIT 1 @0 | z 6.1
E Basic Hit      | tex 14379750639 (D Grid4x4 Basic Hit) | col #5364FF->#2C25FF | LE0 LI0 Br4 | life 0.29 | size grow 0->7.31 | tr 0.00..0.00 vis 0.00-0.16 ->1.00 | spd 0 | FacingCamera | flip Grid4x4 OneShot 1 | EMIT 1 @0 | z 6.1
E Star102        | tex 17391818367 (M  Star102) | col #5364FF->#2C25FF | LE1 LI0 Br6 | life 0.07 | size grow 0->11.9 | tr 0.00..0.00 vis 0.00-0.16 ->1.00 | spd 0 | FacingCamera | EMIT 1 @0 | z 6
E Basic Blurry S | tex 77024587778878 (M  Basic Blurry) | col #5364FF->#2C25FF | LE0 LI0 Br5 | life 0.04 | size grow 0->10.8 | tr 0.00..0.00 vis 0.00-0.16 ->1.00 | spd 0 | FacingCamera | EMIT 1 @0 | z 6
E Basic Blurry S | tex 77024587778878 (M  Basic Blurry) | col #5364FF->#2C25FF | LE0 LI0 Br2 | life 8 | size grow 0->6.26 | tr 0.32..0.32 vis 0.00-0.00 ->1.00 | spd 0 | FacingCamera | EMIT 1 @0 | z 4.1
E Star102        | tex 17391818367 (M  Star102) | col #5364FF->#2C25FF | LE1 LI0 Br6 | life 0.04 | size shrink 5->0 | tr flat 0.00 | spd 0 | FacingCamera | squash const -2 | EMIT 1 @0
E Star102        | tex 17391818367 (M  Star102) | col #5364FF->#2C25FF | LE1 LI0 Br6 | life 0.07 | size grow 0->9.77 | tr 0.00..0.00 vis 0.00-0.16 ->1.00 | spd 0 | FacingCamera | EMIT 1 @0 | z 6
E Impact40       | tex 16892332741 (D  Impact40) | col #5364FF->#2C25FF | LE0 LI0 Br5 | life 0.1 | size shrink 7->0 | tr flat 0.00 | spd 0 | FacingCamera | EMIT 1 @0 | z 6.1
E Basic Hit      | tex 14379750639 (D Grid4x4 Basic Hit) | col #5364FF->#2C25FF | LE0 LI0 Br4 | life 0.29 | size grow 0->6 | tr 0.00..0.00 vis 0.00-0.16 ->1.00 | spd 0 | FacingCamera | flip Grid4x4 OneShot 1 | EMIT 1 @0 | z 6.1
E Basic Blurry S | tex 77024587778878 (M  Basic Blurry) | col #5364FF->#2C25FF | LE0 LI0 Br1.5 | life 0.4 | size grow 0->6 | tr 0.32..0.32 vis 0.00-0.00 ->1.00 | spd 0 | FacingCamera | EMIT 1 @0 | z 4.1
E Basic Blurry S | tex 77024587778878 (M  Basic Blurry) | col #5364FF->#2C25FF | LE0 LI0 Br5 | life 0.04 | size grow 0->8.9 | tr 0.00..0.00 vis 0.00-0.16 ->1.00 | spd 0 | FacingCamera | EMIT 1 @0 | z 6
E Rotating Star  | tex 129871600983536 | col #5364FF->#2C25FF | LE0 LI0 Br3 | life 0.4-1 | size shrink 0.375->0 | tr flat 0.00 | spd 10-20 drag 10 acc 0--3.5-0 | FacingCamera/Sphere | flip Grid4x4 Loop 20-30 | EMIT 2 @0 | z -0.1
E Rotating Star  | tex 129871600983536 | col #5364FF->#2C25FF | LE0 LI0 Br6 | life 0.4-1 | size shrink 0.375->0 | tr flat 0.00 | spd 10-20 drag 10 acc 0--3.5-0 | FacingCamera/Sphere | flip Grid4x4 Loop 20-30 | EMIT 2 @0
E Slightly Round | tex 3057073083 | col #5364FF->#2C25FF | LE0 LI0 Br3 | life 0.2 | size grow 0->2.5 | tr 0.00..0.00 vis 0.00-0.00 ->1.00 | spd 0 | FacingCamera | locked | EMIT 1 @0 | z 4
E Circle4        | tex 16877851515 (D Grid4x4 Ring) | col #5364FF->#2C25FF | LE0 LI0 Br6 | life 0.4 | size grow 0->5.42 | tr 0.00..0.00 vis 0.00-0.50 ->1.00 | spd 0 | FacingCamera | flip Grid4x4 OneShot 1 | locked | EMIT 1 @0 | z 5
E Basic Blurry S | tex 77024587778878 (M  Basic Blurry) | col #5364FF->#2C25FF | LE1 LI0 Br0.1 | life 0.65 | size grow 0->6 | tr 1.00..0.00 vis 0.50-0.50 ->1.00 | spd 0 | FacingCamera | locked | EMIT 1 @0 | z 5
E Rotating Star  | tex 129871600983536 | col #5364FF->#2C25FF | LE0 LI0 Br3 | life 0.3-0.6 | size shrink 0.375->0 | tr flat 0.00 | spd 3-5.5 drag 1 | FacingCamera/Sphere | flip Grid4x4 Loop 20-30 | RATE 9 (continuous) | z -0.1
E Glowing Bezier | tex 16056965573 (M Grid4x4 Glowing Bezi) | col #5364FF->#2C25FF | LE0 LI0 Br3 | life 0.4-1.5 | size shrink 0.5->0.225 | tr flat 0.00 | spd 2-10 drag 2 spread -15-15 | VelocityParallel | squash const 0.1 | flip Grid4x4 OneShot 20-30 | RATE 15 (continuous) | z -1.1
E Glowing Bezier | tex 16056965573 (M Grid4x4 Glowing Bezi) | col #5364FF->#2C25FF | LE0 LI0 Br10 | life 0.3-1.35 | size shrink 0.5->0.225 | tr flat 0.00 | spd 2-10 drag 2 spread -15-15 | VelocityParallel | squash const 0.1 | flip Grid4x4 OneShot 20-30 | RATE 15 (continuous) | z -1
E Rotating Star  | tex 129871600983536 | col #5364FF->#2C25FF | LE0 LI0 Br6 | life 0.3-0.6 | size shrink 0.375->0 | tr flat 0.00 | spd 3-5.5 drag 1 | FacingCamera/Sphere | flip Grid4x4 Loop 20-30 | RATE 9 (continuous)
E Diamond Spec   | tex 97491869810266 | col #5364FF | LE0 LI0 Br6 | life 2 | size const 1.8 | tr flat 0.00 | spd 0.001 | VelocityParallel | locked
T Beam81         | tex 113083314207224 (M  Beam81) | col #5364FF->#2C25FF | LE0 LI0 Br1.5 | life 0.85 width swell 0->0.265@0.54->0 | tr flat 0.10 | tex Static 20.8 spd None
T Beam105        | tex 112629787601025 (M  Beam105) | col #5364FF->#2C25FF | LE0 LI0 Br6 | life 0.6 width shrink 0.319->0 | tr 1.00..0.00 vis 0.35-0.84 ->1.00 | tex Stretch 1 spd None
T BeamDrag tendr | tex 7332661633 | col #5364FF->#2C25FF | LE0 LI0 Br4 | life 0.3 width shrink 0.25->0 | tr 0.00..0.00 vis 0.00-0.84 ->1.00 | tex Stretch 1 spd None
T Beam81         | tex 113083314207224 (M  Beam81) | col #5364FF->#2C25FF | LE0 LI0 Br1.5 | life 0.9 width swell 0->0.265@0.54->0 | tr flat 0.10 | tex Static 14 spd None
T Beam105        | tex 112629787601025 (M  Beam105) | col #5364FF->#2C25FF | LE0.5 LI0 Br6 | life 0.7 width swell 0->0.3@0.35->0 | tr 1.00..0.00 vis 0.35-0.84 ->1.00 | tex Stretch 1 spd None
T Beam81         | tex 113083314207224 (M  Beam81) | col #5364FF->#2C25FF | LE0 LI0 Br1.5 | life 0.85 width swell 0->0.265@0.54->0 | tr flat 0.10 | tex Static 14 spd None
T Beam105        | tex 112629787601025 (M  Beam105) | col #5364FF->#2C25FF | LE0 LI0 Br6 | life 0.6 width shrink 0.319->0 | tr 1.00..0.00 vis 0.35-0.84 ->1.00 | tex Stretch 1 spd None
T BeamDrag tendr | tex 7332661633 | col #5364FF->#2C25FF | LE0 LI0 Br4 | life 0.3 width shrink 0.25->0 | tr 0.00..0.00 vis 0.00-0.84 ->1.00 | tex Stretch 1 spd None
P {"k": "MeshPart", "name": "Distortion", "size": [0.001, 0.001, 0.001], "mat": "Glass", "transp": 15.0, "mesh": 11067917371}
P {"k": "Part", "name": "End", "size": [4.0, 4.0, 4.0], "mat": "DiamondPlate", "transp": 0.0}
P {"k": "Part", "name": "Spawn", "size": [4.0, 4.0, 4.0], "mat": "DiamondPlate", "transp": 0.0}
S Script Showcase len5683 flags=anim,bezier,camera,debris,delay,emit,shake,tween
S ModuleScript Bezier len17526 flags=bezier,tween
S ModuleScript ZonitoVFX len12497 flags=anim,attr,camera,colorcorr,debris,delay,emit,heartbeat,highlight,shake,tween
S ModuleScript ScreenSpace len6712 flags=camera
S ModuleScript CameraFX len2803 flags=camera,heartbeat
S ModuleScript BoatTween len13298 flags=anim,heartbeat,tween
S ModuleScript TweenFunctions len11488 flags=bezier
S ModuleScript Lerps len11907 flags=bezier
S ModuleScript Bezier len2167 flags=bezier
S ModuleScript Crater len4502 flags=anim,debris,delay,raycast,tween
S ModuleScript CameraShaker len6250 flags=camera,delay,shake
S ModuleScript CameraShakePresets len1976 flags=camera,shake
S ModuleScript CameraShakeInstance len3890 flags=camera,shake
```
