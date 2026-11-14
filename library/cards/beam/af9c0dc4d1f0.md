# af9c0dc4d1f0: Star or Constellation Trail Effect.rbxm :: Star_Trail

- Category: **beam**; tags: beam, star
- Layers: 3 emitters, 1 beams, 0 trails, 0 mesh parts, 0 lights; estimated length 0.1 s
- Fired by: saved running (Enabled + Rate)
- Pack file: `190 OS (Oct 2024-Mar 2026)/Star or Constellation Trail Effect.rbxm` (instance referent 0). Watch it in Studio: `kit/scripts/rbxcut.py --id af9c0dc4d1f0 --studio`, then `P.load("fx_af9c0dc4d1f0")` (needs the pack: `kit/scripts/get_pack.py`)
- Frames: none captured yet (play it with kit/studio/VFXLibPlayer.luau)

## Layers (one line each, in firing order; E emitter, B beam, T trail, P part, S script)
```
E Star           | tex 17158574681 | col #FFFFFF | LE0 LI0 Br2.5 | life 0.1 | size const 0.5 | tr flat 0.00 | spd 0 | FacingCamera | locked | RATE 20 (continuous)
E Glint          | tex 18480744544 | col #FFF893 | LE1 LI0 Br1 | life 0.1 | size const 0.2 | tr flat 0.00 | spd 0 | FacingCamera | locked | RATE 20 (continuous) | z 1
E Glint          | tex 18480744544 | col #FFF893 | LE1 LI0 Br1 | life 0.1 | size const 0.2 | tr flat 0.00 | spd 0 | FacingCamera | locked | RATE 20 (continuous) | z 1
B Starbeam       | tex 12781750620 (M  Trail2) | col #FFFFFF | LE0 LI0 Br35 | w 0.075-0.075 curve 0-0 seg 100 face | tr 1.00..0.50 vis 0.10-0.90 ->1.00 | tex Stretch 1 spd 1
P {"k": "Part", "name": "Part", "size": [1.0, 1.0, 1.0], "mat": "Neon", "transp": 0.0}
P {"k": "Part", "name": "Star", "size": [0.1, 0.1, 0.1], "mat": "Neon", "transp": 0.0}
P {"k": "Part", "name": "Orbiter", "size": [0.25, 0.25, 0.25], "mat": "Neon", "transp": 0.0}
S Script Example  len1022 flags=
S ModuleScript OrbitModule len6498 flags=delay,heartbeat
S ModuleScript Star_Trail len6401 flags=anim,camera,debris,delay,heartbeat,tween
```
