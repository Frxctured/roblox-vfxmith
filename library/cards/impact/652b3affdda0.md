# 652b3affdda0: mochibarrage.rbxm :: mochi

- Category: **impact**; tags: floor, impact, lightning, shockwave, smoke
- Layers: 21 emitters, 0 beams, 0 trails, 0 mesh parts, 1 lights; estimated length 1.4 s
- Fired by: EmitCount attributes
- Pack file: `Older OS (2025 and older)/Other VFX (Aug 2023)/mochibarrage.rbxm` (instance referent 0): cut it into Studio with `kit/scripts/rbxcut.py "<pack>/Older OS (2025 and older)/Other VFX (Aug 2023)/mochibarrage.rbxm" --ref 0 --out <studio content>/vfxlib/fx_652b3affdda0.rbxmx`
- Frames: none captured yet (play it with kit/studio/VFXLibPlayer.luau)

## Layers (one line each, in firing order; E emitter, B beam, T trail, P part, S script)
```
E doughgoup      | tex 10814183330 | col #FFFF7F->#FFFFFF | LE0.5 LI0 Br10 | life 0.3-1 | size swell 0->7.62@0.22->0 | tr flat 0.00 | spd 65-125 drag 5 spread -40-40 acc 0--55-0 | VelocityParallel | EMIT 33 @0
E drop           | tex 10358009229 | col #FFFF7F->#FFFFFF | LE1 LI0 Br1 | life 0.4 | size grow 0->6.38 | tr 1.00..0.84 vis 0.48-0.48 ->1.00 | spd 0.01 rotSpd -35-35 | VelocityPerpendicular | locked | EMIT 15 @0
E smoke          | tex 10574972827 | col #FCFFB0->#FFFFFF | LE1 LI0 Br0.19 | life 0.3-0.6 | size swell 0.157->21.7@0.27->21.6 | tr 0.42..0.42 vis 0.00-0.00 ->1.00 | spd 66-125 drag 4 spread -50-360 rotSpd -55-55 | FacingCamera | EMIT 33 @0 | z 3
E spark          | tex 8030760338 (M Grid4x4 Specs) | col #FFFFFF | LE0 LI0 Br4 | life 0.3-0.5 | size swell 0->10@0.31->0 | tr flat 0.00 | spd 150-333 drag 3 spread -360-360 acc 0--111-0 | VelocityParallel | EMIT 25 @0
E shard          | tex 14176815459 | col #FFFC9B->#FFFFFF | LE-5 LI0 Br5 | life 0.2-0.35 | size swell 0->21.7@0.57->0 | tr flat 0.00 | spd 77-250 drag 5 spread -90-90 | VelocityParallel | squash grow 0->1.95 | flip Grid4x4 Loop 1 | locked | EMIT 11 @0 | z 2
E centermochi    | tex 11025877566 | col #FFFC9B->#FFFFFF | LE-0.5 LI0 Br10 | life 0.2-0.35 | size swell 0->21.7@0.57->0 | tr flat 0.00 | spd 250 drag 5 spread -90-90 | VelocityParallel | squash grow 0->1.95 | flip Grid4x4 Loop 1 | locked | EMIT 11 @0 | z 2
E dough          | tex 10814183330 | col #FFFF7F->#FFFFFF | LE0.8 LI0 Br2 | life 0.3-0.5 | size swell 0->28.8@0.47->0 | tr flat 0.00 | spd 55-250 drag 3 spread -360-360 acc 0--55-0 | VelocityParallel/Disc | EMIT 44 @0
E Specs          | tex 10813532373 | col #F8FFA4->#FFFFFF | LE0.5 LI0 Br10 | life 0.3-1 | size swell 0->7.62@0.22->0 | tr flat 0.00 | spd 125-222 drag 5 spread -360-360 acc 0--55-0 | FacingCamera | EMIT 15 @0
E Specs          | tex 10814183330 | col #FEFFB4 | LE0.5 LI0 Br10 | life 0.3-1 | size swell 0->7.62@0.22->0 | tr flat 0.00 | spd 125-222 drag 5 spread -360-360 acc 0--55-0 | VelocityParallel | EMIT 33 @0
E shockwave      | tex 8133065785 (M  Images/HitFX) | col #FFFF7F->#FFFFFF | LE1 LI0 Br5 | life 0.4-0.6 | size grow 0->64.8 | tr 1.00..0.81 vis 0.44-0.44 ->1.00 | spd 0.0045 | VelocityPerpendicular | locked | EMIT 5 @0 | z 0.108
E shockwave      | tex 10358009229 | col #FFFF7F | LE1 LI0 Br1 | life 0.4 | size grow 0->66.8 | tr 1.00..0.62 vis 0.49-0.49 ->1.00 | spd 0.01 rotSpd -35-35 | VelocityPerpendicular | locked | EMIT 1 @0 | z 0.108
E rock           | tex 626588936 (D  Rocks) | col #5F5F5F | LE0 LI0 Br0.21 | life 0.6 | size swell 0->2.38@0.21->0 | tr flat 0.00 | spd 100-150 drag 2 spread 0-360 rotSpd -360-360 | FacingCamera | EMIT 44 @0
E groundcrack    | tex 10219342960 | col #000000 | LE0 LI0 Br2.31 | life 1 | size const 35 | tr 1.00..0.00 vis 0.08-0.65 ->1.00 | spd 0.0082 | VelocityPerpendicular | EMIT 2 @0 | z -0.5
E whityewind     | tex 10813564431 | col #FFFF7F->#FFFFFF | LE1 LI0 Br25 | life 0.3-0.4 | size grow 0->49.4 | tr 1.00..0.49 vis 0.49-0.49 ->1.00 | spd 0.001 drag 0.22 spread -5-5 rotSpd 200-500 | VelocityPerpendicular | EMIT 15 @0 | z 0.108
E smoke          | tex 10574972827 | col #F9FFB4->#FFFFFF | LE1 LI0 Br0.19 | life 0.3-0.6 | size swell 0.157->10@0.69->0 | tr flat 0.70 | spd 66-125 drag 4 spread -50-360 rotSpd -55-55 | FacingCamera | EMIT 33 @0 | z 1
E shard          | tex 10813501858 | col #FFFC9B->#FFFFFF | LE0 LI0 Br2 | life 0.2-0.35 | size swell 0->21.7@0.57->0 | tr flat 0.00 | spd 77-250 drag 5 spread -90-90 | VelocityParallel | locked | EMIT 11 @0 | z 2
E wind           | tex 10813564431 | col #FFFF7F->#FFFFFF | LE0 LI0 Br25 | life 0.3-0.4 | size grow 0->41.2 | tr 1.00..0.00 vis 0.47-0.47 ->1.00 | spd 7-45 drag 0.22 spread -10-10 rotSpd 200-500 | VelocityPerpendicular | EMIT 11 @0 | z 0.108
E wind           | tex 10813564431 | col #FFFF7F->#FFFFFF | LE0 LI0 Br25 | life 0.3-0.4 | size grow 0->43.4 | tr 1.00..0.45 vis 0.51-0.51 ->1.00 | spd 2-6 drag 0.22 spread -360-360 rotSpd 200-500 | VelocityPerpendicular | locked | EMIT 11 @0 | z 0.108
E Specs          | tex 10813532373 | col #FEFFAC->#FFFFFF | LE0.5 LI0 Br10 | life 0.3-1 | size swell 0->7.62@0.22->0 | tr flat 0.00 | spd 125-222 drag 5 spread -360-360 acc 0--55-0 | FacingCamera | EMIT 15 @0
E Specs          | tex 10814183330 | col #FFFF7F->#FFFFFF | LE0.5 LI0 Br10 | life 0.6-1.2 | size swell 0->17.5@0.24->0 | tr flat 0.00 | spd 0.001 drag 5 | VelocityPerpendicular | EMIT 33 @0.2
E doughspot      | tex 10814183330 | col #FFFF7F->#FFFFFF | LE0.5 LI0 Br10 | life 0.6-1.2 | size swell 0->8.71@0.36->0 | tr flat 0.00 | spd 0.001 drag 5 | VelocityPerpendicular | EMIT 33 @0.2
```
