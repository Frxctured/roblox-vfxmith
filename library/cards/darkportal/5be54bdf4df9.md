# 5be54bdf4df9: YujiThings.rbxm :: Divergent_Fist

- Category: **darkportal**; tags: dark, star
- Layers: 13 emitters, 0 beams, 0 trails, 0 mesh parts, 0 lights; estimated length 3.25 s
- Fired by: EmitCount attributes
- Pack file: `2026 OS Jan-April (part 2)/YujiThings.rbxm` (instance referent 167). Watch it in Studio: `kit/scripts/rbxcut.py --id 5be54bdf4df9 --studio`, then `P.load("fx_5be54bdf4df9")` (needs the pack: `kit/scripts/get_pack.py`)
- Frames: none captured yet (play it with kit/studio/VFXLibPlayer.luau)

## Layers (one line each, in firing order; E emitter, B beam, T trail, P part, S script)
```
E ClearBlackEmit | tex 119387723789903 | col #000000 | LE0.75 LI0 Br1 | life 1 | size const 1 | tr flat 0.00 | spd 0 | FacingCamera | squash const 0.1 | flip Grid4x4 OneShot 1 | locked | EMIT 1 @0 for 2 | z 1.25 | attrs {"TimeScale_Duration": 0.1, "TimeScale_End": 1.0, "TimeScale_Start": 1.0}
E EnergyExterior | tex 17551525124 | col #4787FF | LE0.2 LI0 Br0 | life 1 | size grow 0->2 | tr 0.86..0.47 vis 0.39-0.39 ->1.00 | spd 1-3 spread 45 acc 0-1-0 | FacingCamera | flip Grid4x4 OneShot 1 | locked | EMIT 0 @0 for 2 | z 2.3 | attrs {"TimeScale_Duration": 0.1, "TimeScale_End": 1.0, "TimeScale_Start": 1.0}
E EnergyInterior | tex 16867397491 (M Grid4x4 smoksmok) | col #FFFFFF | LE0.2 LI0 Br0 | life 1 | size grow 0->1.34 | tr 0.86..0.23 vis 0.48-0.48 ->1.00 | spd 0.5-1 spread 45 acc 0-1-0 | FacingCamera | flip Grid4x4 OneShot 1 | locked | EMIT 0 @0 for 2 | z 2.3 | attrs {"TimeScale_Duration": 0.1, "TimeScale_End": 1.0, "TimeScale_Start": 1.0}
E EnergyDetail   | tex 101535472799928 (D Grid4x4 wave) | col #FFFFFF | LE0.2 LI0 Br0 | life 0.5-1 | size grow 0->2 | tr 1.00..0.11 vis 0.30-0.30 ->1.00 | spd 3 drag 2 spread 100--1e+03 acc 0-6-0 | VelocityParallel | flip Grid4x4 OneShot 1 | locked | EMIT 0 @0 for 2 | z 2 | attrs {"TimeScale_Duration": 0.1, "TimeScale_End": 1.0, "TimeScale_Start": 1.0}
E FilledEnergy   | tex 11857153748 (D Grid4x4 Stylized Smo) | col #FFFFFF | LE0.2 LI0 Br0 | life 0.5-1 | size grow 0->2 | tr 1.00..0.87 vis 0.38-0.38 ->1.00 | spd 1-2 spread 1e+03--1e+03 acc 0-2-0 | FacingCamera | flip Grid4x4 OneShot 1 | locked | EMIT 0 @0 for 2 | z 2 | attrs {"TimeScale_Duration": 0.1, "TimeScale_End": 1.0, "TimeScale_Start": 1.0}
E EnergyOutline[ | tex 83086555210331 | col #000000 | LE0.5 LI0 Br1 | life 1 | size const 0.9 | tr flat 0.00 | spd 0 | FacingCamera | squash const 0.25 | flip Grid8x8 OneShot 1 | locked | EMIT 1 @0 for 2 | z 1.25 | attrs {"TimeScale_Duration": 0.1, "TimeScale_End": 1.0, "TimeScale_Start": 1.0}
E StarlightSpecs | tex 112699966570961 | col #2194FF | LE1 LI0 Br10 | life 1.25 | size const 1 | tr 1.00..0.00 vis 0.50-0.50 ->1.00 | spd 2 drag 5 | FacingCamera | locked | EMIT 1 @0 for 2 | z 2 | attrs {"TimeScale_Duration": 0.1, "TimeScale_End": 1.0, "TimeScale_Start": 1.0}
E CE_2           | tex 16708557658 (M Grid4x4 ParticleEmit) | col #2194FF | LE1 LI0 Br1 | life 1.25 | size const 0.3 | tr 0.00..0.00 vis 0.00-0.00 ->1.00 | spd 8 drag 6 spread 30 acc 0-2-0 | VelocityParallel | flip Grid4x4 OneShot 1 | locked | EMIT 0 @0 for 2 | z 3 | attrs {"TimeScale_Duration": 0.1, "TimeScale_End": 1.0, "TimeScale_Start": 1.0}
E CE_1           | tex 16708557658 (M Grid4x4 ParticleEmit) | col #2194FF | LE1 LI0 Br1 | life 1.25 | size const 0.3 | tr 0.00..0.00 vis 0.00-0.00 ->1.00 | spd 8 drag 5 spread 40 acc 0-2-0 | VelocityParallel | flip Grid4x4 OneShot 1 | locked | EMIT 0 @0 for 2 | z 3 | attrs {"TimeScale_Duration": 0.1, "TimeScale_End": 1.0, "TimeScale_Start": 1.0}
E DivergentFlare | tex 97371691119032 | col #2194FF | LE1 LI0 Br2 | life 1.25 | size const 2 | tr 1.00..0.69 vis 0.50-0.50 ->1.00 | spd 0.5 | FacingCamera | locked | EMIT 0 @0 for 2 | z 2 | attrs {"TimeScale_Duration": 0.1, "TimeScale_End": 1.0, "TimeScale_Start": 1.0}
E CursedEnergyDe | tex 16708557658 (M Grid4x4 ParticleEmit) | col #2194FF | LE1 LI0 Br1 | life 1.25 | size const 0.3 | tr 0.00..0.00 vis 0.00-0.00 ->1.00 | spd 2 spread 40 acc 0-2-0 | VelocityParallel | flip Grid4x4 OneShot 1 | locked | EMIT 0 @0 for 2 | z 2 | attrs {"TimeScale_Duration": 0.1, "TimeScale_End": 1.0, "TimeScale_Start": 1.0}
E CursedEnergyDe | tex 139606474421066 | col #2194FF | LE1 LI0 Br3 | life 1.25 | size const 2 | tr flat 0.00 | spd 1 spread 30 | VelocityParallel | squash grow 0->0.562 | flip Grid4x4 OneShot 1 | locked | EMIT 0 @0 for 2 | z 2.25 | attrs {"TimeScale_Duration": 0.1, "TimeScale_End": 1.0, "TimeScale_Start": 1.0}
E CursedEnergyDe | tex 76766448449413 | col #2194FF | LE1 LI0 Br3 | life 1 | size shrink 1.06->0 | tr flat 0.00 | spd 5 drag 2 spread 25 | VelocityParallel | flip Grid4x4 OneShot 1 | locked | EMIT 0 @0 for 2 | z 2 | attrs {"TimeScale_Duration": 0.1, "TimeScale_End": 1.0, "TimeScale_Start": 1.0}
```
