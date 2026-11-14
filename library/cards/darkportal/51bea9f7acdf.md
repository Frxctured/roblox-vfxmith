# 51bea9f7acdf: Testing_ServerNote_in_desc.rbxl :: ServerStorage/DarkMatterHelper

- Category: **darkportal**; tags: dark
- Layers: 6 emitters, 0 beams, 0 trails, 19 mesh parts, 0 lights; estimated length 5.0 s
- Fired by: its own scripts (not included in the card)
- Pack file: `Older OS (2025 and older)/important (cool) rbx (Nov 2023)/Testing_ServerNote_in_desc.rbxl` (instance referent 53653). Watch it in Studio: `kit/scripts/rbxcut.py --id 51bea9f7acdf --studio`, then `P.load("fx_51bea9f7acdf")` (needs the pack: `kit/scripts/get_pack.py`)
- Frames: none captured yet (play it with kit/studio/VFXLibPlayer.luau)

## Layers (one line each, in firing order; E emitter, B beam, T trail, P part, S script)
```
E ParticleEmitte | tex 2560926882 | col #FF0004->#000000 | LE0 LI0 Br1 | life 5 | size swell 0.24->0.719@0.23->0 | tr 1.00..0.00 vis 0.10-0.80 ->1.00 | spd 0 spread -25-25 rotSpd -50-50 | FacingCamera | RATE 10 (continuous) | z -1
E ParticleEmitte | tex 2560926882 | col #FF0004->#000000 | LE0 LI0 Br1 | life 5 | size swell 0.24->0.539@0.21->0 | tr 1.00..0.00 vis 0.10-0.80 ->1.00 | spd 2 spread -25-25 rotSpd -50-50 | FacingCamera | RATE 10 (continuous) | z -1
E ParticleEmitte | tex 2560926882 | col #FF0004->#000000 | LE0 LI0 Br1 | life 5 | size swell 0.24->0.719@0.23->0 | tr 1.00..0.00 vis 0.10-0.80 ->1.00 | spd 0 spread -25-25 rotSpd -50-50 | FacingCamera | RATE 10 (continuous) | z -1
E ParticleEmitte | tex 2022258128 | col #FF6262 | LE0.5 LI1 Br1 | life 1 | size const 7 | tr 0.50..0.50 vis 0.00-0.80 ->1.00 | spd 3 spread 10 | FacingCamera | z -2
E ParticleEmitte | tex 2022258128 | col #FF4A4A | LE2 LI1 Br1 | life 1 | size const 1 | tr 0.00..0.00 vis 0.00-0.80 ->1.00 | spd 10 spread -360-360 rotSpd 360 | FacingCamera
E ParticleEmitte | tex 2022258128 | col #FF6262 | LE1 LI1 Br1 | life 1 | size const 3 | tr 0.60..0.60 vis 0.00-0.80 ->1.00 | spd 3 spread 10 | FacingCamera
P {"k": "Part", "name": "Head", "size": [1.0, 1.0, 1.0], "mat": "Plastic", "transp": 0.0}
P {"k": "SpecialMesh", "name": "Mesh", "mesh": 419776358, "meshTex": null, "scale": [1.0, 1.0, 1.0]}
P {"k": "MeshPart", "name": "Bullet", "size": [0.3, 0.6, 0.3], "mat": "Neon", "transp": 0.5, "mesh": 684477185}
P {"k": "MeshPart", "name": "Bullet", "size": [0.25, 0.5, 0.25], "mat": "Neon", "transp": 0.0, "mesh": 684477185}
P {"k": "MeshPart", "name": "Bullet", "size": [0.3, 0.6, 0.3], "mat": "Neon", "transp": 0.5, "mesh": 684477185}
P {"k": "MeshPart", "name": "Bullet", "size": [0.25, 0.5, 0.25], "mat": "Neon", "transp": 0.0, "mesh": 684477185}
P {"k": "MeshPart", "name": "SpecialHead", "size": [1.31, 1.278, 1.238], "mat": "Neon", "transp": 0.0, "mesh": 539723444}
P {"k": "MeshPart", "name": "LeftHand", "size": [0.9993, 0.33526, 1.0003], "mat": "Neon", "transp": 0.0, "mesh": 467982655}
P {"k": "MeshPart", "name": "LeftLowerArm", "size": [1.00028, 1.26567, 1.00025], "mat": "Neon", "transp": 0.0, "mesh": 467982658}
P {"k": "MeshPart", "name": "LeftLowerLeg", "size": [1.00028, 1.48965, 1.00033], "mat": "Neon", "transp": 0.0, "mesh": 467982675}
P {"k": "MeshPart", "name": "LeftUpperArm", "size": [1.00028, 1.39554, 1.00025], "mat": "Neon", "transp": 0.0, "mesh": 467982661}
P {"k": "MeshPart", "name": "LeftUpperLeg", "size": [1.00028, 1.53626, 1.00093], "mat": "Neon", "transp": 0.0, "mesh": 467982678}
P {"k": "MeshPart", "name": "LowerTorso", "size": [2.00018, 0.40004, 1.00021], "mat": "Neon", "transp": 0.0, "mesh": 467982692}
P {"k": "MeshPart", "name": "LeftFoot", "size": [1.00063, 0.33541, 1.0002], "mat": "Neon", "transp": 0.0, "mesh": 467982673}
P {"k": "MeshPart", "name": "RightFoot", "size": [1.00063, 0.33541, 1.0002], "mat": "Neon", "transp": 0.0, "mesh": 467982681}
P {"k": "MeshPart", "name": "RightHand", "size": [0.9993, 0.33526, 1.0003], "mat": "Neon", "transp": 0.0, "mesh": 467982662}
P {"k": "MeshPart", "name": "RightLowerArm", "size": [1.00028, 1.26567, 1.00025], "mat": "Neon", "transp": 0.0, "mesh": 467982664}
P {"k": "MeshPart", "name": "RightLowerLeg", "size": [1.00028, 1.48965, 1.00033], "mat": "Neon", "transp": 0.0, "mesh": 467982684}
P {"k": "MeshPart", "name": "RightUpperArm", "size": [1.00028, 1.39554, 1.00025], "mat": "Neon", "transp": 0.0, "mesh": 467982669}
P {"k": "MeshPart", "name": "RightUpperLeg", "size": [1.00028, 1.53626, 1.00093], "mat": "Neon", "transp": 0.0, "mesh": 467982686}
S Script Animate len14082 flags=anim,delay
S Script Script len17650 flags=anim,debris,delay,tween
S Script Script len1450 flags=
```
