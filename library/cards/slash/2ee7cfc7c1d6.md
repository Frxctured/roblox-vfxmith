# 2ee7cfc7c1d6: VFX__trash_fireball_1_month_and_1_week_progression.rbxl :: Workspace/Finished VFX/VFX/I wanna quit (9 days in)

- Category: **slash**; tags: fire, projectile, slash, star
- Layers: 17 emitters, 0 beams, 0 trails, 1 mesh parts, 2 lights; estimated length 3.1 s
- Fired by: EmitCount attributes
- Pack file: `Older OS (2025 and older)/November 2023/VFX__trash_fireball_1_month_and_1_week_progression.rbxl` (instance referent 1068). Watch it in Studio: `kit/scripts/rbxcut.py --id 2ee7cfc7c1d6 --studio`, then `P.load("fx_2ee7cfc7c1d6")` (needs the pack: `kit/scripts/get_pack.py`)
- Frames: none captured yet (play it with kit/studio/VFXLibPlayer.luau)

## Layers (one line each, in firing order; E emitter, B beam, T trail, P part, S script)
```
E s              | tex 10369597080 | col #FF4949 | LE1 LI0 Br1 | life 0.7 | size grow 0->3.01 | tr 1.00..0.69 vis 0.50-0.50 ->1.00 | spd 0 | FacingCamera | locked | RATE 30 (continuous) | z 1.68
E 1              | tex 11372606236 | col #FF5252 | LE1 LI0 Br5 | life 0.2 | size const 1 | tr flat 0.00 | spd 0 spread -360-360 | FacingCamera | flip Grid4x4 OneShot 20 | EMIT 1 @0 | z 3.3
E 3              | tex 11372606236 | col #FF5252 | LE1 LI0 Br5 | life 0.2 | size const 1 | tr flat 0.00 | spd 0 spread -360-360 | FacingCamera | flip Grid4x4 OneShot 20 | EMIT 1 @0 | z 3.3
E 2              | tex 11372587580 | col #F94D4D | LE1 LI0 Br5 | life 0.3-0.6 | size const 1 | tr flat 0.00 | spd 0 spread -360-360 | FacingCamera | flip Grid4x4 OneShot 20 | EMIT 1 @0 | z 3.3
E Orb_03         | tex 14100919747 | col #FF5C5F | LE0 LI0 Br20 | life 0.1-2 | size const 1.5 | tr flat 0.90 | spd 0.001 rotSpd 9e+03 | FacingCamera | RATE 100 (continuous)
E Orb_02         | tex 14100913824 | col #FF5C5F | LE0 LI0 Br5 | life 0.1-2 | size const 0.8 | tr 0.00..0.00 vis 0.00-1.00 ->0.00 | spd 0.001 rotSpd 9e+03 | FacingCamera | RATE 300 (continuous)
E Orb_01         | tex 14100879967 | col #FF5C5F | LE0 LI0 Br5 | life 0.1-2 | size grow 0->1.25 | tr 0.00..0.00 vis 0.00-1.00 ->0.00 | spd 0.001 rotSpd 9e+03 | FacingCamera | RATE 300 (continuous)
E s7             | tex 8684351794 | col #FF4842 | LE1 LI0 Br10 | life 0.3-0.45 | size grow 0->3.01 | tr 0.00..0.00 vis 0.00-0.00 ->1.00 | spd 0.0012 drag 10 spread 360--360 | VelocityPerpendicular | locked | EMIT 30 @0.01 | z -1.2
E s3             | tex 10890181552 | col #FF4842 | LE1 LI0 Br10 | life 0.3-0.45 | size grow 0->3.01 | tr 1.00..0.10 vis 0.49-0.49 ->1.00 | spd 0 drag 10 | FacingCameraWorldUp | locked | EMIT 30 @0.01 | z -1
E zzz            | tex 10176632695 (M Grid4x4 Impact245) | col #000000 | LE0 LI1 Br5 | life 0.2-0.575 | size const 3 | tr 1.00..0.55 vis 0.25-0.25 ->1.00 | spd 0.00229 spread 360 | VelocityPerpendicular | EMIT 2 @0.01
E Shards         | tex 14100186168 | col #FF5252 | LE0.5 LI0 Br5 | life 0.3-0.45 | size grow 0->0.684 | tr 0.00..0.00 vis 0.00-1.00 ->0.00 | spd 10 drag 1 spread 360 | VelocityParallel | squash grow 0->0.935 | locked | EMIT 30 @0.01
E Slashes        | tex 14100118951 | col #FFBCCC->#FF1317 | LE0 LI0 Br5 | life 0.2-3 | size grow 0->7.89 | tr 0.89..0.24 vis 0.47-0.47 ->0.99 | spd 0.1 spread -5-5 rotSpd 500 | VelocityPerpendicular | EMIT 5 @0.1
E Slashes_Varian | tex 14100118951 | col #FF5C5F->#FF1317 | LE0 LI0 Br5 | life 0.2-3 | size grow 0->7.89 | tr 0.89..0.24 vis 0.47-0.47 ->0.99 | spd 0.1 spread -5-5 rotSpd 500 | VelocityPerpendicular | EMIT 5 @0.1
E flame          | tex 10890181552 | col #000000 | LE0 LI1 Br4 | life 0.7 | size grow 0->3.01 | tr 1.00..0.05 vis 0.48-0.48 ->1.00 | spd 0 spread 7 rotSpd -360-360 | FacingCamera | locked | EMIT 55 @0.2 | z 1.53
E ParticleEmitte | tex 14100186168 | col #FF5C5F | LE0 LI1 Br1 | life 0.1-2 | size const 0.5 | tr flat 0.00 | spd 0.5 | FacingCameraWorldUp | EMIT 20 @0.5
E Ambers         | tex 14100675354 | col #FF5C5F | LE0 LI1 Br1 | life 0.1-2 | size const 0.1 | tr flat 0.00 | spd 5 spread 360--360 | FacingCamera | EMIT 500 @0.5
E Ambers         | tex 14100675354 | col #FFBCCC | LE0 LI1 Br1 | life 0.1-2 | size const 0.1 | tr flat 0.00 | spd 5 spread 360--360 | FacingCamera | EMIT 500 @0.5
P {"k": "MeshPart", "name": "Fired", "size": [5.0, 5.0, 5.0], "mat": "Plastic", "transp": 1.0, "mesh": 2978733208}
```
