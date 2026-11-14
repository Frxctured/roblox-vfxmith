# dffae23256ce: VFX__trash_fireball_1_month_and_1_week_progression.rbxl :: Workspace/Finished VFX/VFX/Cum Fest

- Category: **slash**; tags: fire, flash, floor, impact, lightning, projectile, shockwave, slash, smoke, star
- Layers: 15 emitters, 2 beams, 0 trails, 0 mesh parts, 1 lights; estimated length 2.5 s
- Fired by: saved running (Enabled + Rate)
- Pack file: `Older OS (2025 and older)/November 2023/VFX__trash_fireball_1_month_and_1_week_progression.rbxl` (instance referent 76): cut it into Studio with `kit/scripts/rbxcut.py "<pack>/Older OS (2025 and older)/November 2023/VFX__trash_fireball_1_month_and_1_week_progression.rbxl" --ref 76 --out <studio content>/vfxlib/fx_dffae23256ce.rbxmx`
- Frames: none captured yet (play it with kit/studio/VFXLibPlayer.luau)

## Layers (one line each, in firing order; E emitter, B beam, T trail, P part, S script)
```
E Cum Splatter   | tex 15318552201 | col #FFFFFF | LE1 LI0 Br15 | life 0.25-1.25 | size grow 0->0.324 | tr 0.00..0.00 vis 0.00-0.00 ->1.00 | spd 5-75 drag 4.75 spread 50--50 acc 0--25-0 | VelocityParallel | RATE 75 (continuous)
E Cum Dust       | tex 15350639550 | col #FFFFFF | LE0 LI0 Br15 | life 0.35-1.25 | size const 2.54 | tr 1.00..0.94 vis 0.47-0.47 ->1.00 | spd 5-15 drag 1.25 spread 0-200 rotSpd -5-5 | FacingCamera | flip Grid2x2 Loop 5 | RATE 40 (continuous)
E Cum Floor      | tex 15292015668 | col #FFFFFF | LE1 LI0 Br15 | life 0.15-2.5 | size grow 0->9.56 | tr 0.00..0.00 vis 0.00-0.00 ->1.00 | spd 0.01 rotSpd -5-5 | VelocityPerpendicular | RATE 20 (continuous)
E Cum Splatter   | tex 15318552201 | col #FFFFFF | LE1 LI0 Br5 | life 0.25-1.25 | size grow 0->1 | tr 0.00..0.00 vis 0.00-0.00 ->1.00 | spd 5-75 drag 4.75 spread 30--30 acc 0--25-0 | VelocityParallel | squash const -1 | RATE 75 (continuous)
E Cum Lightning  | tex 15463104296 | col #FFFFFF | LE1 LI0 Br5 | life 0.15-0.95 | size const 3.25 | tr flat 0.00 | spd 0.01 spread 360--360 | FacingCamera | flip Grid4x4 Loop 15 | RATE 15 (continuous) | z 0.1
E Cum Slashes    | tex 15257847818 | col #FFFFFF | LE0 LI1 Br1 | life 0.15-1.25 | size grow 0->5.1 | tr 0.53..0.53 vis 0.00-0.00 ->1.00 | spd 0.01 spread 360--360 rotSpd 350 | VelocityPerpendicular | RATE 15 (continuous) | z 0.5
E Cum Wave 2     | tex 15462937610 | col #FFFFFF | LE1 LI1 Br1 | life 1.25 | size shrink 7->0 | tr 1.00..0.91 vis 0.85-0.85 ->1.00 | spd 0.01 spread 360--360 rotSpd -10-10 | VelocityPerpendicular | RATE 15 (continuous) | z 0.1
E Cum Wave       | tex 15462931735 | col #FFFFFF | LE1 LI1 Br1 | life 1.25 | size shrink 7->0 | tr 1.00..0.91 vis 0.85-0.85 ->1.00 | spd 0.01 spread 360--360 rotSpd -10-10 | VelocityPerpendicular | RATE 15 (continuous) | z 0.1
E CumRing        | tex 15463011981 | col #FFFFFF | LE1 LI0 Br5 | life 2 | size const 3 | tr flat 0.00 | spd 0.01 | FacingCamera | RATE 2 (continuous) | z 0.1
E CumGlow        | tex 15463008436 | col #FFFFFF | LE1 LI0 Br5 | life 2 | size const 3 | tr flat 0.00 | spd 0.01 | FacingCamera | RATE 2 (continuous)
E Cum Slashes v2 | tex 15463163054 | col #FFFFFF | LE1 LI1 Br1 | life 0.15-1.25 | size grow 0->30 | tr 0.53..0.53 vis 0.00-0.00 ->1.00 | spd 0.01 spread 10--10 rotSpd 350 | VelocityPerpendicular | RATE 15 (continuous) | z 0.5
E Cum Slashes    | tex 15257847818 | col #FFFFFF | LE0 LI1 Br1 | life 0.15-1.25 | size grow 0->30 | tr 0.53..0.53 vis 0.00-0.00 ->1.00 | spd 0.01 spread 15--15 rotSpd 350 | VelocityPerpendicular | RATE 15 (continuous) | z 0.5
E Cum Wave 2     | tex 15462937610 | col #FFFFFF | LE1 LI1 Br1 | life 1.25 | size shrink 25->0 | tr 1.00..0.91 vis 0.85-0.85 ->1.00 | spd 0.01 rotSpd -10-10 | VelocityPerpendicular | RATE 15 (continuous) | z 0.1
E Cum Wave       | tex 15462931735 | col #FFFFFF | LE1 LI1 Br1 | life 1.25 | size shrink 25->0 | tr 1.00..0.91 vis 0.85-0.85 ->1.00 | spd 0.01 rotSpd -10-10 | VelocityPerpendicular | RATE 15 (continuous) | z 0.1
E Cum Crack      | tex 15434082604 | col #FFFFFF | LE1 LI1 Br1 | life 1.25 | size shrink 25->0 | tr 1.00..0.91 vis 0.85-0.85 ->1.00 | spd 0.01 rotSpd -10-10 | VelocityPerpendicular | RATE 15 (continuous) | z -0.05
B Cum Steam Two  | tex 15358187027 | col #FFFFFF | LE1 LI0 Br25 | w 30-30 curve 0-0 seg 150 face | tr 1.00..0.96 vis 0.50-0.50 ->1.00 | tex Stretch 1 spd 0.45
B Cum Steam      | tex 15358187027 | col #FFFFFF | LE0 LI1 Br1 | w 40-40 curve 0-0 seg 150 face | tr 1.00..0.88 vis 0.49-0.49 ->1.00 | tex Stretch 0.25 spd 0.45
```
