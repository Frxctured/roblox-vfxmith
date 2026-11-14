# 53baa9dda18d: lightningburst.rbxl :: ReplicatedStorage/Assets/IntCharge

- Category: **aura**; tags: aura, flash, lightning
- Layers: 14 emitters, 0 beams, 0 trails, 0 mesh parts, 0 lights; estimated length 0.25 s
- Fired by: EmitCount attributes
- Pack file: `190 OS (Oct 2024-Mar 2026)/lightningburst.rbxl` (instance referent 696). Watch it in Studio: `kit/scripts/rbxcut.py --id 53baa9dda18d --studio`, then `P.load("fx_53baa9dda18d")` (needs the pack: `kit/scripts/get_pack.py`)
- Frames: none captured yet (play it with kit/studio/VFXLibPlayer.luau)

## Layers (one line each, in firing order; E emitter, B beam, T trail, P part, S script)
```
E Charge         | tex 13390196434 (D Grid4x4 moving light) | col #FFF697 | LE1 LI0 Br6 | life 0.05-0.1 | size swell 0->1.69@0.46->0 | tr flat 0.00 | spd 100 drag 3 | VelocityParallel/Sphere | squash const 1 | flip Grid4x4 OneShot 1 | EMIT 99 @0 | z -1
E Charge         | tex 8030734851 (M  ParticleEmit) | col #FFF697 | LE1 LI0 Br6 | life 0.05-0.1 | size swell 0->1.69@0.46->0 | tr flat 0.00 | spd 100 drag 3 | VelocityParallel/Sphere | squash const 0.5 | EMIT 99 @0 | z -1
E Charge         | tex 8030734851 (M  ParticleEmit) | col #A0BCFF | LE1 LI0 Br6 | life 0.05-0.1 | size swell 0->1.69@0.46->0 | tr flat 0.00 | spd 100 drag 3 | VelocityParallel/Sphere | squash const 0.5 | EMIT 99 @0 | z -1
E lightning      | tex 13771592635 | col #B5D5FF | LE0.3 LI0 Br10 | life 0.15-0.25 | size grow 0->2.19 | tr flat 0.00 | spd 0.01 drag 6.76 spread 360 | VelocityParallel | squash const 2 | flip Grid4x4 OneShot 1 | EMIT 15 @0 | z 1.6
E lightning      | tex 13771592635 | col #FFA245 | LE0.3 LI0 Br10 | life 0.15-0.25 | size grow 0->2.19 | tr flat 0.00 | spd 0.01 drag 6.76 spread 360 | VelocityParallel | squash const 1 | flip Grid4x4 OneShot 1 | EMIT 15 @0 | z 1.6
E lightning      | tex 13771592635 | col #FFF3B7 | LE0.3 LI0 Br10 | life 0.15-0.25 | size grow 0->2.19 | tr flat 0.00 | spd 0.01 drag 6.76 spread 360 | VelocityParallel | squash const 2 | flip Grid4x4 OneShot 1 | EMIT 15 @0 | z 1.6
E moving lightni | tex 13390196434 (D Grid4x4 moving light) | col #FDFFA2 | LE1 LI0 Br50 | life 0.15-0.25 | size grow 0->2.19 | tr 0.00..0.00 vis 0.00-1.00 ->0.00 | spd 0.01 drag 7 spread 360 | FacingCamera | squash const 2 | flip Grid4x4 OneShot 30 | EMIT 7 @0 | z 1.7
E moving lightni | tex 13390196434 (D Grid4x4 moving light) | col #FFA245 | LE0 LI0 Br8 | life 0.15-0.25 | size grow 0->2.19 | tr 0.00..0.00 vis 0.00-1.00 ->0.00 | spd 0.01 drag 7 spread 360 | FacingCamera | squash const 1 | flip Grid4x4 OneShot 30 | EMIT 7 @0 | z 1.7
E moving lightni | tex 13390196434 (D Grid4x4 moving light) | col #B5D5FF | LE0 LI0 Br8 | life 0.15-0.25 | size grow 0->2.19 | tr 0.00..0.00 vis 0.00-1.00 ->0.00 | spd 0.01 drag 7 spread 360 | FacingCamera | squash const 2 | flip Grid4x4 OneShot 30 | EMIT 7 @0 | z 1.7
E ToonLightning  | tex 11861733639 (M Grid4x4 ToonLightnin) | col #FFA245 | LE0.3 LI0 Br7 | life 0.15-0.25 | size grow 0->2.19 | tr flat 0.00 | spd 0.01 drag 7 spread 360 | FacingCamera | squash const 1 | flip Grid4x4 OneShot 32 | EMIT 7 @0 | z 1.7
E ToonLightning  | tex 11861733639 (M Grid4x4 ToonLightnin) | col #B5D5FF | LE0.3 LI0 Br7 | life 0.15-0.25 | size grow 0->2.19 | tr flat 0.00 | spd 0.01 drag 7 spread 360 | FacingCamera | squash const 2 | flip Grid4x4 OneShot 32 | EMIT 7 @0 | z 1.7
E ToonLightning  | tex 11861733639 (M Grid4x4 ToonLightnin) | col #FFFAAF | LE5 LI0 Br500 | life 0.15-0.25 | size grow 0->2.19 | tr flat 0.00 | spd 0.01 drag 7 spread 360 | FacingCamera | squash const 2 | flip Grid4x4 OneShot 32 | EMIT 7 @0 | z 1.7
E Sparkflipx2    | tex 13997926164 (D Grid4x4 Sparkflipx2) | col #FFE1B2 | LE0 LI0 Br4 | life 0.165-0.214 | size grow 0->2.19 | tr flat 0.00 | spd 7.66-15.3 drag 6.76 spread 360 | VelocityParallel | squash const 0.15 | flip Grid4x4 OneShot 1 | EMIT 13 @0 | z 1.65
E Sparkflipx2    | tex 13997926164 (D Grid4x4 Sparkflipx2) | col #AECEFF | LE0 LI0 Br4 | life 0.165-0.214 | size grow 0->2.19 | tr flat 0.00 | spd 7.66-15.3 drag 6.76 spread 360 | VelocityParallel | squash const 0.15 | flip Grid4x4 OneShot 1 | EMIT 13 @0 | z 1.65
```
