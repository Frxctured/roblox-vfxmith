# be8dfa85f7bd: CoolOrb (2).rbxm :: Orb

- Category: **projectile**; tags: dark, flash, impact, projectile, star
- Layers: 11 emitters, 0 beams, 0 trails, 0 mesh parts, 0 lights; estimated length 1.0 s
- Fired by: saved running (Enabled + Rate)
- Pack file: `Older OS (2025 and older)/Oct 2024 - Jan 2025/CoolOrb (2).rbxm` (instance referent 0). Watch it in Studio: `kit/scripts/rbxcut.py --id be8dfa85f7bd --studio`, then `P.load("fx_be8dfa85f7bd")` (needs the pack: `kit/scripts/get_pack.py`)
- Frames: none captured yet (play it with kit/studio/VFXLibPlayer.luau)

## Layers (one line each, in firing order; E emitter, B beam, T trail, P part, S script)
```
E Second glare   | tex 102596256757654 | col #6480FF | LE1 LI0 Br0.02 | life 1 | size const 15 | tr 1.00..0.00 vis 0.50-0.50 ->1.00 | spd 0.001 spread -1e+03-1e+03 | FacingCamera | RATE 5 (continuous) | z 0.001
E Glare          | tex 102596256757654 | col #6480FF | LE1 LI0 Br0.02 | life 1 | size const 15 | tr 1.00..0.00 vis 0.50-0.50 ->1.00 | spd 0.001 spread -1e+03-1e+03 | FacingCamera | RATE 5 (continuous) | z 0.001
E InnerDetail2   | tex 78372389540126 | col #263061 | LE1 LI0 Br0.2 | life 1 | size const 7 | tr 1.00..0.00 vis 0.50-0.50 ->1.00 | spd 0.001 | FacingCamera | RATE 10 (continuous) | z -0.004
E Glow           | tex 98046010009179 (A  Dark) | col #263061 | LE1 LI0 Br0.2 | life 1 | size const 15 | tr 1.00..0.00 vis 0.50-0.50 ->1.00 | spd 0.001 | FacingCamera | RATE 5 (continuous) | z 0.007
E Glare3         | tex 88382735838050 | col #263061 | LE1 LI0 Br0.2 | life 1 | size const 15 | tr 1.00..0.00 vis 0.50-0.50 ->1.00 | spd 0.001 rotSpd 2 | FacingCamera | RATE 5 (continuous) | z 0.007
E InnerDetail    | tex 125890866475618 | col #6480FF | LE1 LI0 Br1 | life 1 | size const 5.5 | tr 1.00..0.00 vis 0.50-0.50 ->1.00 | spd 0.001 spread -1e+03-1e+03 rotSpd 10 | FacingCamera | RATE 5 (continuous) | z 0.001
E Burst2         | tex 124679403819940 | col #6480FF | LE1 LI0 Br5 | life 1 | size grow 0->5 | tr 1.00..0.00 vis 0.50-0.50 ->1.00 | spd 0.001 spread -1e+03-1e+03 | VelocityPerpendicular | RATE 10 (continuous) | z 0.003
E Stars          | tex 14590086212 (M  Star113) | col #6480FF | LE1 LI0 Br1 | life 1 | size grow 0->5 | tr 1.00..0.00 vis 0.50-0.50 ->1.00 | spd 0.001 spread -1e+03-1e+03 | VelocityPerpendicular | RATE 10 (continuous) | z 0.002
E Debris         | tex 18460775450 | col #6480FF | LE1 LI0 Br5 | life 1 | size grow 0->5 | tr 1.00..0.00 vis 0.50-0.50 ->1.00 | spd 0.001 spread -1e+03-1e+03 | VelocityPerpendicular | RATE 20 (continuous) | z 0.001
E Burst          | tex 119473092655714 (A  slash) | col #6480FF | LE1 LI0 Br5 | life 1 | size grow 0->8 | tr 1.00..0.00 vis 0.50-0.50 ->1.00 | spd 0.001 | FacingCamera | RATE 5 (continuous) | z 0.001
E Dark circle    | tex 196969716 (D  Gradient) | col #263061 | LE-3 LI0 Br1 | life 1 | size const 5.5 | tr 1.00..0.00 vis 0.50-0.50 ->1.00 | spd 0.001 rotSpd 50 | FacingCamera | RATE 10 (continuous) | z -0.005
```
