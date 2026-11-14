# 5ffb85f8d7da: amine vfx 2.rbxl :: Workspace/Slash Genshin Pack

- Category: **slash**; tags: fire, shockwave, slash, star
- Layers: 7 emitters, 0 beams, 0 trails, 0 mesh parts, 0 lights; estimated length 0.5 s
- Fired by: EmitCount attributes
- Pack file: `Older OS (2025 and older)/November 2023/amine vfx 2.rbxl` (instance referent 6001). Watch it in Studio: `kit/scripts/rbxcut.py --id 5ffb85f8d7da --studio`, then `P.load("fx_5ffb85f8d7da")` (needs the pack: `kit/scripts/get_pack.py`)
- Frames: none captured yet (play it with kit/studio/VFXLibPlayer.luau)

## Layers (one line each, in firing order; E emitter, B beam, T trail, P part, S script)
```
E half circle    | tex 7368928330 | col #FFFFFF | LE1 LI0 Br1 | life 0.3 | size shrink 5.12->0 | tr 0.50..0.00 vis 0.55-0.55 ->1.00 | spd 0.1 spread 2.56e+03 | VelocityPerpendicular | locked | EMIT 2 @0 | z 2.5
E Specs          | tex 6839837500 | col #FFFFFF | LE1 LI0 Br1 | life 0.1-0.35 | size swell 0->1.25@0.50->0 | tr flat 0.00 | spd 10-45 drag 5.62 spread 360 acc 0--22-0 | VelocityParallel | EMIT 2 @0 | z 3
E Flare          | tex 7553257107 | col #AAAAAA | LE1 LI0 Br1 | life 0.5 | size grow 0->10 | tr 0.50..0.38 vis 0.50-0.50 ->1.00 | spd 0 drag 5 | FacingCamera | locked | EMIT 2 @0 | z 4
E half circle    | tex 7552993102 | col #FFFFFF | LE1 LI0 Br1 | life 0.5 | size grow 0->7.12 | tr 0.50..0.00 vis 0.55-0.55 ->1.00 | spd 0.1 spread 2.56e+03 | VelocityPerpendicular | locked | EMIT 2 @0 | z 2.5
E HeavySlash     | tex 494046218 | col #FFFFFF | LE1 LI0 Br1 | life 0.4 | size swell 0->4.69@0.51->0.109 | tr 0.00..0.00 vis 0.00-0.50 ->1.00 | spd 0 spread -360-360 | FacingCamera | locked | EMIT 2 @0 | z 4
E Wave           | tex 7363737733 | col #FFFFFF | LE1 LI0 Br1 | life 0.5 | size grow 0->10 | tr 0.50..0.00 vis 0.55-0.55 ->1.00 | spd 0 | FacingCamera | locked | EMIT 2 @0 | z 2.5
E Specs          | tex 7450825347 | col #FFFFFF | LE1 LI0 Br1 | life 0.2-0.275 | size shrink 2.5->0 | tr flat 0.00 | spd 20-50 drag 5.62 spread 360 acc 0--22-0 | VelocityParallel | EMIT 2 @0 | z 3
P {"k": "Part", "name": "Right Leg", "size": [1.0, 2.0, 1.0], "mat": "Plastic", "transp": 0.0}
P {"k": "Part", "name": "Torso", "size": [2.0, 2.0, 1.0], "mat": "Plastic", "transp": 0.0}
P {"k": "Part", "name": "Left Leg", "size": [1.0, 2.0, 1.0], "mat": "Plastic", "transp": 0.0}
P {"k": "Part", "name": "Right Arm", "size": [1.0, 2.0, 1.0], "mat": "Plastic", "transp": 0.0}
P {"k": "Part", "name": "Left Arm", "size": [1.0, 2.0, 1.0], "mat": "Plastic", "transp": 0.0}
P {"k": "Part", "name": "Head", "size": [1.25, 1.0, 1.0], "mat": "Plastic", "transp": 0.0}
S Script Emit len91 flags=delay,emit
S Script Emit len91 flags=delay,emit
```
