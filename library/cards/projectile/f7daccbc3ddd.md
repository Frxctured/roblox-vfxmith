# f7daccbc3ddd: random orb.rbxm :: Part

- Category: **projectile**; tags: projectile, shockwave, star
- Layers: 13 emitters, 0 beams, 0 trails, 0 mesh parts, 0 lights; estimated length 4.0 s
- Fired by: saved running (Enabled + Rate)
- Pack file: `2026 OS Jan-April (part 2)/random orb.rbxm` (instance referent 0). Watch it in Studio: `kit/scripts/rbxcut.py --id f7daccbc3ddd --studio`, then `P.load("fx_f7daccbc3ddd")` (needs the pack: `kit/scripts/get_pack.py`)
- Frames: `gallery/effects/projectile/f7daccbc3ddd.jpg`

## Layers (one line each, in firing order; E emitter, B beam, T trail, P part, S script)
```
E Middle         | tex 94273715920250 | col #17182F | LE0 LI0 Br1 | life 4 | size grow 0->7.75 | tr 1.00..0.08 vis 0.50-0.50 ->1.00 | spd 0 spread 400 | FacingCamera/Sphere | squash const -0.3 | locked | RATE 7 (continuous) | z 4
E inside ring ou | tex 129535698195231 | col #4D57E7 | LE1 LI0 Br3 | life 4 | size grow 0->2.88 | tr 1.00..0.10 vis 0.50-0.50 ->1.00 | spd 0.001 spread 1 rotSpd -4 | FacingCamera | locked | RATE 1 (continuous) | z 2
E Inside Spiral  | tex 107815776288817 | col #4D57E7 | LE1 LI0 Br3 | life 4 | size grow 0->3.19 | tr 1.00..0.10 vis 0.50-0.50 ->1.00 | spd 0.001 spread 1 rotSpd -4 | FacingCamera | locked | RATE 2 (continuous) | z 2
E inner wall     | tex 18951936601 | col #5260E7 | LE1 LI0 Br8 | life 4 | size const 2.1 | tr 1.00..0.46 vis 0.50-0.50 ->1.00 | spd 0.001 spread 1 | FacingCamera | locked | RATE 2 (continuous) | z 3
E inside detail2 | tex 137135817059159 | col #5260E7 | LE1 LI0 Br2 | life 4 | size grow 0->3 | tr 1.00..0.65 vis 0.50-0.50 ->1.00 | spd 0.001 spread 1 | FacingCamera | squash const -0.1 | locked | RATE 2 (continuous) | z 3
E glare 2        | tex 72058519746764 | col #757BE7 | LE1 LI0 Br1 | life 4 | size const 4.99 | tr 1.00..0.66 vis 0.50-0.50 ->1.00 | spd 0.001 | FacingCamera | flip Grid4x4 Loop 1 | locked | RATE 2 (continuous) | z 1
E glare 1        | tex 81828566722014 | col #4C54E7 | LE1 LI0 Br1 | life 4 | size const 3 | tr 1.00..0.78 vis 0.50-0.50 ->1.00 | spd 0.001 | FacingCamera | locked | RATE 2 (continuous) | z 1
E star           | tex 14590086212 (M  Star113) | col #656EE7 | LE1 LI0 Br3 | life 4 | size const 3 | tr 1.00..0.34 vis 0.50-0.50 ->1.00 | spd 0.001 spread 1 | FacingCamera | squash shrink 0->-2.85 | locked | RATE 1 (continuous) | z 3
E inside detail  | tex 91258314575153 | col #3F45AF | LE1 LI0 Br3 | life 4 | size const 2.2 | tr 1.00..0.56 vis 0.50-0.50 ->1.00 | spd 0.001 spread 1 | FacingCamera | locked | RATE 2 (continuous) | z 2
E out spiral     | tex 18814788385 | col #5260E7 | LE1 LI0 Br7 | life 4 | size grow 0->2.19 | tr 1.00..0.74 vis 0.50-0.50 ->1.00 | spd 0.001 spread 1 rotSpd -4 | FacingCamera | locked | RATE 2 (continuous) | z 3
E Inside Stars   | tex 90699600186298 (M  Debris) | col #5A63E7 | LE1 LI0 Br4 | life 4 | size grow 0->3.19 | tr 1.00..0.28 vis 0.50-0.50 ->1.00 | spd 0.001 spread 1 | FacingCamera | locked | RATE 2 (continuous) | z 1
E Around circle  | tex 95791597657384 | col #4C54E7 | LE1 LI0 Br1.2 | life 4 | size const 3.2 | tr 1.00..0.28 vis 0.50-0.50 ->1.00 | spd 0.001 | FacingCamera | locked | RATE 2 (continuous) | z 1
E Circle         | tex 196969716 (D  Gradient) | col #100E38 | LE0 LI0 Br0.4 | life 4 | size const 2 | tr flat 0.00 | spd 0.001 rotSpd -20 | FacingCamera | locked | RATE 10 (continuous)
```
