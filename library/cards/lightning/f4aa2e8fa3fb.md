# f4aa2e8fa3fb: PortalOpenSource.rbxm :: Portal

- Category: **lightning**; tags: lightning, portal, smoke, star
- Layers: 18 emitters, 0 beams, 0 trails, 0 mesh parts, 0 lights; estimated length 3.6 s
- Fired by: EmitCount attributes
- Pack file: `Older OS (2025 and older)/Oct 2024 - Jan 2025/PortalOpenSource.rbxm` (instance referent 0). Watch it in Studio: `kit/scripts/rbxcut.py --id f4aa2e8fa3fb --studio`, then `P.load("fx_f4aa2e8fa3fb")` (needs the pack: `kit/scripts/get_pack.py`)
- Frames: none captured yet (play it with kit/studio/VFXLibPlayer.luau)

## Layers (one line each, in firing order; E emitter, B beam, T trail, P part, S script)
```
E Spcs3          | tex 84026052578030 | col #1100FF->#4C58FF->#0000FF | LE1 LI0 Br10 | life 0.5-1 | size const 7.33 | tr 0.00..0.00 vis 0.00-0.00 ->1.00 | spd 0.366-25.7 drag 5 acc 0-55-0 | FacingCamera | RATE 25 (continuous)
E Spcs1          | tex 84026052578030 | col #1100FF->#4C58FF->#0000FF | LE1 LI0 Br10 | life 0.5-1 | size const 1.83 | tr 0.00..0.00 vis 0.00-0.82 ->1.00 | spd 18.3-55 drag 5 spread 500--500 acc 0-55-0 | FacingCamera | RATE 100 (continuous)
E Spcs2          | tex 84026052578030 | col #7C7CFF | LE1 LI0 Br10 | life 0.5-1 | size const 1.83 | tr 0.00..0.00 vis 0.00-0.82 ->1.00 | spd 18.3-55 drag 5 spread 500--500 acc 0-55-0 | FacingCamera | RATE 100 (continuous)
E EffectSpecs3   | tex 114161130081399 | col #000DFF->#4C58FF->#000DFF | LE1 LI0 Br10 | life 1 | size const 9.16 | tr flat 0.00 | spd 1.83 spread 20 | FacingCameraWorldUp/Disc | flip Grid4x4 OneShot 53 | locked | EMIT 12 @0 | z 2
E EffectSpecs1   | tex 127087582325428 | col #000DFF->#4C58FF->#000DFF | LE1 LI0 Br25 | life 1 | size const 9.16 | tr flat 0.00 | spd 0.00366 | FacingCameraWorldUp/Disc | flip Grid4x4 OneShot 53 | locked | EMIT 12 @0 | z 2
E Smoke          | tex 133229746174698 | col #1100FF->#1808FF->#0000FF | LE1 LI0 Br0.5 | life 1.5 | size const 18.3 | tr 1.00..0.00 vis 0.49-0.49 ->1.00 | spd 0.148-7.38 drag 8 | FacingCamera/Disc | flip Grid8x8 OneShot 0 | locked | RATE 15 (continuous) | z -3
E Eletric        | tex 130194649909711 | col #000DFF->#4C58FF->#000DFF | LE1 LI0 Br10 | life 1 | size const 12.8 | tr flat 0.00 | spd 0.00366 | FacingCamera/Disc | flip Grid4x4 OneShot 30 | locked | EMIT 12 @0 | z 2
E EffectSpecs2   | tex 111088800612397 | col #000DFF->#4C58FF->#000DFF | LE1 LI0 Br25 | life 1 | size const 9.16 | tr flat 0.00 | spd 0.00366 | FacingCameraWorldUp/Disc | flip Grid4x4 OneShot 30 | locked | EMIT 12 @0 | z 2
E SpcsFront      | tex 84026052578030 | col #7C7CFF | LE1 LI0 Br10 | life 0.5-1 | size const 1.83 | tr 0.00..0.00 vis 0.00-0.82 ->1.00 | spd 3.66-9.16 drag 5 | VelocityParallel | RATE 38 (continuous)
E Stars          | tex 18920754055 | col #6246FF | LE0 LI0 Br10 | life 3.5-3.6 | size shrink 0.389->0 | tr flat 0.00 | spd 0.00037 spread 360 rotSpd -50-50 | FacingCamera | locked | EMIT 0 @0 | z 2 | attrs {"_vfxEditorGraphSize": "[{\"envelope\":0,\"direction\":\"Out\",\"index\""}
E Spark2         | tex 16020762555 | col #5D00FF->#AC85FF->#5D00FF | LE-5 LI0 Br10 | life 0.5-1 | size shrink 1.48->0 | tr 1.00..0.00 vis 0.50-0.50 ->1.00 | spd 0.148-7.38 drag 8 spread 30 rotSpd -50-50 | FacingCamera | locked | RATE 20 (continuous) | z 1
E Spark1         | tex 15887200134 | col #B19EFF->#2D1EFF->#4F0AFF | LE-10 LI0 Br8 | life 0.5-1 | size shrink 0.394->0 | tr flat 0.00 | spd 7.38-14.8 drag 8 spread 30 rotSpd -500-500 | FacingCamera | flip Grid2x2 OneShot 0 | locked | RATE 20 (continuous)
E CircleSmokeMai | tex 91740965518228 | col #2B00FF->#5D00FF->#2B00FF | LE1 LI0 Br0.25 | life 1 | size const 18.3 | tr flat 0.00 | spd 0.00037 rotSpd 360 | VelocityPerpendicular | locked | EMIT 0 @0 | z 0.15
E CircleSmokeMai | tex 70835829488056 | col #5D00FF->#5500FF | LE0.2 LI0 Br0.25 | life 1 | size const 14.7 | tr flat 0.00 | spd 0.00037 rotSpd 360 | VelocityPerpendicular | locked | EMIT 0 @0 | z 1
E CenterCircleOu | tex 134871315187295 | col #0800FF | LE0 LI0 Br2 | life 1 | size const 14.7 | tr 1.00..0.00 vis 0.47-0.47 ->1.00 | spd 0.00015 rotSpd 180 | VelocityPerpendicular | locked | EMIT 0 @0 | z -4
E CircleCenter   | tex 139907108933554 | col #1A25FF | LE1 LI0 Br50 | life 1 | size const 8.46 | tr flat 0.00 | spd 0.00037 spread 5 rotSpd 360 | VelocityPerpendicular | locked | EMIT 0 @0 | z 1
E CircleCenter2  | tex 137616452433379 | col #304CFF | LE1 LI0 Br10 | life 1 | size grow 0->9.53 | tr flat 0.00 | spd 0.014 rotSpd 360 | VelocityPerpendicular | locked | EMIT 0 @0
E CircleCenter3  | tex 124649184587590 | col #304CFF | LE1 LI0 Br100 | life 1 | size const 12.8 | tr flat 0.00 | spd 0.014 rotSpd 360 | VelocityPerpendicular | locked | EMIT 0 @0 | z -1
```
