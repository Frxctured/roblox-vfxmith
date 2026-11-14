# 9fc0da8f8cff: ANINE FX.rbxl :: Workspace/Meshes/icespear2 (1)

- Category: **slash**; tags: fire, ice, star
- Layers: 2 emitters, 0 beams, 3 trails, 1 mesh parts, 0 lights; estimated length 0.25 s
- Fired by: saved running (Enabled + Rate)
- Pack file: `Older OS (2025 and older)/November 2023/ANINE FX.rbxl` (instance referent 58498). Watch it in Studio: `kit/scripts/rbxcut.py --id 9fc0da8f8cff --studio`, then `P.load("fx_9fc0da8f8cff")` (needs the pack: `kit/scripts/get_pack.py`)
- Frames: none captured yet (play it with kit/studio/VFXLibPlayer.luau)

## Layers (one line each, in firing order; E emitter, B beam, T trail, P part, S script)
```
E ParticleEmitte | tex 5894390870 | col #AAFFFF | LE0.6 LI0 BrNone | life 0.25 | size grow 0->5.37 | tr 0.98..0.98 vis 0.00-1.00 ->1.00 | spd 10 spread -100-100 acc 0--10-0 | FacingCamera | locked | RATE 200 (continuous) | z -0.3
E ParticleEmitte | tex 5894390870 | col #AAFFFF | LE0.6 LI0 BrNone | life 0.25 | size grow 0->9.07 | tr 0.97..0.97 vis 0.00-0.00 ->1.00 | spd 10 spread -100-100 acc 0--10-0 | FacingCamera | locked | RATE 200 (continuous) | z -0.3
T Trail          | tex 5894390870 | col #AAFFFF | LE1 LI1 BrNone | life 1 width const 10 | tr flat 0.50 | tex Stretch 0.125 spd None
T Trail          | tex 5894390870 | col #AAFFFF | LE1 LI1 BrNone | life 1 width const 10 | tr flat 0.50 | tex Stretch 0.75 spd None
T Trail          | tex 5894390870 | col #AAFFFF | LE1 LI1 BrNone | life 1 width const 10 | tr flat 0.50 | tex Stretch 0.5 spd None
P {"k": "MeshPart", "name": "Meshes/icespear2 (1)", "size": [2.02144, 0.37365, 10.99107], "mat": "Glass", "transp": 0.0, "mesh": 5901655828}
```
