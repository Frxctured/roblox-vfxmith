# 2bb2acc6c33a: VFX__trash_fireball_1_month_and_1_week_progression.rbxl :: Workspace/Finished VFX/VFX/Bullet

- Category: **projectile**; tags: fire, projectile, star
- Layers: 5 emitters, 0 beams, 5 trails, 0 mesh parts, 0 lights; estimated length 10.0 s
- Fired by: saved running (Enabled + Rate)
- Pack file: `Older OS (2025 and older)/November 2023/VFX__trash_fireball_1_month_and_1_week_progression.rbxl` (instance referent 1029). Watch it in Studio: `kit/scripts/rbxcut.py --id 2bb2acc6c33a --studio`, then `P.load("fx_2bb2acc6c33a")` (needs the pack: `kit/scripts/get_pack.py`)
- Frames: none captured yet (play it with kit/studio/VFXLibPlayer.luau)

## Layers (one line each, in firing order; E emitter, B beam, T trail, P part, S script)
```
E ParticleEmitte | tex 14287907110 | col #7A3CFF | LE1 LI1 Br1 | life 0.01-10 | size shrink 0.55->0 | tr 1.00..0.69 vis 1.00-1.00 ->0.69 | spd 0.001 | FacingCamera | locked | RATE 50 (continuous)
E Revolting      | tex 14287915612 | col #FF575A->#6A38FF->#FF575A | LE1 LI1 Br1 | life 0.1-5 | size const 0.65 | tr flat 0.00 | spd 0.001 spread 360--360 rotSpd 150 | VelocityPerpendicular | locked | RATE 3 (continuous)
E Flare          | tex 14287888652 | col #FF2226 | LE0 LI0 Br50 | life 0.1-5 | size grow 0->0.46 | tr flat 0.00 | spd 0.001 | FacingCamera | locked | RATE 2 (continuous)
E Circle         | tex 14287860548 | col #FF2226->#0000FF->#FF2226 | LE0 LI0 Br9 | life 0.1-5 | size const 0.52 | tr 1.00..0.36 vis 1.00-1.00 ->0.36 | spd 0.001 rotSpd 1e+03 | FacingCamera | locked | RATE 3 (continuous)
E Twirl          | tex 14287508768 | col #FF2327->#405DFF->#FF2327 | LE1 LI0 Br1 | life 0.1-5 | size const 0.5 | tr flat 0.00 | spd 0.001 rotSpd 999 | FacingCamera | locked | RATE 1 (continuous)
T Trail          | tex 14288031114 | col #FF2C30 | LE1 LI0 Br15 | life 2 width const 2 | tr flat 0.50 | tex Stretch 1 spd None
T Trail          | tex 14288031114 | col #FF2C30 | LE1 LI0 Br15 | life 2 width const 2 | tr flat 0.50 | tex Stretch 1 spd None
T Trail          | tex 14288031114 | col #FF2C30 | LE1 LI0 Br15 | life 2 width const 2 | tr flat 0.50 | tex Stretch 1 spd None
T Trail          | tex 14288031114 | col #FF2C30 | LE1 LI0 Br15 | life 2 width const 2 | tr flat 0.50 | tex Stretch 1 spd None
T Trail          | tex 14288031114 | col #FF2C30 | LE1 LI0 Br15 | life 2 width const 2 | tr flat 0.50 | tex Stretch 1 spd None
P {"k": "Part", "name": "Bullet", "size": [4.0, 0.5, 4.0], "mat": "Neon", "transp": 0.9}
```
