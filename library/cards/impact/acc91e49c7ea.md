# acc91e49c7ea: Almighty Push.rbxm :: Almighty Push

- Category: **impact**; tags: impact
- Layers: 14 emitters, 0 beams, 0 trails, 0 mesh parts, 0 lights; estimated length 2.5 s
- Fired by: EmitCount attributes
- Pack file: `Older OS (2025 and older)/Oct 2024 - Jan 2025/Almighty Push.rbxm` (instance referent 0). Watch it in Studio: `kit/scripts/rbxcut.py --id acc91e49c7ea --studio`, then `P.load("fx_acc91e49c7ea")` (needs the pack: `kit/scripts/get_pack.py`)
- Frames: none captured yet (play it with kit/studio/VFXLibPlayer.luau)

## Layers (one line each, in firing order; E emitter, B beam, T trail, P part, S script)
```
E Rocks          | tex 15441282898 (D Grid2x2 Rocks 2x2) | col #878787->#FFFFFF | LE0 LI1 Br1 | life 0.5-1.5 | size shrink 3.88->0 | tr flat 0.00 | spd 175-300 drag 4 spread 35-360 acc 0--150-0 rotSpd -150-150 | FacingCamera | flip Grid2x2 Loop 0 | EMIT 55 @0
E Rocks 2        | tex 15441282898 (D Grid2x2 Rocks 2x2) | col #878787->#FFFFFF | LE0 LI1 Br1 | life 0.5-1.5 | size shrink 3.88->0 | tr flat 0.00 | spd 175-300 drag 4 spread 35-360 acc 0--150-0 rotSpd -150-150 | FacingCamera | flip Grid2x2 Loop 0 | EMIT 55 @0
E S3             | tex 17762024346 (A Grid4x4 snowy) | col #878787->#FFFFFF | LE0 LI1 Br1 | life 0.15-2.5 | size grow 0->25.2 | tr 1.00..0.64 vis 0.20-0.20 ->1.00 | spd 50-250 drag 5 spread 35-180 acc 0--25-0 | FacingCamera | flip Grid4x4 OneShot 0 | EMIT 100 @0 | z 1
E S Whirl        | tex 13736805356 (D Grid4x4 wavy') | col #FFFFFF | LE0 LI1 Br1 | life 0.015-1 | size grow 0->66.3 | tr 1.00..0.95 vis 0.15-0.15 ->1.00 | spd 0.001 | VelocityPerpendicular | flip Grid4x4 OneShot 1 | EMIT 15 @0 | z 2
E S2             | tex 14050526759 (M Grid2x2 Dust) | col #878787->#FFFFFF | LE0 LI1 Br1 | life 0.15-2.5 | size grow 0->22.4 | tr 1.00..0.93 vis 0.20-0.20 ->1.00 | spd 100-300 drag 5 spread 5-180 | VelocityParallel | squash grow 0->0.713 | flip Grid2x2 Loop 0 | EMIT 55 @0 | z 2
E S1             | tex 14050526759 (M Grid2x2 Dust) | col #878787->#FFFFFF | LE0 LI1 Br1 | life 0.15-2.5 | size grow 0->25.2 | tr 1.00..0.64 vis 0.20-0.20 ->1.00 | spd 150-250 drag 5 spread 15-180 rotSpd -50-50 | FacingCamera | flip Grid2x2 Loop 0 | EMIT 100 @0 | z 1
E Whirl 4        | tex 75353285142738 (A  impact) | col #FFFFFF | LE0 LI1 Br1 | life 0.015-1.25 | size grow 0->47.3 | tr 1.00..0.95 vis 0.15-0.15 ->1.00 | spd 0.001 spread 15 rotSpd -100-100 | VelocityPerpendicular | EMIT 15 @0 | z 1
E Whirl 2        | tex 126294351777027 | col #FFFFFF | LE1 LI1 Br1 | life 0.015-1.25 | size grow 0->47.3 | tr 1.00..0.95 vis 0.15-0.15 ->1.00 | spd 0.001 spread 10 rotSpd -100-100 | VelocityPerpendicular | EMIT 15 @0 | z 1
E Whirl 1        | tex 18652132265 (A  wind) | col #FFFFFF | LE1 LI0 Br5 | life 0.015-1.25 | size grow 0->47.3 | tr 1.00..0.95 vis 0.15-0.15 ->1.00 | spd 0.001 spread 15 rotSpd -100-100 | VelocityPerpendicular | EMIT 15 @0 | z 1
E Whirl 3        | tex 116387802988546 | col #FFFFFF | LE0 LI1 Br1 | life 0.015-1.25 | size grow 0->47.3 | tr 1.00..0.95 vis 0.15-0.15 ->1.00 | spd 0.001 spread 15 rotSpd -100-100 | VelocityPerpendicular | EMIT 15 @0 | z 1
E Impact 4       | tex 14221642318 | col #FFFFFF | LE1 LI0 Br1 | life 0.015-0.5 | size grow 0->38.5 | tr 0.49..0.49 vis 0.00-0.00 ->1.00 | spd 0.001 spread 360 | FacingCamera | EMIT 5 @0 | z 1
E Impact 3       | tex 7216856024 (M  Images/circl) | col #FFFFFF | LE1 LI0 Br1 | life 0.015-0.5 | size grow 0->38.5 | tr 0.49..0.49 vis 0.00-0.00 ->1.00 | spd 0.001 spread 360 | FacingCamera | EMIT 5 @0 | z 1
E Impact 2       | tex 7185003058 (M Grid8x8 4) | col #FFFFFF | LE0 LI1 Br1 | life 0.015-0.5 | size grow 0->38.5 | tr 0.76..0.76 vis 0.00-0.00 ->1.00 | spd 0.001 spread 360 | VelocityPerpendicular | EMIT 5 @0 | z 1
E Impact         | tex 7185003058 (M Grid8x8 4) | col #FFFFFF | LE0 LI1 Br1 | life 0.015-0.5 | size grow 0->38.5 | tr 0.76..0.76 vis 0.00-0.00 ->1.00 | spd 0.001 | FacingCamera | EMIT 5 @0 | z 1
```
