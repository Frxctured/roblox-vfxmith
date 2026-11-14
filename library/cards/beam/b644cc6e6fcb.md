# b644cc6e6fcb: lightningburst.rbxl :: ReplicatedStorage/Assets/Launch

- Category: **beam**; tags: beam, flash, lightning, shockwave, smoke
- Layers: 8 emitters, 0 beams, 0 trails, 0 mesh parts, 0 lights; estimated length 1.5 s
- Fired by: EmitCount attributes
- Pack file: `190 OS (Oct 2024-Mar 2026)/lightningburst.rbxl` (instance referent 997): cut it into Studio with `kit/scripts/rbxcut.py "<pack>/190 OS (Oct 2024-Mar 2026)/lightningburst.rbxl" --ref 997 --out <studio content>/vfxlib/fx_b644cc6e6fcb.rbxmx`
- Frames: none captured yet (play it with kit/studio/VFXLibPlayer.luau)

## Layers (one line each, in firing order; E emitter, B beam, T trail, P part, S script)
```
E smoke          | tex 14511315116 | col #FFFFFF | LE0 LI0 Br2 | life 0.25-1.25 | size grow 0->15 | tr 1.00..0.57 vis 0.52-0.52 ->1.00 | spd 15-58 drag 4 spread 5-180 acc 0-15-0 rotSpd -50-50 | FacingCamera | locked | EMIT 15 @0
E Shockwave2     | tex 14080556170 | col #FFFFFF | LE1 LI0 Br8.31 | life 0.4-0.5 | size grow 0->31 | tr 1.00..0.92 vis 0.36-0.36 ->1.00 | spd 0.0432 spread 20 | VelocityPerpendicular | locked | EMIT 3 @0 | z 1
E wind           | tex 10149702982 (M  ParticleEmit) | col #ADADAD | LE0.1 LI0 Br0 | life 0.1-0.25 | size grow 0->59.3 | tr 0.00..0.00 vis 0.00-0.00 ->1.00 | spd 0.0174 rotSpd -20-20 | VelocityPerpendicular | EMIT 2 @0
E wind4          | tex 1084996536 (A  Wave) | col #B1B1B1 | LE1 LI0.55 Br0.05 | life 0.15-0.3 | size grow 0->40.3 | tr 1.00..0.00 vis 0.07-0.07 ->1.00 | spd 12-42 spread 15 rotSpd 700-1.5e+03 | VelocityPerpendicular | EMIT 15 @0
E ray            | tex 15733628490 | col #FFFFFF | LE1 LI0 Br3 | life 1 | size grow 0->33.7 | tr 1.00..0.51 vis 0.15-0.15 ->1.00 | spd -0.00184 | VelocityPerpendicular | EMIT 1 @0
E shockwave      | tex 15733547086 | col #FFFFFF | LE1 LI0 Br1 | life 0.75 | size grow 0->28 | tr 1.00..0.51 vis 0.15-0.15 ->1.00 | spd 0.00154 | VelocityPerpendicular | EMIT 1 @0
E wind           | tex 14370150460 | col #FFFFFF | LE1 LI0 Br1 | life 0.2-1.5 | size grow 0->31.9 | tr 0.00..0.00 vis 0.00-0.00 ->1.00 | spd 0.024 spread 10 rotSpd 100-400 | VelocityPerpendicular | EMIT 10 @0
E wind           | tex 14049010990 | col #FFFFFF | LE1 LI0 Br1 | life 0.9-1.5 | size grow 0->45 | tr 0.00..0.00 vis 0.00-0.00 ->1.00 | spd 0.024-12 spread 20 rotSpd 50-150 | VelocityPerpendicular | EMIT 9 @0
```
