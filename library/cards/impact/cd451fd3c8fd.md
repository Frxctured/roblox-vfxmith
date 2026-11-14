# cd451fd3c8fd: Lightning.rbxm :: Lightning Thing

- Category: **impact**; tags: impact, lightning, shockwave, smoke
- Layers: 12 emitters, 0 beams, 0 trails, 0 mesh parts, 0 lights; estimated length 2.0 s
- Fired by: EmitCount attributes
- Pack file: `Older OS (2025 and older)/Oct 2024 - Jan 2025/Lightning.rbxm` (instance referent 0). Watch it in Studio: `kit/scripts/rbxcut.py --id cd451fd3c8fd --studio`, then `P.load("fx_cd451fd3c8fd")` (needs the pack: `kit/scripts/get_pack.py`)
- Frames: none captured yet (play it with kit/studio/VFXLibPlayer.luau)

## Layers (one line each, in firing order; E emitter, B beam, T trail, P part, S script)
```
E Specs          | tex 88904784684287 | col #A1AAFF | LE1 LI0 Br15 | life 0.1-2 | size swell 0.437->0.954@0.39->0 | tr flat 0.00 | spd 45-160 drag 15 spread 100--100 acc 0--20-0 rotSpd -150-150 | FacingCamera | EMIT 75 @0
E Shockwave      | tex 98956404387215 | col #817DFF | LE1 LI0 Br15 | life 0.1-1 | size grow 0->19.9 | tr flat 0.00 | spd 0.0201 spread 15--15 rotSpd -50-50 | VelocityPerpendicular | flip Grid4x4 OneShot 1 | EMIT 3 @0
E Line           | tex 112193382181313 | col #667DFF | LE0 LI0 Br15 | life 0.15 | size shrink 50.4->0 | tr 1.00..0.00 vis 0.52-0.52 ->1.00 | spd 0.01 | FacingCameraWorldUp | squash grow 0->2.87 | flip Grid4x4 OneShot 1 | EMIT 1 @0
E Shockwave      | tex 102063172782166 | col #999999 | LE1 LI0 Br3 | life 0.1-1 | size grow 0->22.9 | tr 1.00..0.92 vis 0.43-0.43 ->1.00 | spd 0.0201 spread 15--15 rotSpd -50-50 | VelocityPerpendicular | EMIT 5 @0
E Shockwave      | tex 102506323802085 | col #999999 | LE1 LI0 Br3 | life 0.1-1 | size grow 0->15 | tr 1.00..0.67 vis 0.40-0.40 ->1.00 | spd 0.0132 spread 15--15 rotSpd -50-50 | VelocityPerpendicular | EMIT 15 @0
E Lightning      | tex 134727453410277 | col #7070FF | LE1 LI0 Br15 | life 0.1-0.2 | size grow 0->15 | tr flat 0.00 | spd 35-90 drag 5 spread 100--100 | FacingCamera | squash const 0.15 | flip Grid4x4 OneShot 1 | EMIT 5 @0
E Air Wave       | tex 90308712766170 | col #FFFFFF | LE1 LI0 Br15 | life 0.1-1 | size const 5 | tr 1.00..0.98 vis 0.41-0.41 ->1.00 | spd 70-85 drag 15 spread 5-200 | VelocityPerpendicular | squash const 1 | flip Grid4x4 OneShot 1 | EMIT 110 @0
E Air Wave       | tex 89549145262314 | col #FFFFFF | LE1 LI0 Br15 | life 0.1-1 | size const 5 | tr 1.00..0.98 vis 0.41-0.41 ->1.00 | spd 70-85 drag 15 spread 5-200 | VelocityPerpendicular | flip Grid4x4 OneShot 1 | EMIT 110 @0
E Smoke Dust     | tex 93664055593757 | col #6C654E | LE0.25 LI0 Br2 | life 0.1-1 | size const 2.65 | tr 1.00..0.51 vis 0.42-0.42 ->1.00 | spd 86-145 drag 15 spread 15-500 rotSpd -15-15 | FacingCamera | EMIT 65 @0
E Smoke Dust     | tex 97915851442680 | col #6C654E | LE0.25 LI0 Br2 | life 0.1-1 | size const 2.65 | tr 1.00..0.51 vis 0.42-0.42 ->1.00 | spd 86-145 drag 15 spread 15-500 rotSpd -15-15 | FacingCamera | EMIT 65 @0
E Dust Wave      | tex 103720348370302 | col #83755C | LE0 LI0.15 Br5 | life 0.1-1 | size grow 0->23.1 | tr 0.75..0.75 vis 0.00-0.00 ->1.00 | spd 0.0231-2.31 spread 15--15 | VelocityPerpendicular | EMIT 15 @0
E Dust Wave      | tex 86965530099016 | col #AA9374 | LE0 LI1 Br1 | life 0.1-0.95 | size grow 0->23.1 | tr 0.75..0.75 vis 0.00-0.00 ->1.00 | spd 0.0231-2.31 spread 15--15 | VelocityPerpendicular | EMIT 15 @0
P {"k": "Part", "name": "Lightning Thing", "size": [5.0, 0.15, 5.0], "mat": "Plastic", "transp": 0.75}
```
