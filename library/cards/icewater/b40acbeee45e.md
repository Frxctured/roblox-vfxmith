# b40acbeee45e: 1ss_island.rbxl :: Workspace/Model

- Category: **icewater**; tags: star, water
- Layers: 2 emitters, 2 beams, 0 trails, 0 mesh parts, 0 lights; estimated length 0.85 s
- Fired by: saved running (Enabled + Rate)
- Pack file: `2026 OS Mar-April/1ss_island.rbxl` (instance referent 3). Watch it in Studio: `kit/scripts/rbxcut.py --id b40acbeee45e --studio`, then `P.load("fx_b40acbeee45e")` (needs the pack: `kit/scripts/get_pack.py`)
- Frames: none captured yet (play it with kit/studio/VFXLibPlayer.luau)

## Layers (one line each, in firing order; E emitter, B beam, T trail, P part, S script)
```
E Puddle1        | tex 9769231431 | col #FFFFFF | LE0 LI1 Br1 | life 0.55-0.85 | size swell 0->6@0.25->0 | tr flat 0.00 | spd 15-25 drag 3 spread -45-45 acc 0--15-0 | FacingCamera | RATE 500 (continuous) | z 2
E Puddle         | tex 9769254703 | col #FFFFFF | LE0 LI1 Br1 | life 0.5-0.8 | size swell 0->2.15@0.10->0 | tr flat 0.00 | spd 3-5 | FacingCamera | RATE 500 (continuous) | z 2
B Main           | tex 9876331273 | col #6C698F | LE0 LI0 Br5 | w 50-50 curve 10-10 seg 10 | tr flat 0.00 | tex Stretch 0.15 spd 0.3 | z -0.5
B WaterFoam      | tex 4787437624 | col #FFFFFF | LE0 LI1 Br1 | w 50-70 curve 0-0 seg 20 | tr 1.00..0.02 vis 0.05-0.41 ->1.00 | tex Wrap 128 spd 0.2
P {"k": "UnionOperation", "name": "Union", "size": [7.44703, 7.44701, 45.17319], "mat": "Wood", "transp": 0.0}
P {"k": "Part", "name": "Part", "size": [1.39999, 111.3, 1.3], "mat": 528, "transp": 0.0}
P {"k": "Part", "name": "Part", "size": [1.39999, 111.3, 1.3], "mat": 528, "transp": 0.0}
P {"k": "Part", "name": "Part", "size": [1.39999, 111.3, 1.3], "mat": 528, "transp": 0.0}
P {"k": "Part", "name": "Part", "size": [1.39999, 111.3, 1.3], "mat": 528, "transp": 0.0}
P {"k": "Part", "name": "Part", "size": [1.39999, 111.3, 1.3], "mat": 528, "transp": 0.0}
P {"k": "Part", "name": "Part", "size": [1.39999, 111.3, 1.3], "mat": 528, "transp": 0.0}
P {"k": "Part", "name": "Part", "size": [1.39999, 111.3, 1.3], "mat": 528, "transp": 0.0}
P {"k": "Part", "name": "Part", "size": [1.39999, 111.3, 1.3], "mat": 528, "transp": 0.0}
P {"k": "Part", "name": "Part", "size": [1.39999, 111.3, 1.3], "mat": 528, "transp": 0.0}
P {"k": "Part", "name": "Part", "size": [1.39999, 111.3, 1.3], "mat": 528, "transp": 0.0}
P {"k": "Part", "name": "Part", "size": [1.39999, 111.3, 1.3], "mat": 528, "transp": 0.0}
P {"k": "Part", "name": "Part", "size": [1.39999, 111.3, 1.3], "mat": 528, "transp": 0.0}
P {"k": "Part", "name": "Part", "size": [81.6, 1.0, 12.5], "mat": 528, "transp": 0.0}
P {"k": "Part", "name": "Part", "size": [81.6, 1.0, 12.5], "mat": 528, "transp": 0.0}
P {"k": "Part", "name": "Part", "size": [81.6, 1.0, 12.5], "mat": 528, "transp": 0.0}
P {"k": "Part", "name": "Part", "size": [21.6, 1.0, 106.0], "mat": 528, "transp": 0.0}
P {"k": "Part", "name": "Part", "size": [5.53148, 8.34646, 38.8988], "mat": "Sand", "transp": 0.0}
P {"k": "Part", "name": "Part", "size": [4.03148, 9.94646, 38.8988], "mat": "Sand", "transp": 0.0}
P {"k": "Part", "name": "Part", "size": [2.83148, 11.84646, 38.8988], "mat": "Sand", "transp": 0.0}
```
