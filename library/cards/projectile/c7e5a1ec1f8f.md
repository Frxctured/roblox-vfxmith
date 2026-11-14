# c7e5a1ec1f8f: VFX__trash_fireball_1_month_and_1_week_progression.rbxl :: Workspace/Finished VFX/VFX/Portal

- Category: **projectile**; tags: fire, floor, portal, projectile, shockwave, star
- Layers: 4 emitters, 0 beams, 0 trails, 0 mesh parts, 1 lights; estimated length 1.25 s
- Fired by: saved running (Enabled + Rate)
- Pack file: `Older OS (2025 and older)/November 2023/VFX__trash_fireball_1_month_and_1_week_progression.rbxl` (instance referent 215): cut it into Studio with `kit/scripts/rbxcut.py "<pack>/Older OS (2025 and older)/November 2023/VFX__trash_fireball_1_month_and_1_week_progression.rbxl" --ref 215 --out <studio content>/vfxlib/fx_c7e5a1ec1f8f.rbxmx`
- Frames: none captured yet (play it with kit/studio/VFXLibPlayer.luau)

## Layers (one line each, in firing order; E emitter, B beam, T trail, P part, S script)
```
E Giant Star     | tex 15294279094 | col #305DFF->#2C6FFF->#FFFFFF | LE1 LI0 Br7.25 | life 0.25-1.25 | size grow 0->5 | tr 0.00..0.00 vis 0.00-0.00 ->1.00 | spd 0.1 | FacingCamera | locked | RATE 30 (continuous) | z -0.05
E Dissolving Wav | tex 15507504557 | col #BCABFF->#3A89FF | LE1 LI0.65 Br7.25 | life 0.75 | size shrink 4.25->0 | tr 1.00..0.83 vis 0.50-0.50 ->1.00 | spd 0.01 rotSpd -15-15 | FacingCamera | flip Grid4x4 OneShot 1 | locked | RATE 10 (continuous) | z -0.05
E Crack In       | tex 15434082604 | col #BCABFF->#3A89FF | LE1 LI0.65 Br7.25 | life 0.75 | size shrink 2.75->0 | tr 1.00..0.49 vis 0.30-0.70 ->1.00 | spd 0.01 rotSpd -15-15 | FacingCamera | locked | RATE 10 (continuous)
E Shockwave In   | tex 15462937610 | col #BCABFF->#3A89FF | LE1 LI0.65 Br7.25 | life 0.75 | size shrink 2.75->0 | tr 1.00..0.49 vis 0.30-0.70 ->1.00 | spd 0.01 | FacingCamera | locked | RATE 5 (continuous)
```
