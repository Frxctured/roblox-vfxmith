# ebcddb7d861e: VFX__trash_fireball_1_month_and_1_week_progression.rbxl :: Workspace/Finished VFX/VFX/--

- Category: **slash**; tags: fire, floor, portal, projectile, slash, star, water
- Layers: 7 emitters, 2 beams, 0 trails, 0 mesh parts, 1 lights; estimated length 1.5 s
- Fired by: saved running (Enabled + Rate)
- Pack file: `Older OS (2025 and older)/November 2023/VFX__trash_fireball_1_month_and_1_week_progression.rbxl` (instance referent 9): cut it into Studio with `kit/scripts/rbxcut.py "<pack>/Older OS (2025 and older)/November 2023/VFX__trash_fireball_1_month_and_1_week_progression.rbxl" --ref 9 --out <studio content>/vfxlib/fx_ebcddb7d861e.rbxmx`
- Frames: none captured yet (play it with kit/studio/VFXLibPlayer.luau)

## Layers (one line each, in firing order; E emitter, B beam, T trail, P part, S script)
```
E Specs 2        | tex 15318552201 | col #3856FF | LE0 LI0 Br7.25 | life 0.25-1.5 | size grow 0->0.887 | tr flat 0.00 | spd 5-25 spread 100--100 acc 0-5-0 | VelocityParallel | squash const -1 | RATE 45 (continuous) | z 1
E Slashes        | tex 15257847818 | col #2957FF | LE0 LI0 Br0 | life 1.25 | size grow 0->20.8 | tr 1.00..0.25 vis 0.33-0.33 ->1.00 | spd 0.01 spread 15--15 rotSpd 450 | VelocityPerpendicular | RATE 10 (continuous)
E Specs          | tex 15318552201 | col #3856FF | LE0 LI0 Br7.25 | life 0.25-1.5 | size grow 0->0.887 | tr flat 0.00 | spd 5-30 drag 2.5 spread 0-200 acc 0-75-0 | VelocityParallel | squash const -1 | RATE 45 (continuous) | z -1
E Thing          | tex 14694809278 | col #6788FF | LE0.45 LI0 Br4.5 | life 0.25-1.5 | size const 4.97 | tr 1.00..0.71 vis 1.00-1.00 ->0.71 | spd 15-50 drag 4.5 spread 0-200 | FacingCamera | RATE 75 (continuous) | z 0.1
E Ashes          | tex 14926541120 | col #577BFF | LE0 LI0 Br0 | life 1.5 | size grow 0->21.2 | tr 0.00..0.00 vis 0.00-0.00 ->0.51 | spd 0.01 | VelocityPerpendicular | RATE 5 (continuous) | z -0.2
E Ground Thing   | tex 14840372184 | col #577BFF | LE1 LI0 Br1.5 | life 0.1-1.25 | size grow 0->16.5 | tr 0.00..0.00 vis 0.00-0.00 ->0.51 | spd 0.01 rotSpd -15-15 | VelocityPerpendicular | RATE 15 (continuous) | z -0.1
E TornadoThing   | tex 14695392826 | col #2957FF | LE1 LI0 Br1.5 | life 1.25 | size grow 0->18.8 | tr 1.00..0.54 vis 0.33-0.33 ->1.00 | spd 0.01 spread 5--5 rotSpd 450 | VelocityPerpendicular | RATE 10 (continuous)
B Flame          | tex 14762414670 | col #3C7AFF | LE1 LI0.25 Br15 | w 20-20 curve 0-0 seg 150 face | tr 0.50..0.01 vis 0.26-0.26 ->1.00 | tex Stretch 1 spd 2 | z 0.1
B Water Rising   | tex 15063812013 | col #3C7AFF | LE0 LI0 Br0 | w 15-15 curve 0-0 seg 150 face | tr 0.50..0.03 vis 0.36-0.36 ->1.00 | tex Stretch 0.75 spd 2 | z 0.2
```
