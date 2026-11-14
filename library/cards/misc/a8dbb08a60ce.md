# a8dbb08a60ce: Star.rbxm :: Star

- Category: **misc**; tags: flash, impact, smoke, star
- Layers: 25 emitters, 0 beams, 0 trails, 0 mesh parts, 0 lights; estimated length 8.0 s
- Fired by: saved running (Enabled + Rate)
- Pack file: `Older OS (2025 and older)/Oct 2024 - Jan 2025/Star.rbxm` (instance referent 0). Watch it in Studio: `kit/scripts/rbxcut.py --id a8dbb08a60ce --studio`, then `P.load("fx_a8dbb08a60ce")` (needs the pack: `kit/scripts/get_pack.py`)
- Frames: none captured yet (play it with kit/studio/VFXLibPlayer.luau)

## Layers (one line each, in firing order; E emitter, B beam, T trail, P part, S script)
```
E Star_3         | tex 13368682130 (A  star) | col #D2BB9E->#FFC481 | LE1 LI0 Br0.1 | life 1-1.2 | size grow 0->30.6 | tr 1.00..0.60 vis 0.50-0.50 ->1.00 | spd 0.00064 | FacingCamera | locked | RATE 6 (continuous)
E Star_2         | tex 3052949762 (M Grid4x4 Custom Lens ) | col #D89E8D | LE1 LI0 Br0.3 | life 1-1.2 | size grow 0->30.6 | tr 1.00..0.00 vis 0.50-0.50 ->1.00 | spd 0.00064 | FacingCamera | locked | RATE 6 (continuous)
E Star           | tex 87009648602330 | col #CEA278->#FFC481 | LE1 LI0 Br0.02 | life 1-1.2 | size grow 0->14.5 | tr 1.00..0.00 vis 0.50-0.50 ->1.00 | spd 0.00172 | FacingCamera | locked | RATE 6 (continuous)
E Star           | tex 101814758956321 | col #CEA278->#FFC481 | LE1 LI0 Br0.8 | life 1-1.2 | size grow 0->8.93 | tr 1.00..0.00 vis 0.50-0.50 ->1.00 | spd 0.00064 | FacingCamera | flip Grid2x2 OneShot 1 | locked | RATE 6 (continuous)
E Noise          | tex 18556873558 | col #CEA278->#FFC481 | LE1 LI0 Br0.1 | life 4 | size grow 0->15.3 | tr 1.00..0.96 vis 0.50-0.50 ->1.00 | spd 0.00064 | FacingCamera | flip Grid8x8 Loop 0 | locked | RATE 11 (continuous)
E Light_2        | tex 15501782488 (A  star) | col #CEA278->#FFC481 | LE1 LI0 Br0.75 | life 4 | size const 22.9 | tr 1.00..0.90 vis 0.50-0.50 ->1.00 | spd 0.00064 | FacingCamera | locked | RATE 1 (continuous)
E Light          | tex 15501782488 (A  star) | col #CEA278->#FFC481 | LE1 LI0 Br0.1 | life 4 | size const 15.3 | tr 1.00..0.90 vis 0.50-0.50 ->1.00 | spd 0.00064 | FacingCamera | locked | RATE 1 (continuous)
E Lens           | tex 14128174572 (M  Flare3) | col #BF9670 | LE1 LI0 Br0.02 | life 4 | size grow 0->15.3 | tr 1.00..0.60 vis 0.50-0.50 ->1.00 | spd 0.00064 | FacingCamera | locked | RATE 1 (continuous)
E Glow_2         | tex 13712004045 (A  Glow) | col #D2A39E | LE1 LI0 Br0.1 | life 4 | size const 22.9 | tr 1.00..0.90 vis 0.50-0.50 ->1.00 | spd 0.00064 | FacingCamera | locked | RATE 1 (continuous)
E Glow           | tex 13712004045 (A  Glow) | col #CEA278->#FFC481 | LE1 LI0 Br0.1 | life 4 | size const 15.3 | tr 1.00..0.90 vis 0.50-0.50 ->1.00 | spd 0.00064 | FacingCamera | locked | RATE 1 (continuous)
E Glow           | tex 1075864321 (M  glow) | col #5E4D42 | LE1 LI0 Br0.1 | life 4 | size grow 0->16.8 | tr 1.00..0.86 vis 0.50-0.50 ->1.00 | spd 0.0007 | FacingCamera | locked | RATE 2 (continuous) | z 0.001
E Fog            | tex 16924329976 | col #CEB299->#FFB981 | LE1 LI0 Br0.15 | life 4 | size grow 0->15.3 | tr 1.00..0.80 vis 0.50-0.50 ->1.00 | spd 0.00064 | FacingCamera | flip Grid8x8 Loop 0 | locked | RATE 1 (continuous)
E Flare_2        | tex 18684571895 | col #CEA278->#FFC481 | LE1 LI0 Br0.6 | life 4 | size grow 0->15.3 | tr 1.00..0.80 vis 0.50-0.50 ->1.00 | spd 0.00064 | FacingCamera | locked | RATE 1 (continuous)
E Flare          | tex 18684571895 | col #CEA278->#FFC481 | LE1 LI0 Br0.15 | life 4 | size const 15.3 | tr 1.00..0.60 vis 0.50-0.50 ->1.00 | spd 0.00064 | FacingCamera | locked | RATE 1 (continuous)
E Flare          | tex 95755389807942 | col #CEA278->#FFC481 | LE1 LI0 Br0.15 | life 4 | size const 38.7 | tr 1.00..0.96 vis 0.49-0.49 ->1.00 | spd 0.00161 | FacingCamera | locked | RATE 1 (continuous)
E Flare          | tex 122259936757749 | col #CEA278->#FFC481 | LE1 LI0 Br0.05 | life 4 | size const 42 | tr 1.00..0.86 vis 0.49-0.49 ->1.00 | spd 0.00215 | FacingCamera | locked | RATE 1 (continuous)
E Detail_3       | tex 11037539631 | col #CEB299->#FFB481 | LE1 LI0 Br0.01 | life 4 | size const 12 | tr 1.00..0.90 vis 0.50-0.50 ->1.00 | spd 0.00064 | FacingCamera | locked | RATE 2 (continuous)
E Detail_3       | tex 11037539631 | col #CEB299->#FFB481 | LE1 LI0 Br0.1 | life 4 | size const 8 | tr 1.00..0.90 vis 0.50-0.50 ->1.00 | spd 0.00064 | FacingCamera | locked | RATE 2 (continuous)
E Detail_2       | tex 18887369317 (A  Crescent11) | col #CEB299->#FFB481 | LE1 LI0 Br0.15 | life 4 | size const 10.2 | tr 1.00..0.90 vis 0.50-0.50 ->1.00 | spd 0.00064 | FacingCamera | locked | RATE 2 (continuous)
E Detail         | tex 836060185 | col #CEA278->#FFC481 | LE1 LI0 Br2.25 | life 4 | size grow 0->12.8 | tr 1.00..0.80 vis 0.50-0.50 ->1.00 | spd 0.00064 spread 360 | VelocityParallel | locked | RATE 4 (continuous)
E Debris_2       | tex 15501811581 | col #CEA278->#FFC481 | LE1 LI0 Br15 | life 8 | size shrink 0.0255->0 | tr 1.00..0.00 vis 0.50-0.50 ->1.00 | spd 1.27-2.55 spread 180 | FacingCamera | locked | RATE 144 (continuous)
E Debris         | tex 13712004045 (A  Glow) | col #CEA278->#FFC481 | LE1 LI0 Br0.5 | life 8 | size shrink 0.255->0 | tr 1.00..0.80 vis 0.50-0.50 ->1.00 | spd 1.27-2.55 spread 180 | FacingCamera | locked | RATE 8 (continuous)
E Contrast       | tex 1075864321 (M  glow) | col #CEA278->#FFC481 | LE0.55 LI0 Br0 | life 4 | size grow 0->15.3 | tr 1.00..0.86 vis 0.50-0.50 ->1.00 | spd 0.00064 | FacingCamera | locked | RATE 6 (continuous) | z -0.001
E Burst_Cont     | tex 15333819074 (M Grid4x4 Smokey) | col #CEA278->#FFC481 | LE0.4 LI0 Br0 | life 4 | size grow 0->15.3 | tr 1.00..0.86 vis 0.50-0.50 ->1.00 | spd 0.00064 | FacingCamera | flip Grid4x4 Loop 0 | locked | RATE 6 (continuous) | z -0.002
E Burst          | tex 12906276200 (M Grid4x4 Thin realist) | col #CEA278->#FFC481 | LE1 LI0 Br0.4 | life 4 | size grow 0->15.3 | tr 1.00..0.90 vis 0.50-0.50 ->1.00 | spd 0.00064 | FacingCamera | flip Grid4x4 Loop 0 | locked | RATE 4 (continuous)
S Script Movement len351 flags=anim,tween
```
