# 86aa4a4dfaab: FireballSPEEDRUN.rbxm :: Part

- Category: **projectile**; tags: fire, impact, projectile, shockwave, smoke, star, water
- Layers: 13 emitters, 0 beams, 0 trails, 0 mesh parts, 0 lights; estimated length 2.5 s
- Fired by: saved running (Enabled + Rate)
- Pack file: `190 OS (Oct 2024-Mar 2026)/FireballSPEEDRUN.rbxm` (instance referent 0). Watch it in Studio: `kit/scripts/rbxcut.py --id 86aa4a4dfaab --studio`, then `P.load("fx_86aa4a4dfaab")` (needs the pack: `kit/scripts/get_pack.py`)
- Frames: none captured yet (play it with kit/studio/VFXLibPlayer.luau)

## Layers (one line each, in firing order; E emitter, B beam, T trail, P part, S script)
```
E Star9          | tex 17062451848 (A  Star9) | col #FF5934 | LE0 LI0 Br15 | life 1 | size const 8 | tr flat 0.80 | spd 0.1 drag 8 spread -360-360 | FacingCamera | squash const -0.5 | locked | RATE 5 (continuous) | z 1
E Wind15         | tex 101535472799928 (D Grid4x4 wave) | col #FF5934 | LE0 LI0 Br0.1 | life 0.6-0.8 | size grow 0->12.2 | tr 0.50..0.50 vis 0.00-0.00 ->1.00 | spd 3.51-17.5 spread -360-360 | VelocityParallel | flip Grid4x4 OneShot 1.25 | RATE 50 (continuous) | z -1
E Smoke48        | tex 16867583923 | col #FF5934 | LE0 LI0 Br0.1 | life 1-2.5 | size grow 0->10 | tr 0.00..0.00 vis 0.00-0.00 ->1.00 | spd 15 drag 2.4 spread -360-360 | FacingCamera | flip Grid8x8 OneShot 1 | RATE 40 (continuous) | z -0.4
E Smoke6         | tex 16867354344 (D Grid4x4 10) | col #FF5934 | LE0 LI0 Br0.1 | life 1-2.5 | size grow 0->8 | tr 0.00..0.00 vis 0.00-0.00 ->1.00 | spd 12 drag 2.4 spread -360-360 | FacingCamera | flip Grid4x4 OneShot 1 | RATE 40 (continuous) | z -0.4
E Impact1BG      | tex 16879949189 (M Grid4x4 Impact1) | col #FF5934 | LE0.1 LI0 Br0.2 | life 0.75-1 | size grow 0->5.4 | tr flat 0.00 | spd 13.5-22.5 drag 7 spread -360-360 | VelocityParallel | squash shrink 0.375->0 | flip Grid4x4 OneShot 1 | RATE 20 (continuous) | z -0.4
E Impact1        | tex 16879949189 (M Grid4x4 Impact1) | col #FF5934 | LE0.1 LI0 Br10 | life 0.75-1 | size grow 0->5.4 | tr flat 0.00 | spd 13.5-22.5 drag 7 spread -360-360 | VelocityParallel | squash shrink 0.375->0 | flip Grid4x4 OneShot 1 | RATE 20 (continuous)
E Star12         | tex 17062452122 (M   0.1) | col #FF5934 | LE0 LI0 Br15 | life 0.75-1 | size swell 0->2.5@0.25->0 | tr flat 0.00 | spd 31.2-43.8 drag 8 spread -360-360 | FacingCamera | RATE 10 (continuous) | z 2
E Water12BG      | tex 16865903588 (D Grid4x4 Water12) | col #FF5934 | LE0.1 LI0 Br0.2 | life 0.6-0.8 | size grow 0->7.5 | tr flat 0.00 | spd 1.56-7.81 spread -360-360 | FacingCamera | flip Grid4x4 OneShot 1.25 | RATE 25 (continuous) | z -0.4
E Water12        | tex 16865903588 (D Grid4x4 Water12) | col #FF5934 | LE0.1 LI0 Br10 | life 0.6-0.8 | size grow 0->6.9 | tr flat 0.00 | spd 1.44-7.19 spread -360-360 | FacingCamera | flip Grid4x4 OneShot 1.25 | RATE 25 (continuous)
E Water16        | tex 16865995882 (D Grid4x4 Water16) | col #FF5934 | LE0 LI0 Br5 | life 0.75-1 | size grow 0->1.5 | tr flat 0.00 | spd 20-30 drag 5 spread -360-360 | FacingCamera | flip Grid4x4 OneShot 1 | RATE 15 (continuous)
E Water16BG      | tex 16865995882 (D Grid4x4 Water16) | col #FF5934 | LE0 LI0 Br0.2 | life 0.75-1 | size grow 0->1.88 | tr flat 0.00 | spd 25-37.5 drag 5 spread -360-360 | FacingCamera | flip Grid4x4 OneShot 1 | RATE 15 (continuous) | z -0.5
E Water13BG      | tex 16865986014 (D Grid4x4 Water13) | col #FF5934 | LE0 LI0 Br0.1 | life 0.6-0.8 | size grow 0->7.5 | tr flat 0.00 | spd 1.56-7.81 spread -360-360 | FacingCamera | flip Grid4x4 OneShot 1.25 | EMIT 25 @0 | z -0.5
E Water13        | tex 16865986014 (D Grid4x4 Water13) | col #FF5934 | LE0 LI0 Br5 | life 0.75-1 | size grow 0->6 | tr flat 0.00 | spd 1-5 spread -360-360 | FacingCamera | flip Grid4x4 OneShot 1 | RATE 20 (continuous)
```
