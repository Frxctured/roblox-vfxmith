# 5abd66e17efb: amine vfx 2.rbxl :: Workspace/Model

- Category: **darkportal**; tags: fire, impact, star
- Layers: 10 emitters, 0 beams, 0 trails, 1 mesh parts, 0 lights; estimated length 1.0 s
- Fired by: saved running (Enabled + Rate)
- Pack file: `Older OS (2025 and older)/November 2023/amine vfx 2.rbxl` (instance referent 1572): cut it into Studio with `kit/scripts/rbxcut.py "<pack>/Older OS (2025 and older)/November 2023/amine vfx 2.rbxl" --ref 1572 --out <studio content>/vfxlib/fx_5abd66e17efb.rbxmx`
- Frames: none captured yet (play it with kit/studio/VFXLibPlayer.luau)

## Layers (one line each, in firing order; E emitter, B beam, T trail, P part, S script)
```
E circle2        | tex 6986730276 | col #FF7700 | LE1 LI0 Br1 | life 0.45 | size const 20 | tr 1.00..0.00 vis 0.20-0.80 ->1.00 | spd 39 spread 360 rotSpd 360 | VelocityPerpendicular | locked
E Decay3         | tex 6127709348 | col #FF5500 | LE1 LI0 Br1 | life 0.5 | size grow 0->10 | tr flat 0.00 | spd 60 drag 5 spread 0-180 rotSpd -100-100 | FacingCamera | locked | RATE 100 (continuous) | z 1
E Decay2         | tex 6127709348 | col #FF6721 | LE1 LI0 Br1 | life 0.5 | size grow 0->10 | tr flat 0.00 | spd 60 drag 5 spread 0-180 rotSpd -100-100 | FacingCamera | locked | RATE 100 (continuous) | z 1
E Decay1         | tex 6127709348 | col #FF5500 | LE1 LI0 Br1 | life 0.5 | size grow 0->10 | tr flat 0.00 | spd 60 drag 5 spread 0-180 rotSpd -100-100 | FacingCamera | locked | RATE 100 (continuous) | z 1
E ParticleEmitte | tex 867619398 (M  Glow) | col #FF2D08->#FF0000 | LE1 LI0 Br1 | life 0.5 | size shrink 7.07->0 | tr flat 0.50 | spd 200 | FacingCamera | RATE 200 (continuous)
E ParticleEmitte | tex 296874871 (A  1) | col #FF2D08->#FF0000 | LE1 LI0 Br1 | life 0.5 | size shrink 6.44->0 | tr flat 0.00 | spd 200 | FacingCamera | RATE 200 (continuous) | z 3
E FFGrass        | col #AAFF7F | LE0 LI0 Br1 | life 1 | size grow 0->10 | tr 0.34..0.34 vis 0.00-0.00 ->1.00 | spd 60 drag 2 spread 0-2e+04 | FacingCamera
E Rocks          | tex 626588936 (D  Rocks) | col #FFFFFF | LE0 LI1 Br1 | life 0.4-0.8 | size shrink 0.585->0 | tr flat 0.00 | spd 70-250 drag 6 spread 40 | FacingCamera | z 5
E FF             | tex 867619398 (M  Glow) | col #FF2D08->#FF0000 | LE0.6 LI0 Br1 | life 0.5 | size swell 0->4.47@0.38->0.745 | tr 0.34..0.34 vis 0.00-0.00 ->1.00 | spd 60 drag 2 spread 0-2e+04 | FacingCamera | RATE 200 (continuous) | z 2
E ParticleEmitte | tex 296874871 (A  1) | col #FF5E14->#FF0004 | LE0.9 LI0 Br1 | life 0.2-0.5 | size shrink 4.36->0 | tr 1.00..0.00 vis 0.39-0.63 ->1.00 | spd 100 | FacingCamera | RATE 200 (continuous) | z 4
P {"k": "Part", "name": "Rock", "size": [2.0, 2.0, 2.0], "mat": "Slate", "transp": 0.0}
P {"k": "Part", "name": "Rock", "size": [2.0, 2.0, 2.0], "mat": "Slate", "transp": 0.0}
P {"k": "Part", "name": "Rock", "size": [3.5, 3.5, 3.5], "mat": "Slate", "transp": 0.0}
P {"k": "Part", "name": "Rock", "size": [5.0, 5.0, 5.0], "mat": "Slate", "transp": 0.0}
P {"k": "Part", "name": "Rock", "size": [3.5, 3.5, 3.5], "mat": "Slate", "transp": 0.0}
P {"k": "Part", "name": "Rock", "size": [2.0, 2.0, 2.0], "mat": "Slate", "transp": 0.0}
P {"k": "Part", "name": "Rock", "size": [2.0, 2.0, 2.0], "mat": "Slate", "transp": 0.0}
P {"k": "Part", "name": "Rock", "size": [5.0, 5.0, 5.0], "mat": "Slate", "transp": 0.0}
P {"k": "Part", "name": "Rock", "size": [3.5, 3.5, 3.5], "mat": "Slate", "transp": 0.0}
P {"k": "Part", "name": "Rock", "size": [2.0, 2.0, 2.0], "mat": "Slate", "transp": 0.0}
P {"k": "Part", "name": "Rock", "size": [3.5, 3.5, 3.5], "mat": "Slate", "transp": 0.0}
P {"k": "Part", "name": "Rock", "size": [5.0, 5.0, 5.0], "mat": "Slate", "transp": 0.0}
P {"k": "Part", "name": "Rock", "size": [5.0, 5.0, 5.0], "mat": "Slate", "transp": 0.0}
P {"k": "Part", "name": "Rock", "size": [3.5, 3.5, 3.5], "mat": "Slate", "transp": 0.0}
P {"k": "Part", "name": "Rock", "size": [2.0, 2.0, 2.0], "mat": "Slate", "transp": 0.0}
P {"k": "Part", "name": "Rock", "size": [2.0, 2.0, 2.0], "mat": "Slate", "transp": 0.0}
P {"k": "Part", "name": "Rock", "size": [3.5, 3.5, 3.5], "mat": "Slate", "transp": 0.0}
P {"k": "Part", "name": "Rock", "size": [5.0, 5.0, 5.0], "mat": "Slate", "transp": 0.0}
P {"k": "Part", "name": "Rock", "size": [5.0, 5.0, 5.0], "mat": "Slate", "transp": 0.0}
P {"k": "Part", "name": "Rock", "size": [2.0, 2.0, 2.0], "mat": "Slate", "transp": 0.0}
```
