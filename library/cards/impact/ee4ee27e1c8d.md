# ee4ee27e1c8d: Ranked.rbxl :: ReplicatedStorage/Assets/Effects/Shadow Monarch/Awakening/Dimse/Left Leg

- Category: **impact**; tags: dark, shockwave, smoke
- Layers: 5 emitters, 0 beams, 0 trails, 0 mesh parts, 0 lights; estimated length 1.0 s
- Fired by: EmitCount attributes
- Pack file: `190 OS (Oct 2024-Mar 2026)/Ranked.rbxl` (instance referent 4379). Watch it in Studio: `kit/scripts/rbxcut.py --id ee4ee27e1c8d --studio`, then `P.load("fx_ee4ee27e1c8d")` (needs the pack: `kit/scripts/get_pack.py`)
- Frames: none captured yet (play it with kit/studio/VFXLibPlayer.luau)

## Layers (one line each, in firing order; E emitter, B beam, T trail, P part, S script)
```
E Shockwave3     | tex 17100827794 | col #FFFFFF | LE0 LI0 Br2 | life 0.7-1 | size grow 0->3.56 | tr 1.00..0.69 vis 0.50-0.50 ->1.00 | spd 0.01 | VelocityPerpendicular | EMIT 2 @0 | z 1
E Smoke2         | tex 17100773736 | col #FFFFFF | LE0 LI0 Br3 | life 0.4-0.6 | size grow 0->1.94 | tr 1.00..0.68 vis 0.50-0.50 ->1.00 | spd 5-20 drag 5 spread 25-180 | VelocityParallel | squash const 0.4 | EMIT 25 @0 | z 0.5 | attrs {"AgainstLowSpecs": true}
E Shockwave2     | tex 17100781188 | col #FFFFFF | LE0 LI0 Br2 | life 0.7-1 | size grow 0->3.56 | tr 1.00..0.69 vis 0.50-0.50 ->1.00 | spd 0.01 | VelocityPerpendicular | EMIT 2 @0 | z 1
E Smoke1         | tex 17100773736 | col #FFFFFF | LE0 LI0 Br3 | life 0.4-0.6 | size grow 0->1.94 | tr 1.00..0.68 vis 0.50-0.50 ->1.00 | spd 15-25 drag 5 spread 0-180 rotSpd 100 | FacingCamera | EMIT 25 @0 | attrs {"AgainstLowSpecs": true}
E Shockwave1     | tex 17100722156 | col #FFFFFF | LE0 LI0 Br2 | life 0.4-0.7 | size grow 0->4.5 | tr 1.00..0.69 vis 0.50-0.50 ->1.00 | spd 0.01 spread 15 rotSpd 100 | VelocityPerpendicular | EMIT 25 @0
```
