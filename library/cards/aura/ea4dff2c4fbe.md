# ea4dff2c4fbe: Curseenergy.rbxm :: Cursed Energys

- Category: **aura**; tags: aura, dark, flash
- Layers: 56 emitters, 0 beams, 0 trails, 0 mesh parts, 0 lights; estimated length 3.0 s
- Fired by: EmitCount attributes
- Pack file: `190 OS (Oct 2024-Mar 2026)/Curseenergy.rbxm` (instance referent 0). Watch it in Studio: `kit/scripts/rbxcut.py --id ea4dff2c4fbe --studio`, then `P.load("fx_ea4dff2c4fbe")` (needs the pack: `kit/scripts/get_pack.py`)
- Frames: none captured yet (play it with kit/studio/VFXLibPlayer.luau)

## Layers (one line each, in firing order; E emitter, B beam, T trail, P part, S script)
```
E Specs2         | tex 16718637336 | col #550000 | LE-2 LI0 Br20 | life 0.6-1 | size grow 0->1.88 | tr flat 0.00 | spd 12-23.9 drag 8 spread -360-360 | FacingCamera | flip Grid4x4 OneShot 350 | EMIT 7 @0 | z -2 | attrs {"EmitType": "attribute"}
E Specs2         | tex 16718600215 | col #550000 | LE0 LI0 Br1 | life 1-2 | size swell 0->0.438@0.18->0 | tr flat 0.00 | spd 16.3-21.2 drag 5 spread -360-360 acc 0-7.97-0 rotSpd -350-350 | FacingCamera | flip Grid4x4 OneShot 350 | EMIT 15 @0 | z -2 | attrs {"EmitType": "attribute"}
E Somethin       | tex 16708254985 | col #000000 | LE0.8 LI0 Br25 | life 1 | size const 4.63 | tr flat 0.00 | spd 2.89 drag 6 | FacingCameraWorldUp | squash const 0.2 | flip Grid4x4 OneShot 12 | locked | EMIT 1 @0 | z 1.8
E Glow           | tex 10672228547 (A  Specs2) | col #AA0000->#900000->#550000 | LE1 LI0 Br4 | life 1 | size const 6.48 | tr 1.00..0.73 vis 0.41-0.41 ->1.00 | spd 0.00211 | FacingCamera | squash const 0.4 | locked | RATE 2 (continuous) | z 5
E AuraSpirit     | tex 16664027302 | col #550000->#000000 | LE1 LI0 Br5 | life 1 | size const 10 | tr 1.00..0.25 vis 0.38-0.38 ->1.00 | spd 0.00394 | FacingCameraWorldUp | squash const -0.4 | flip Grid4x4 Loop 15 | locked | EMIT 1 @0
E Aura1          | tex 16664027302 | col #000000 | LE-1 LI0 Br12 | life 1 | size const 9.05 | tr 1.00..0.25 vis 0.38-0.38 ->1.00 | spd 0.00438 | FacingCameraWorldUp | squash grow 0->0.115 | flip Grid4x4 Loop 15 | locked | EMIT 1 @0 | z -0.1
E ParticleEmitte | tex 16291157604 | col #550000 | LE0 LI0 Br15 | life 1 | size const 3 | tr flat 0.80 | spd 4 | FacingCamera | flip Grid4x4 Loop 60 | RATE 30 (continuous) | z -3
E ParticleEmitte | tex 16198380472 | col #550000 | LE0 LI0 Br15 | life 1 | size const 3 | tr flat 0.50 | spd 4 | FacingCamera | flip Grid4x4 Loop 30 | RATE 5 (continuous) | z -3
E Specs1         | tex 12362610761 | col #550000 | LE-1 LI0 Br10 | life 1.5-3 | size shrink 0.357->0 | tr flat 0.00 | spd 13.3-26.6 drag 6 spread 360 acc 0-13.3-0 rotSpd -30-30 | FacingCamera | EMIT 10 @0 | z -2
E CursedEnergy   | tex 16195810711 | col #AA0000 | LE0.6 LI0 Br2 | life 0.3-1.3 | size const 5.54 | tr 1.00..0.29 vis 0.28-0.43 ->1.00 | spd 0.00509 | FacingCamera | squash const -0.1 | flip Grid4x4 Loop 15 | locked | EMIT 1 @0 | z 0.3
E Aura1          | tex 16664027302 | col #000000 | LE-1 LI0 Br12 | life 1 | size const 9.05 | tr 1.00..0.25 vis 0.38-0.38 ->1.00 | spd 0.00438 | FacingCamera | squash grow 0->0.115 | flip Grid4x4 Loop 15 | locked | EMIT 1 @0 | z -0.1
E AuraSpirit     | tex 16664027302 | col #FFAAFF->#000000 | LE1 LI0 Br5 | life 1 | size const 10 | tr 1.00..0.25 vis 0.38-0.38 ->1.00 | spd 0.00394 | FacingCamera | squash const -0.4 | flip Grid4x4 Loop 15 | locked | EMIT 1 @0 | z 0.7
E Glow           | tex 10672228547 (A  Specs2) | col #FF00FF->#FF55FF->#FFAAFF | LE1 LI0 Br4 | life 1 | size const 6.48 | tr 1.00..0.73 vis 0.41-0.41 ->1.00 | spd 0.00211 | FacingCamera | squash const 0.4 | locked | RATE 2 (continuous) | z 5
E Specs2         | tex 16718637336 | col #FF55FF | LE-2 LI0 Br20 | life 0.6-1 | size grow 0->1.88 | tr flat 0.00 | spd 12-23.9 drag 8 spread -360-360 | FacingCamera | flip Grid4x4 OneShot 350 | EMIT 7 @0 | z -2 | attrs {"EmitType": "attribute"}
E Specs2         | tex 16718600215 | col #FF55FF | LE0 LI0 Br1 | life 1-2 | size swell 0->0.438@0.18->0 | tr flat 0.00 | spd 16.3-21.2 drag 5 spread -360-360 acc 0-7.97-0 rotSpd -350-350 | FacingCamera | flip Grid4x4 OneShot 350 | EMIT 15 @0 | z -2 | attrs {"EmitType": "attribute"}
E Somethin       | tex 16708254985 | col #000000 | LE0.8 LI0 Br25 | life 1 | size const 4.63 | tr flat 0.00 | spd 2.89 drag 6 | FacingCameraWorldUp | squash const 0.2 | flip Grid4x4 OneShot 12 | locked | EMIT 1 @0 | z 1.8
E ParticleEmitte | tex 16291157604 | col #FF55FF | LE0 LI0 Br15 | life 1 | size const 3 | tr flat 0.80 | spd 4 | FacingCamera | flip Grid4x4 Loop 60 | RATE 30 (continuous) | z -3
E ParticleEmitte | tex 16198380472 | col #FF55FF | LE0 LI0 Br15 | life 1 | size const 3 | tr flat 0.50 | spd 4 | FacingCamera | flip Grid4x4 Loop 30 | RATE 5 (continuous) | z -3
E Specs1         | tex 12362610761 | col #FF55FF | LE-1 LI0 Br10 | life 1.5-3 | size shrink 0.357->0 | tr flat 0.00 | spd 13.3-26.6 drag 6 spread 360 acc 0-13.3-0 rotSpd -30-30 | FacingCamera | EMIT 10 @0 | z -2
E CursedEnergy   | tex 16195810711 | col #8F5F8F | LE0.6 LI0 Br2 | life 0.3-1.3 | size const 5.54 | tr 1.00..0.29 vis 0.28-0.43 ->1.00 | spd 0.00509 | FacingCamera | squash const -0.1 | flip Grid4x4 Loop 15 | locked | EMIT 1 @0 | z 2.1
E AuraSpirit     | tex 16664027302 | col #55007F->#000000 | LE1 LI0 Br5 | life 1 | size const 10 | tr 1.00..0.25 vis 0.38-0.38 ->1.00 | spd 0.00394 | FacingCamera | squash const -0.4 | flip Grid4x4 Loop 15 | locked | EMIT 1 @0 | z 0.7
E Glow           | tex 10672228547 (A  Specs2) | col #5500FF->#5317CC->#55007F | LE1 LI0 Br4 | life 1 | size const 6.48 | tr 1.00..0.73 vis 0.41-0.41 ->1.00 | spd 0.00211 | FacingCamera | squash const 0.4 | locked | RATE 2 (continuous) | z 5
E Specs2         | tex 16718637336 | col #360051 | LE-2 LI0 Br20 | life 0.6-1 | size grow 0->1.88 | tr flat 0.00 | spd 12-23.9 drag 8 spread -360-360 | FacingCamera | flip Grid4x4 OneShot 350 | EMIT 7 @0 | z -2 | attrs {"EmitType": "attribute"}
E Specs2         | tex 16718600215 | col #55007F | LE0 LI0 Br1 | life 1-2 | size swell 0->0.438@0.18->0 | tr flat 0.00 | spd 16.3-21.2 drag 5 spread -360-360 acc 0-7.97-0 rotSpd -350-350 | FacingCamera | flip Grid4x4 OneShot 350 | EMIT 15 @0 | z -2 | attrs {"EmitType": "attribute"}
E Somethin       | tex 16708254985 | col #000000 | LE0.8 LI0 Br25 | life 1 | size const 4.63 | tr flat 0.00 | spd 2.89 drag 6 | FacingCameraWorldUp | squash const 0.2 | flip Grid4x4 OneShot 12 | locked | EMIT 1 @0 | z 1.8
E Aura1          | tex 16664027302 | col #000000 | LE-1 LI0 Br12 | life 1 | size const 9.05 | tr 1.00..0.25 vis 0.38-0.38 ->1.00 | spd 0.00438 | FacingCameraWorldUp | squash grow 0->0.115 | flip Grid4x4 Loop 15 | locked | EMIT 1 @0 | z -0.1
E ParticleEmitte | tex 16291157604 | col #55007F | LE0 LI0 Br15 | life 1 | size const 3 | tr flat 0.80 | spd 4 | FacingCamera | flip Grid4x4 Loop 60 | RATE 30 (continuous) | z -3
E ParticleEmitte | tex 16198380472 | col #55007F | LE0 LI0 Br15 | life 1 | size const 3 | tr flat 0.50 | spd 4 | FacingCamera | flip Grid4x4 Loop 30 | RATE 5 (continuous) | z -3
E Specs1         | tex 12362610761 | col #55007F | LE-1 LI0 Br10 | life 1.5-3 | size shrink 0.357->0 | tr flat 0.00 | spd 13.3-26.6 drag 6 spread 360 acc 0-13.3-0 rotSpd -30-30 | FacingCamera | EMIT 10 @0 | z -2
E CursedEnergy   | tex 16195810711 | col #7000A8 | LE0.6 LI0 Br2 | life 0.3-1.3 | size const 5.54 | tr 1.00..0.29 vis 0.28-0.43 ->1.00 | spd 0.00509 | FacingCamera | squash const -0.1 | flip Grid4x4 Loop 15 | locked | EMIT 1 @0 | z 0.3
E AuraSpirit     | tex 16664027302 | col #55AA7F->#000000 | LE1 LI0 Br5 | life 1 | size const 10 | tr 1.00..0.25 vis 0.38-0.38 ->1.00 | spd 0.00394 | FacingCamera | squash const -0.4 | flip Grid4x4 Loop 15 | locked | EMIT 1 @0 | z 0.7
E Glow           | tex 10672228547 (A  Specs2) | col #55FF7F->#55AA7F->#2EFFEE | LE1 LI0 Br4 | life 1 | size const 6.48 | tr 1.00..0.73 vis 0.41-0.41 ->1.00 | spd 0.00211 | FacingCamera | squash const 0.4 | locked | RATE 2 (continuous) | z 5
E Specs2         | tex 16718637336 | col #55AA7F | LE-2 LI0 Br20 | life 0.6-1 | size grow 0->1.88 | tr flat 0.00 | spd 12-23.9 drag 8 spread -360-360 | FacingCamera | flip Grid4x4 OneShot 350 | EMIT 7 @0 | z -2 | attrs {"EmitType": "attribute"}
E Specs2         | tex 16718600215 | col #55AA7F | LE0 LI0 Br1 | life 1-2 | size swell 0->0.438@0.18->0 | tr flat 0.00 | spd 16.3-21.2 drag 5 spread -360-360 acc 0-7.97-0 rotSpd -350-350 | FacingCamera | flip Grid4x4 OneShot 350 | EMIT 15 @0 | z -2 | attrs {"EmitType": "attribute"}
E Somethin       | tex 16708254985 | col #000000 | LE0.8 LI0 Br25 | life 1 | size const 4.63 | tr flat 0.00 | spd 2.89 drag 6 | FacingCameraWorldUp | squash const 0.2 | flip Grid4x4 OneShot 12 | locked | EMIT 1 @0 | z 1.8
E Aura1          | tex 16664027302 | col #000000 | LE-1 LI0 Br12 | life 1 | size const 9.05 | tr 1.00..0.25 vis 0.38-0.38 ->1.00 | spd 0.00438 | FacingCameraWorldUp | squash grow 0->0.115 | flip Grid4x4 Loop 15 | locked | EMIT 1 @0 | z -0.1
E ParticleEmitte | tex 16291157604 | col #55AA7F | LE0 LI0 Br15 | life 1 | size const 3 | tr flat 0.80 | spd 4 | FacingCamera | flip Grid4x4 Loop 60 | RATE 30 (continuous) | z -3
E ParticleEmitte | tex 16198380472 | col #55AA7F | LE0 LI0 Br15 | life 1 | size const 3 | tr flat 0.50 | spd 4 | FacingCamera | flip Grid4x4 Loop 30 | RATE 5 (continuous) | z -3
E Specs1         | tex 12362610761 | col #55AA7F | LE-1 LI0 Br10 | life 1.5-3 | size shrink 0.357->0 | tr flat 0.00 | spd 13.3-26.6 drag 6 spread 360 acc 0-13.3-0 rotSpd -30-30 | FacingCamera | EMIT 10 @0 | z -2
E CursedEnergy   | tex 16195810711 | col #55FF7F | LE0.6 LI0 Br2 | life 0.3-1.3 | size const 5.54 | tr 1.00..0.29 vis 0.28-0.43 ->1.00 | spd 0.00509 | FacingCamera | squash const -0.1 | flip Grid4x4 Loop 15 | locked | EMIT 1 @0 | z 0.3
E AuraSpirit     | tex 16664027302 | col #4672C3->#000000 | LE1 LI0 Br5 | life 1 | size const 10 | tr 1.00..0.25 vis 0.38-0.38 ->1.00 | spd 0.00394 | FacingCamera | squash const -0.4 | flip Grid4x4 Loop 15 | locked | EMIT 1 @0 | z 0.7
E Glow           | tex 10672228547 (A  Specs2) | col #349DFF->#32BBFA->#2EFFEE | LE1 LI0 Br4 | life 1 | size const 6.48 | tr 1.00..0.73 vis 0.41-0.41 ->1.00 | spd 0.00211 | FacingCamera | squash const 0.4 | locked | RATE 2 (continuous) | z 5
E Specs2         | tex 16718637336 | col #27BBFF | LE-2 LI0 Br20 | life 0.6-1 | size grow 0->1.88 | tr flat 0.00 | spd 12-23.9 drag 8 spread -360-360 | FacingCamera | flip Grid4x4 OneShot 350 | EMIT 7 @0 | z -2 | attrs {"EmitType": "attribute"}
E Specs2         | tex 16718600215 | col #3C8FC3 | LE0 LI0 Br1 | life 1-2 | size swell 0->0.438@0.18->0 | tr flat 0.00 | spd 16.3-21.2 drag 5 spread -360-360 acc 0-7.97-0 rotSpd -350-350 | FacingCamera | flip Grid4x4 OneShot 350 | EMIT 15 @0 | z -2 | attrs {"EmitType": "attribute"}
E Somethin       | tex 16708254985 | col #000000 | LE0.8 LI0 Br25 | life 1 | size const 4.63 | tr flat 0.00 | spd 2.89 drag 6 | FacingCameraWorldUp | squash const 0.2 | flip Grid4x4 OneShot 12 | locked | EMIT 1 @0 | z 1.8
E Aura1          | tex 16664027302 | col #000000 | LE-1 LI0 Br12 | life 1 | size const 9.05 | tr 1.00..0.25 vis 0.38-0.38 ->1.00 | spd 0.00438 | FacingCameraWorldUp | squash grow 0->0.115 | flip Grid4x4 Loop 15 | locked | EMIT 1 @0 | z -0.1
E ParticleEmitte | tex 16291157604 | col #27BBFF | LE0 LI0 Br15 | life 1 | size const 3 | tr flat 0.80 | spd 4 | FacingCamera | flip Grid4x4 Loop 60 | RATE 30 (continuous) | z -3
E ParticleEmitte | tex 16198380472 | col #27BBFF | LE0 LI0 Br15 | life 1 | size const 3 | tr flat 0.50 | spd 4 | FacingCamera | flip Grid4x4 Loop 30 | RATE 5 (continuous) | z -3
E Specs1         | tex 12362610761 | col #2E7DC3 | LE-1 LI0 Br10 | life 1.5-3 | size shrink 0.357->0 | tr flat 0.00 | spd 13.3-26.6 drag 6 spread 360 acc 0-13.3-0 rotSpd -30-30 | FacingCamera | EMIT 10 @0 | z -2
E CursedEnergy   | tex 16195810711 | col #2778C3 | LE0.6 LI0 Br2 | life 0.3-1.3 | size const 5.54 | tr 1.00..0.29 vis 0.28-0.43 ->1.00 | spd 0.00509 | FacingCamera | squash const -0.1 | flip Grid4x4 Loop 15 | locked | EMIT 1 @0 | z 0.3
E Specs2         | tex 16718600215 | col #27BBFF | LE0 LI0 Br1 | life 1-2 | size swell 0->0.438@0.18->0 | tr flat 0.00 | spd 16.3-21.2 drag 5 spread -360-360 acc 0-7.97-0 rotSpd -350-350 | FacingCamera | flip Grid4x4 OneShot 350 | EMIT 15 @0 | z -2 | attrs {"EmitType": "attribute"}
E Specs2         | tex 16718637336 | col #3C8FC3 | LE-2 LI0 Br20 | life 0.6-1 | size grow 0->1.88 | tr flat 0.00 | spd 12-23.9 drag 8 spread -360-360 | FacingCamera | flip Grid4x4 OneShot 350 | EMIT 7 @0 | z -2 | attrs {"EmitType": "attribute"}
E Somethin       | tex 16708254985 | col #000000 | LE0.8 LI0 Br25 | life 1 | size const 4.63 | tr flat 0.00 | spd 2.89 drag 6 | FacingCamera | squash const 0.2 | flip Grid4x4 OneShot 12 | locked | EMIT 1 @0 | z 1.8
E Aura1          | tex 16664027302 | col #000000 | LE-1 LI0 Br12 | life 1 | size const 9.05 | tr 1.00..0.25 vis 0.38-0.38 ->1.00 | spd 0.00438 | FacingCamera | squash grow 0->0.115 | flip Grid4x4 Loop 15 | locked | EMIT 1 @0 | z -0.1
E Specs1         | tex 12362610761 | col #2E7DC3 | LE-1 LI0 Br10 | life 1.5-3 | size shrink 0.357->0 | tr flat 0.00 | spd 13.3-26.6 drag 6 spread 360 acc 0-13.3-0 rotSpd -30-30 | FacingCamera | EMIT 10 @0 | z -2
E CursedEnergy   | tex 16195810711 | col #2778C3 | LE0.6 LI0 Br2 | life 0.3-1.3 | size const 5.54 | tr 1.00..0.29 vis 0.28-0.43 ->1.00 | spd 0.00509 | FacingCamera | squash const -0.1 | flip Grid4x4 Loop 15 | locked | EMIT 1 @0 | z 2.1
P {"k": "Part", "name": "Right Leg", "size": [1.0, 2.0, 1.0], "mat": "Plastic", "transp": 0.0}
P {"k": "Part", "name": "Left Leg", "size": [1.0, 2.0, 1.0], "mat": "Plastic", "transp": 0.0}
P {"k": "Part", "name": "Right Arm", "size": [1.0, 2.0, 1.0], "mat": "Plastic", "transp": 0.0}
P {"k": "Part", "name": "Left Arm", "size": [1.0, 2.0, 1.0], "mat": "Plastic", "transp": 0.0}
P {"k": "Part", "name": "Torso", "size": [2.0, 2.0, 1.0], "mat": "Plastic", "transp": 0.0}
P {"k": "Part", "name": "Head", "size": [2.0, 1.0, 1.0], "mat": "Plastic", "transp": 0.0}
P {"k": "Part", "name": "Right Leg", "size": [1.0, 2.0, 1.0], "mat": "Plastic", "transp": 0.0}
P {"k": "Part", "name": "Left Leg", "size": [1.0, 2.0, 1.0], "mat": "Plastic", "transp": 0.0}
P {"k": "Part", "name": "Right Arm", "size": [1.0, 2.0, 1.0], "mat": "Plastic", "transp": 0.0}
P {"k": "Part", "name": "Left Arm", "size": [1.0, 2.0, 1.0], "mat": "Plastic", "transp": 0.0}
P {"k": "Part", "name": "Torso", "size": [2.0, 2.0, 1.0], "mat": "Plastic", "transp": 0.0}
P {"k": "Part", "name": "Head", "size": [2.0, 1.0, 1.0], "mat": "Plastic", "transp": 0.0}
P {"k": "Part", "name": "Right Leg", "size": [1.0, 2.0, 1.0], "mat": "Plastic", "transp": 0.0}
P {"k": "Part", "name": "Left Leg", "size": [1.0, 2.0, 1.0], "mat": "Plastic", "transp": 0.0}
P {"k": "Part", "name": "Right Arm", "size": [1.0, 2.0, 1.0], "mat": "Plastic", "transp": 0.0}
P {"k": "Part", "name": "Left Arm", "size": [1.0, 2.0, 1.0], "mat": "Plastic", "transp": 0.0}
P {"k": "Part", "name": "Torso", "size": [2.0, 2.0, 1.0], "mat": "Plastic", "transp": 0.0}
P {"k": "Part", "name": "Head", "size": [2.0, 1.0, 1.0], "mat": "Plastic", "transp": 0.0}
P {"k": "Part", "name": "Right Leg", "size": [1.0, 2.0, 1.0], "mat": "Plastic", "transp": 0.0}
P {"k": "Part", "name": "Left Leg", "size": [1.0, 2.0, 1.0], "mat": "Plastic", "transp": 0.0}
```
