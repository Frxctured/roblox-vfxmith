# de4c50a7e6df: VFX__trash_fireball_1_month_and_1_week_progression.rbxl :: Workspace/Finished VFX/VFX/Healing

- Category: **projectile**; tags: fire, holy, projectile, smoke, star
- Layers: 4 emitters, 0 beams, 0 trails, 0 mesh parts, 1 lights; estimated length 3.25 s
- Fired by: saved running (Enabled + Rate)
- Pack file: `Older OS (2025 and older)/November 2023/VFX__trash_fireball_1_month_and_1_week_progression.rbxl` (instance referent 201): cut it into Studio with `kit/scripts/rbxcut.py "<pack>/Older OS (2025 and older)/November 2023/VFX__trash_fireball_1_month_and_1_week_progression.rbxl" --ref 201 --out <studio content>/vfxlib/fx_de4c50a7e6df.rbxmx`
- Frames: none captured yet (play it with kit/studio/VFXLibPlayer.luau)

## Layers (one line each, in firing order; E emitter, B beam, T trail, P part, S script)
```
E Smoke          | tex 15350639550 | col #FFFFFF | LE0 LI1 Br1 | life 0.45-1.25 | size shrink 4.12->3.22 | tr 1.00..0.87 vis 0.49-0.49 ->1.00 | spd 15 drag 1.5 | VelocityParallel | flip Grid2x2 Loop 3 | RATE 15 (continuous)
E Stars          | tex 15350666375 | col #F4FFBB | LE1 LI0 Br15 | life 0.25-1.75 | size shrink 2->0.727 | tr 0.00..0.00 vis 0.00-0.00 ->1.00 | spd 5-45 drag 4.25 rotSpd -15-15 | FacingCamera | RATE 15 (continuous)
E Lines          | tex 15292043166 | col #F4FFBB | LE1 LI0 Br5 | life 0.25-1.75 | size shrink 2->0.727 | tr 0.00..0.00 vis 0.00-0.00 ->1.00 | spd 5-45 drag 4.25 | VelocityParallel | squash grow 0->2.51 | RATE 45 (continuous)
E Main           | col #FFFFFF | LE1 LI1 Br1 | life 3.25 | size grow 0->20.4 | tr 1.00..0.47 vis 0.44-0.44 ->1.00 | spd 0.01 rotSpd -15-15 | VelocityPerpendicular | squash shrink 0->-0.0341 | RATE 3 (continuous)
```
