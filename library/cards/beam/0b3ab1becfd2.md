# 0b3ab1becfd2: Config Showcase Aura.rbxm ::  

- Category: **beam**; tags: aura, beam, fire, smoke, star
- Layers: 24 emitters, 63 beams, 0 trails, 0 mesh parts, 1 lights; estimated length 1.5 s
- Fired by: saved running (Enabled + Rate)
- Pack file: `Older OS (2025 and older)/Oct 2024 - Jan 2025/Config Showcase Aura.rbxm` (instance referent 0). Watch it in Studio: `kit/scripts/rbxcut.py --id 0b3ab1becfd2 --studio`, then `P.load("fx_0b3ab1becfd2")` (needs the pack: `kit/scripts/get_pack.py`)
- Frames: none captured yet (play it with kit/studio/VFXLibPlayer.luau)

## Layers (one line each, in firing order; E emitter, B beam, T trail, P part, S script)
```
E Smoke45        | tex 16867563190 (M Grid4x4 Smoke45) | col #4750FF->#6B3EFF | LE0 LI0 Br10 | life 0.6-1 | size const 0.8 | tr 1.00..0.90 vis 0.50-0.50 ->1.00 | spd 0-1 drag 2 | FacingCamera | flip Grid4x4 Loop 25 | RATE 100 (continuous) | z 2
E Fire1          | tex 16841991986 | col #4750FF->#6B3EFF | LE0 LI0 Br0 | life 0.6-1 | size shrink 1->0 | tr 1.00..0.00 vis 0.20-1.00 ->0.00 | spd 0-3 drag 2 | FacingCamera | flip Grid4x4 Loop 25 | RATE 100 (continuous) | z -1.1
E Fire1          | tex 16841991986 | col #4750FF->#6B3EFF | LE0 LI0 Br4 | life 0.6-1 | size shrink 0.75->0 | tr 1.00..0.00 vis 0.20-1.00 ->0.00 | spd 0-3 drag 2 | FacingCamera | flip Grid4x4 Loop 25 | RATE 100 (continuous) | z -1
E Smoke32        | tex 16867490141 (M Grid4x4 Smoke) | col #4750FF->#6B3EFF | LE0 LI0 Br5 | life 0.5-1 | size const 4 | tr 1.00..0.80 vis 0.20-0.20 ->1.00 | spd 0 | FacingCamera | flip Grid4x4 OneShot 1 | RATE 60 (continuous) | z -2
E Spec43         | tex 16879847192 (D  spec) | col #4750FF->#6B3EFF | LE0 LI0 Br5 | life 0.3-0.6 | size shrink 0.5->0 | tr 1.00..0.00 vis 0.18-1.00 ->0.00 | spd 2-6 | VelocityParallel | squash grow 0->0.5 | RATE 60 (continuous) | z 2.1
E Spec43         | tex 16879847192 (D  spec) | col #4750FF->#6B3EFF | LE0 LI0 Br5 | life 0.3-0.6 | size shrink 0.5->0 | tr 1.00..0.00 vis 0.18-1.00 ->0.00 | spd 2-6 | VelocityParallel | squash const -1 | RATE 60 (continuous) | z 2
E Fire1          | tex 16841991986 | col #4750FF->#6B3EFF | LE0 LI0 Br0 | life 0.6-1 | size shrink 1->0 | tr 1.00..0.00 vis 0.20-1.00 ->0.00 | spd 0-3 drag 2 | FacingCamera | flip Grid4x4 Loop 25 | RATE 100 (continuous) | z -1.1
E Smoke45        | tex 16867563190 (M Grid4x4 Smoke45) | col #4750FF->#6B3EFF | LE0 LI0 Br10 | life 0.6-1 | size const 0.8 | tr 1.00..0.90 vis 0.50-0.50 ->1.00 | spd 0-1 drag 2 | FacingCamera | flip Grid4x4 Loop 25 | RATE 100 (continuous) | z 2
E Fire1          | tex 16841991986 | col #4750FF->#6B3EFF | LE0 LI0 Br4 | life 0.6-1 | size shrink 0.75->0 | tr 1.00..0.00 vis 0.20-1.00 ->0.00 | spd 0-3 drag 2 | FacingCamera | flip Grid4x4 Loop 25 | RATE 100 (continuous) | z -1
E Fire1          | tex 16841991986 | col #4750FF->#6B3EFF | LE0 LI0 Br0 | life 0.6-1 | size shrink 1->0 | tr 1.00..0.00 vis 0.20-1.00 ->0.00 | spd 0-3 drag 2 | FacingCamera | flip Grid4x4 Loop 25 | RATE 100 (continuous) | z -1.1
E Smoke45        | tex 16867563190 (M Grid4x4 Smoke45) | col #4750FF->#6B3EFF | LE0 LI0 Br10 | life 0.6-1 | size const 0.8 | tr 1.00..0.90 vis 0.50-0.50 ->1.00 | spd 0-1 drag 2 | FacingCamera | flip Grid4x4 Loop 25 | RATE 100 (continuous) | z 2
E Fire1          | tex 16841991986 | col #4750FF->#6B3EFF | LE0 LI0 Br4 | life 0.6-1 | size shrink 0.75->0 | tr 1.00..0.00 vis 0.20-1.00 ->0.00 | spd 0-3 drag 2 | FacingCamera | flip Grid4x4 Loop 25 | RATE 100 (continuous) | z -1
E Fire1          | tex 16841991986 | col #4750FF->#6B3EFF | LE0 LI0 Br0 | life 0.6-1 | size shrink 1->0 | tr 1.00..0.00 vis 0.20-1.00 ->0.00 | spd 0-3 drag 2 | FacingCamera | flip Grid4x4 Loop 25 | RATE 100 (continuous) | z -1.1
E Smoke45        | tex 16867563190 (M Grid4x4 Smoke45) | col #4750FF->#6B3EFF | LE0 LI0 Br10 | life 0.6-1 | size const 0.8 | tr 1.00..0.90 vis 0.50-0.50 ->1.00 | spd 0-1 drag 2 | FacingCamera | flip Grid4x4 Loop 25 | RATE 100 (continuous) | z 2
E Fire1          | tex 16841991986 | col #4750FF->#6B3EFF | LE0 LI0 Br4 | life 0.6-1 | size shrink 0.75->0 | tr 1.00..0.00 vis 0.20-1.00 ->0.00 | spd 0-3 drag 2 | FacingCamera | flip Grid4x4 Loop 25 | RATE 100 (continuous) | z -1
E Fire1          | tex 16841991986 | col #4750FF->#6B3EFF | LE0 LI0 Br0 | life 0.6-1 | size shrink 1->0 | tr 1.00..0.00 vis 0.20-1.00 ->0.00 | spd 0-3 drag 2 | FacingCamera | flip Grid4x4 Loop 25 | RATE 100 (continuous) | z -1.1
E Smoke45        | tex 16867563190 (M Grid4x4 Smoke45) | col #4750FF->#6B3EFF | LE0 LI0 Br10 | life 0.6-1 | size const 0.8 | tr 1.00..0.90 vis 0.50-0.50 ->1.00 | spd 0-1 drag 2 | FacingCamera | flip Grid4x4 Loop 25 | RATE 100 (continuous) | z 2
E Fire1          | tex 16841991986 | col #4750FF->#6B3EFF | LE0 LI0 Br4 | life 0.6-1 | size shrink 0.75->0 | tr 1.00..0.00 vis 0.20-1.00 ->0.00 | spd 0-3 drag 2 | FacingCamera | flip Grid4x4 Loop 25 | RATE 100 (continuous) | z -1
E Circle16       | tex 16878073342 | col #4750FF->#6B3EFF | LE0 LI0 Br2 | life 1-1.5 | size grow 0->10 | tr 1.00..0.89 vis 0.15-0.15 ->1.00 | spd 0.001 acc 0-2-0 rotSpd -50-50 | VelocityPerpendicular | RATE 35 (continuous) | z 0.01
E Circle29       | tex 16878102398 | col #4750FF->#6B3EFF | LE0 LI0 Br6 | life 1.01 | size shrink 5->0 | tr 1.00..0.58 vis 0.17-0.17 ->1.00 | spd 0.001 rotSpd -180 | VelocityPerpendicular | RATE 20 (continuous) | z -0.01
E Circle29       | tex 16878102398 | col #4750FF->#6B3EFF | LE0 LI0 Br5 | life 1.01 | size const 5 | tr flat 0.00 | spd 0.001 rotSpd -180 | VelocityPerpendicular | RATE 2 (continuous)
E Flares12       | tex 86170160520422 (D  Flares12) | col #4750FF->#6B3EFF | LE0 LI0 Br5 | life 0.8-1.3 | size const 4 | tr 1.00..0.84 vis 0.50-0.50 ->1.00 | spd 0.001 rotSpd -50-50 | FacingCamera | RATE 3 (continuous) | z -1
E Rainbow3       | tex 85664013418740 (A  Rainbow3) | col #4750FF->#6B3EFF | LE1 LI0 Br15 | life 1 | size const 4 | tr 1.00..0.00 vis 0.50-0.50 ->1.00 | spd 0.001 | FacingCamera | RATE 2 (continuous) | z 1
E Flare28        | tex 122881636456623 | col #4750FF->#6B3EFF | LE0 LI0 Br6 | life 1 | size const 5 | tr 1.00..0.00 vis 0.50-0.50 ->1.00 | spd 0.001 | VelocityParallel | squash const -1 | RATE 2 (continuous)
B Beam127        | tex 135482100082072 (M  Beam127) | col #4750FF->#6B3EFF | LE0 LI0 Br0.1 | w 1.3-1.65 curve 0-0 seg 10 | tr 1.00..0.00 vis 0.11-0.60 ->1.00 | tex Static 4 spd 0.6 | z -0.05
B Beam11         | tex 16892453445 (M  Beam11) | col #4750FF->#6B3EFF | LE0 LI0 Br0 | w 1.3-1.65 curve 0-0 seg 10 | tr 1.00..0.00 vis 0.11-0.60 ->1.00 | tex Static 4 spd 1 | z -0.02
B Beam11         | tex 16892453445 (M  Beam11) | col #4750FF->#6B3EFF | LE0 LI0 Br5 | w 1.3-1.65 curve 0-0 seg 10 | tr 1.00..0.00 vis 0.11-0.60 ->1.00 | tex Static 3 spd 1.5
B Beam127        | tex 135482100082072 (M  Beam127) | col #4750FF->#6B3EFF | LE0 LI0 Br0.1 | w 1.3-1.65 curve 0-0 seg 10 | tr 1.00..0.00 vis 0.11-0.60 ->1.00 | tex Static 4 spd 0.6 | z -0.05
B Beam11         | tex 16892453445 (M  Beam11) | col #4750FF->#6B3EFF | LE0 LI0 Br0 | w 1.3-1.65 curve 0-0 seg 10 | tr 1.00..0.00 vis 0.11-0.60 ->1.00 | tex Static 4 spd 1 | z -0.02
B Beam11         | tex 16892453445 (M  Beam11) | col #4750FF->#6B3EFF | LE0 LI0 Br5 | w 1.3-1.65 curve 0-0 seg 10 | tr 1.00..0.00 vis 0.11-0.60 ->1.00 | tex Static 3 spd 1.5
B Beam127        | tex 135482100082072 (M  Beam127) | col #4750FF->#6B3EFF | LE0 LI0 Br0.1 | w 1.3-1.65 curve 0-0 seg 10 | tr 1.00..0.00 vis 0.11-0.60 ->1.00 | tex Static 4 spd 0.6 | z -0.05
B Beam11         | tex 16892453445 (M  Beam11) | col #4750FF->#6B3EFF | LE0 LI0 Br0 | w 1.3-1.65 curve 0-0 seg 10 | tr 1.00..0.00 vis 0.11-0.60 ->1.00 | tex Static 4 spd 1 | z -0.02
B Beam11         | tex 16892453445 (M  Beam11) | col #4750FF->#6B3EFF | LE0 LI0 Br5 | w 1.3-1.65 curve 0-0 seg 10 | tr 1.00..0.00 vis 0.11-0.60 ->1.00 | tex Static 3 spd 1.5
B Beam127        | tex 135482100082072 (M  Beam127) | col #4750FF->#6B3EFF | LE0 LI0 Br0.1 | w 1.3-1.65 curve 0-0 seg 10 | tr 1.00..0.00 vis 0.11-0.60 ->1.00 | tex Static 4 spd 0.6 | z -0.05
B Beam11         | tex 16892453445 (M  Beam11) | col #4750FF->#6B3EFF | LE0 LI0 Br0 | w 1.3-1.65 curve 0-0 seg 10 | tr 1.00..0.00 vis 0.11-0.60 ->1.00 | tex Static 4 spd 1 | z -0.02
B Beam11         | tex 16892453445 (M  Beam11) | col #4750FF->#6B3EFF | LE0 LI0 Br5 | w 1.3-1.65 curve 0-0 seg 10 | tr 1.00..0.00 vis 0.11-0.60 ->1.00 | tex Static 3 spd 1.5
B Beam127        | tex 135482100082072 (M  Beam127) | col #4750FF->#6B3EFF | LE0 LI0 Br0.1 | w 1.3-1.65 curve 0-0 seg 10 | tr 1.00..0.00 vis 0.11-0.60 ->1.00 | tex Static 4 spd 0.6 | z -0.05
B Beam11         | tex 16892453445 (M  Beam11) | col #4750FF->#6B3EFF | LE0 LI0 Br0 | w 1.3-1.65 curve 0-0 seg 10 | tr 1.00..0.00 vis 0.11-0.60 ->1.00 | tex Static 4 spd 1 | z -0.02
B Beam11         | tex 16892453445 (M  Beam11) | col #4750FF->#6B3EFF | LE0 LI0 Br5 | w 1.3-1.65 curve 0-0 seg 10 | tr 1.00..0.00 vis 0.11-0.60 ->1.00 | tex Static 3 spd 1.5
B Beam127        | tex 135482100082072 (M  Beam127) | col #4750FF->#6B3EFF | LE0 LI0 Br0.1 | w 1.3-1.65 curve 0-0 seg 10 | tr 1.00..0.00 vis 0.11-0.60 ->1.00 | tex Static 4 spd 0.6 | z -0.05
B Beam11         | tex 16892453445 (M  Beam11) | col #4750FF->#6B3EFF | LE0 LI0 Br0 | w 1.3-1.65 curve 0-0 seg 10 | tr 1.00..0.00 vis 0.11-0.60 ->1.00 | tex Static 4 spd 1 | z -0.02
B Beam11         | tex 16892453445 (M  Beam11) | col #4750FF->#6B3EFF | LE0 LI0 Br5 | w 1.3-1.65 curve 0-0 seg 10 | tr 1.00..0.00 vis 0.11-0.60 ->1.00 | tex Static 3 spd 1.5
B Beam127        | tex 135482100082072 (M  Beam127) | col #4750FF->#6B3EFF | LE0 LI0 Br0.1 | w 1.3-1.65 curve 0-0 seg 10 | tr 1.00..0.00 vis 0.11-0.60 ->1.00 | tex Static 4 spd 0.6 | z -0.05
B Beam11         | tex 16892453445 (M  Beam11) | col #4750FF->#6B3EFF | LE0 LI0 Br0 | w 1.3-1.65 curve 0-0 seg 10 | tr 1.00..0.00 vis 0.11-0.60 ->1.00 | tex Static 4 spd 1 | z -0.02
B Beam11         | tex 16892453445 (M  Beam11) | col #4750FF->#6B3EFF | LE0 LI0 Br5 | w 1.3-1.65 curve 0-0 seg 10 | tr 1.00..0.00 vis 0.11-0.60 ->1.00 | tex Static 3 spd 1.5
B Beam127        | tex 135482100082072 (M  Beam127) | col #4750FF->#6B3EFF | LE0 LI0 Br0.1 | w 1.3-1.65 curve 0-0 seg 10 | tr 1.00..0.00 vis 0.11-0.60 ->1.00 | tex Static 4 spd 0.6 | z -0.05
B Beam11         | tex 16892453445 (M  Beam11) | col #4750FF->#6B3EFF | LE0 LI0 Br0 | w 1.3-1.65 curve 0-0 seg 10 | tr 1.00..0.00 vis 0.11-0.60 ->1.00 | tex Static 4 spd 1 | z -0.02
B Beam11         | tex 16892453445 (M  Beam11) | col #4750FF->#6B3EFF | LE0 LI0 Br5 | w 1.3-1.65 curve 0-0 seg 10 | tr 1.00..0.00 vis 0.11-0.60 ->1.00 | tex Static 3 spd 1.5
B Beam127        | tex 135482100082072 (M  Beam127) | col #4750FF->#6B3EFF | LE0 LI0 Br0.1 | w 1.3-1.65 curve 0-0 seg 10 | tr 1.00..0.00 vis 0.11-0.60 ->1.00 | tex Static 4 spd 0.6 | z -0.05
B Beam11         | tex 16892453445 (M  Beam11) | col #4750FF->#6B3EFF | LE0 LI0 Br0 | w 1.3-1.65 curve 0-0 seg 10 | tr 1.00..0.00 vis 0.11-0.60 ->1.00 | tex Static 4 spd 1 | z -0.02
B Beam11         | tex 16892453445 (M  Beam11) | col #4750FF->#6B3EFF | LE0 LI0 Br5 | w 1.3-1.65 curve 0-0 seg 10 | tr 1.00..0.00 vis 0.11-0.60 ->1.00 | tex Static 3 spd 1.5
B Beam127        | tex 135482100082072 (M  Beam127) | col #4750FF->#6B3EFF | LE0 LI0 Br0.1 | w 1.3-1.65 curve 0-0 seg 10 | tr 1.00..0.00 vis 0.11-0.60 ->1.00 | tex Static 4 spd 0.6 | z -0.05
B Beam11         | tex 16892453445 (M  Beam11) | col #4750FF->#6B3EFF | LE0 LI0 Br0 | w 1.3-1.65 curve 0-0 seg 10 | tr 1.00..0.00 vis 0.11-0.60 ->1.00 | tex Static 4 spd 1 | z -0.02
B Beam11         | tex 16892453445 (M  Beam11) | col #4750FF->#6B3EFF | LE0 LI0 Br5 | w 1.3-1.65 curve 0-0 seg 10 | tr 1.00..0.00 vis 0.11-0.60 ->1.00 | tex Static 3 spd 1.5
B Beam127        | tex 135482100082072 (M  Beam127) | col #4750FF->#6B3EFF | LE0 LI0 Br0.1 | w 1.3-1.65 curve 0-0 seg 10 | tr 1.00..0.00 vis 0.11-0.60 ->1.00 | tex Static 4 spd 0.6 | z -0.05
B Beam11         | tex 16892453445 (M  Beam11) | col #4750FF->#6B3EFF | LE0 LI0 Br0 | w 1.3-1.65 curve 0-0 seg 10 | tr 1.00..0.00 vis 0.11-0.60 ->1.00 | tex Static 4 spd 1 | z -0.02
B Beam11         | tex 16892453445 (M  Beam11) | col #4750FF->#6B3EFF | LE0 LI0 Br5 | w 1.3-1.65 curve 0-0 seg 10 | tr 1.00..0.00 vis 0.11-0.60 ->1.00 | tex Static 3 spd 1.5
B Beam127        | tex 135482100082072 (M  Beam127) | col #4750FF->#6B3EFF | LE0 LI0 Br0.1 | w 1.3-1.65 curve 0-0 seg 10 | tr 1.00..0.00 vis 0.11-0.60 ->1.00 | tex Static 4 spd 0.6 | z -0.05
B Beam11         | tex 16892453445 (M  Beam11) | col #4750FF->#6B3EFF | LE0 LI0 Br0 | w 1.3-1.65 curve 0-0 seg 10 | tr 1.00..0.00 vis 0.11-0.60 ->1.00 | tex Static 4 spd 1 | z -0.02
B Beam11         | tex 16892453445 (M  Beam11) | col #4750FF->#6B3EFF | LE0 LI0 Br5 | w 1.3-1.65 curve 0-0 seg 10 | tr 1.00..0.00 vis 0.11-0.60 ->1.00 | tex Static 3 spd 1.5
B Beam127        | tex 135482100082072 (M  Beam127) | col #4750FF->#6B3EFF | LE0 LI0 Br0.1 | w 1.3-1.65 curve 0-0 seg 10 | tr 1.00..0.00 vis 0.11-0.60 ->1.00 | tex Static 4 spd 0.6 | z -0.05
B Beam11         | tex 16892453445 (M  Beam11) | col #4750FF->#6B3EFF | LE0 LI0 Br0 | w 1.3-1.65 curve 0-0 seg 10 | tr 1.00..0.00 vis 0.11-0.60 ->1.00 | tex Static 4 spd 1 | z -0.02
B Beam11         | tex 16892453445 (M  Beam11) | col #4750FF->#6B3EFF | LE0 LI0 Br5 | w 1.3-1.65 curve 0-0 seg 10 | tr 1.00..0.00 vis 0.11-0.60 ->1.00 | tex Static 3 spd 1.5
B Beam127        | tex 135482100082072 (M  Beam127) | col #4750FF->#6B3EFF | LE0 LI0 Br0.1 | w 1.3-1.65 curve 0-0 seg 10 | tr 1.00..0.00 vis 0.11-0.60 ->1.00 | tex Static 4 spd 0.6 | z -0.05
B Beam11         | tex 16892453445 (M  Beam11) | col #4750FF->#6B3EFF | LE0 LI0 Br0 | w 1.3-1.65 curve 0-0 seg 10 | tr 1.00..0.00 vis 0.11-0.60 ->1.00 | tex Static 4 spd 1 | z -0.02
B Beam11         | tex 16892453445 (M  Beam11) | col #4750FF->#6B3EFF | LE0 LI0 Br5 | w 1.3-1.65 curve 0-0 seg 10 | tr 1.00..0.00 vis 0.11-0.60 ->1.00 | tex Static 3 spd 1.5
B Beam127        | tex 135482100082072 (M  Beam127) | col #4750FF->#6B3EFF | LE0 LI0 Br0.1 | w 1.3-1.65 curve 0-0 seg 10 | tr 1.00..0.00 vis 0.11-0.60 ->1.00 | tex Static 4 spd 0.6 | z -0.05
B Beam11         | tex 16892453445 (M  Beam11) | col #4750FF->#6B3EFF | LE0 LI0 Br0 | w 1.3-1.65 curve 0-0 seg 10 | tr 1.00..0.00 vis 0.11-0.60 ->1.00 | tex Static 4 spd 1 | z -0.02
B Beam11         | tex 16892453445 (M  Beam11) | col #4750FF->#6B3EFF | LE0 LI0 Br5 | w 1.3-1.65 curve 0-0 seg 10 | tr 1.00..0.00 vis 0.11-0.60 ->1.00 | tex Static 3 spd 1.5
B Beam127        | tex 135482100082072 (M  Beam127) | col #4750FF->#6B3EFF | LE0 LI0 Br0.1 | w 1.3-1.65 curve 0-0 seg 10 | tr 1.00..0.00 vis 0.11-0.60 ->1.00 | tex Static 4 spd 0.6 | z -0.05
B Beam11         | tex 16892453445 (M  Beam11) | col #4750FF->#6B3EFF | LE0 LI0 Br0 | w 1.3-1.65 curve 0-0 seg 10 | tr 1.00..0.00 vis 0.11-0.60 ->1.00 | tex Static 4 spd 1 | z -0.02
B Beam11         | tex 16892453445 (M  Beam11) | col #4750FF->#6B3EFF | LE0 LI0 Br5 | w 1.3-1.65 curve 0-0 seg 10 | tr 1.00..0.00 vis 0.11-0.60 ->1.00 | tex Static 3 spd 1.5
B Beam127        | tex 135482100082072 (M  Beam127) | col #4750FF->#6B3EFF | LE0 LI0 Br0.1 | w 1.3-1.65 curve 0-0 seg 10 | tr 1.00..0.00 vis 0.11-0.60 ->1.00 | tex Static 4 spd 0.6 | z -0.05
B Beam11         | tex 16892453445 (M  Beam11) | col #4750FF->#6B3EFF | LE0 LI0 Br0 | w 1.3-1.65 curve 0-0 seg 10 | tr 1.00..0.00 vis 0.11-0.60 ->1.00 | tex Static 4 spd 1 | z -0.02
B Beam11         | tex 16892453445 (M  Beam11) | col #4750FF->#6B3EFF | LE0 LI0 Br5 | w 1.3-1.65 curve 0-0 seg 10 | tr 1.00..0.00 vis 0.11-0.60 ->1.00 | tex Static 3 spd 1.5
B Beam127        | tex 135482100082072 (M  Beam127) | col #4750FF->#6B3EFF | LE0 LI0 Br0.1 | w 1.3-1.65 curve 0-0 seg 10 | tr 1.00..0.00 vis 0.11-0.60 ->1.00 | tex Static 4 spd 0.6 | z -0.05
B Beam11         | tex 16892453445 (M  Beam11) | col #4750FF->#6B3EFF | LE0 LI0 Br0 | w 1.3-1.65 curve 0-0 seg 10 | tr 1.00..0.00 vis 0.11-0.60 ->1.00 | tex Static 4 spd 1 | z -0.02
B Beam11         | tex 16892453445 (M  Beam11) | col #4750FF->#6B3EFF | LE0 LI0 Br5 | w 1.3-1.65 curve 0-0 seg 10 | tr 1.00..0.00 vis 0.11-0.60 ->1.00 | tex Static 3 spd 1.5
B Beam127        | tex 135482100082072 (M  Beam127) | col #4750FF->#6B3EFF | LE0 LI0 Br0.1 | w 1.3-1.65 curve 0-0 seg 10 | tr 1.00..0.00 vis 0.11-0.60 ->1.00 | tex Static 4 spd 0.6 | z -0.05
B Beam11         | tex 16892453445 (M  Beam11) | col #4750FF->#6B3EFF | LE0 LI0 Br0 | w 1.3-1.65 curve 0-0 seg 10 | tr 1.00..0.00 vis 0.11-0.60 ->1.00 | tex Static 4 spd 1 | z -0.02
B Beam11         | tex 16892453445 (M  Beam11) | col #4750FF->#6B3EFF | LE0 LI0 Br5 | w 1.3-1.65 curve 0-0 seg 10 | tr 1.00..0.00 vis 0.11-0.60 ->1.00 | tex Static 3 spd 1.5
B Beam127        | tex 135482100082072 (M  Beam127) | col #4750FF->#6B3EFF | LE0 LI0 Br0.1 | w 1.3-1.65 curve 0-0 seg 10 | tr 1.00..0.00 vis 0.11-0.60 ->1.00 | tex Static 4 spd 0.6 | z -0.05
B Beam11         | tex 16892453445 (M  Beam11) | col #4750FF->#6B3EFF | LE0 LI0 Br0 | w 1.3-1.65 curve 0-0 seg 10 | tr 1.00..0.00 vis 0.11-0.60 ->1.00 | tex Static 4 spd 1 | z -0.02
B Beam11         | tex 16892453445 (M  Beam11) | col #4750FF->#6B3EFF | LE0 LI0 Br5 | w 1.3-1.65 curve 0-0 seg 10 | tr 1.00..0.00 vis 0.11-0.60 ->1.00 | tex Static 3 spd 1.5
B Beam101        | tex 125449362531870 (M  Beam101) | col #4750FF->#6B3EFF | LE0 LI0 Br3 | w 8-8 curve 0-0 seg 10 face | tr 1.00..0.29 vis 0.09-0.09 ->1.00 | tex Static 10 spd 2.5 | z -0.02
B Beam127        | tex 135482100082072 (M  Beam127) | col #4750FF->#6B3EFF | LE0 LI0 Br0 | w 8-10 curve 0-0 seg 10 face | tr 1.00..0.29 vis 0.09-0.09 ->1.00 | tex Static 15 spd 0.4 | z -0.02
B Beam127        | tex 135482100082072 (M  Beam127) | col #4750FF->#6B3EFF | LE0 LI0 Br3 | w 8-10 curve 0-0 seg 10 face | tr 1.00..0.29 vis 0.09-0.09 ->1.00 | tex Static 20 spd 0.5
P {"k": "Part", "name": "Right Arm", "size": [1.0, 2.0, 1.0], "mat": "Plastic", "transp": 0.0}
P {"k": "Part", "name": "Right Leg", "size": [1.0, 2.0, 1.0], "mat": "Plastic", "transp": 0.0}
P {"k": "Part", "name": "Left Leg", "size": [1.0, 2.0, 1.0], "mat": "Plastic", "transp": 0.0}
P {"k": "Part", "name": "Left Arm", "size": [1.0, 2.0, 1.0], "mat": "Plastic", "transp": 0.0}
P {"k": "Part", "name": "Torso", "size": [2.0, 2.0, 1.0], "mat": "Plastic", "transp": 0.0}
P {"k": "Part", "name": "Head", "size": [2.0, 1.0, 1.0], "mat": "Plastic", "transp": 0.0}
S LocalScript Animate len15615 flags=anim,delay
```
