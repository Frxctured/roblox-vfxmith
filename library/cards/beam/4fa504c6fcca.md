# 4fa504c6fcca: amine vfx 2.rbxl :: Workspace/Buso

- Category: **beam**; tags: beam, fire, star
- Layers: 3 emitters, 5 beams, 0 trails, 1 mesh parts, 1 lights; estimated length 1.0 s
- Fired by: saved running (Enabled + Rate)
- Pack file: `Older OS (2025 and older)/November 2023/amine vfx 2.rbxl` (instance referent 4242). Watch it in Studio: `kit/scripts/rbxcut.py --id 4fa504c6fcca --studio`, then `P.load("fx_4fa504c6fcca")` (needs the pack: `kit/scripts/get_pack.py`)
- Frames: none captured yet (play it with kit/studio/VFXLibPlayer.luau)

## Layers (one line each, in firing order; E emitter, B beam, T trail, P part, S script)
```
E ParticleEmitte | tex 6706234595 | col #7F0FFF | LE1 LI0 Br1 | life 1 | size swell 0.34->0.809@0.68->0.511 | tr flat 0.85 | spd 4 | FacingCamera | locked | RATE 8 (continuous) | z 0.02
E ParticleEmitte | tex 6706234595 | col #000000 | LE0 LI1 Br1 | life 1 | size swell 0->0.298@0.67->0 | tr flat 0.50 | spd 4 spread 7.5 | FacingCamera | locked | RATE 20 (continuous) | z 0.02
E ParticleEmitte | tex 1771082037 | col #FFFFFF | LE0 LI0 Br1 | life 1 | size grow 0->0.511 | tr 1.00..0.50 vis 0.20-0.80 ->1.00 | spd 4 spread 5 | FacingCamera | locked | RATE 20 (continuous) | z 0.02
B Beam           | tex 1135136643 | col #000000 | LE0 LI0 Br1 | w 0.5-1.5 curve 0-0 seg 10 face | tr 1.00..0.00 vis 0.20-0.80 ->1.00 | tex Stretch 0.5 spd 0.4 | z 0.3
B Beam           | tex 3517446796 (A  Beam) | col #6600FF | LE0.55 LI0 Br1 | w 1-2.5 curve 0-0 seg 10 face | tr 1.00..0.50 vis 0.20-0.80 ->1.00 | tex Stretch 0.5 spd 0.3 | z 0.301
B Beam           | tex 1771082037 | col #000000 | LE0 LI0 Br1 | w 0.75-1.25 curve 0-0 seg 10 face | tr 1.00..0.00 vis 0.20-0.80 ->1.00 | tex Stretch 0.75 spd 0.4 | z 0.299
B Beam           | tex 1771082037 | col #000000 | LE0 LI0 Br1 | w 0.5-1 curve 0-0 seg 10 face | tr 1.00..0.00 vis 0.20-0.80 ->1.00 | tex Stretch 0.1 spd 0.1 | z 0.299
B Beam           | tex 1135136643 | col #6600FF | LE0.4 LI0 Br1 | w 0.65-1.75 curve 0-0 seg 10 face | tr 1.00..0.75 vis 0.20-0.80 ->1.00 | tex Stretch 0.5 spd 0.4 | z 0.299
P {"k": "MeshPart", "name": "MeshPart", "size": [0.58007, 0.40554, 5.42873], "mat": "Glass", "transp": 0.0, "mesh": 11442510}
```
