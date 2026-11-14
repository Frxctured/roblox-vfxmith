# bc7a9a1bd0d2: amine vfx 2.rbxl :: Workspace/Model

- Category: **darkportal**; tags: dark, fire, star
- Layers: 3 emitters, 0 beams, 0 trails, 1 mesh parts, 1 lights; estimated length 2.25 s
- Fired by: saved running (Enabled + Rate)
- Pack file: `Older OS (2025 and older)/November 2023/amine vfx 2.rbxl` (instance referent 2810). Watch it in Studio: `kit/scripts/rbxcut.py --id bc7a9a1bd0d2 --studio`, then `P.load("fx_bc7a9a1bd0d2")` (needs the pack: `kit/scripts/get_pack.py`)
- Frames: none captured yet (play it with kit/studio/VFXLibPlayer.luau)

## Layers (one line each, in firing order; E emitter, B beam, T trail, P part, S script)
```
E Outer          | tex 311395391 | col #0051FF | LE1 LI1 Br1 | life 1 | size shrink 0.25->0.125 | tr 0.00..0.00 vis 0.00-0.00 ->1.00 | spd 11 spread 180 acc 0-0--30 rotSpd -90-150 | FacingCamera | locked | RATE 250 (continuous) | z 3
E Inner Brighter | tex 1746829167 | col #06C9FF | LE1 LI1 Br1 | life 0.75 | size grow 0->0.1 | tr flat 0.00 | spd 10 drag 3.5 spread 180 acc 0-0--20 rotSpd 250 | FacingCamera | locked | RATE 81 (continuous) | z 1
E Dark           | tex 7032949469 | col #0A6CFF | LE0.95 LI1 Br1 | life 2.25 | size shrink 0.938->0 | tr 0.00..0.00 vis 0.00-0.48 ->1.00 | spd 2 spread 360 rotSpd -500-500 | FacingCamera | locked | RATE 300 (continuous)
P {"k": "MeshPart", "name": "MeshPart", "size": [6.03284, 5.96615, 6.03632], "mat": "Neon", "transp": 0.0, "mesh": 7075224841}
S Script Script len111 flags=delay
```
