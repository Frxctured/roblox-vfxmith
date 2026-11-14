# fddb7beebc2e: Samurai.rbxl :: ReplicatedFirst/Aura/Fire Awaken

- Category: **aura**; tags: aura, fire
- Layers: 31 emitters, 0 beams, 0 trails, 0 mesh parts, 0 lights; estimated length 0.89 s
- Fired by: EmitCount attributes
- Pack file: `190 OS (Oct 2024-Mar 2026)/Samurai.rbxl` (instance referent 8779): cut it into Studio with `kit/scripts/rbxcut.py "<pack>/190 OS (Oct 2024-Mar 2026)/Samurai.rbxl" --ref 8779 --out <studio content>/vfxlib/fx_fddb7beebc2e.rbxmx`
- Frames: none captured yet (play it with kit/studio/VFXLibPlayer.luau)

## Layers (one line each, in firing order; E emitter, B beam, T trail, P part, S script)
```
E BodyAura       | tex 13816054573 (M  BodyAura) | col #FF2C10 | LE1 LI0 Br5 | life 0.15-0.7 | size grow 0->1.68 | tr 1.00..0.63 vis 0.09-0.09 ->1.00 | spd 2.8-8.4 spread 360 | FacingCamera | locked | EMIT 3 @0 | z -1
E BodyAura       | tex 16745499967 | col #FF871E->#FF2A00 | LE0.25 LI0 Br3 | life 0.32-0.6 | size grow 0->0.821 | tr flat 0.00 | spd 2.8-8.4 drag 8.75 spread 360 acc 0-0.747-0 | FacingCamera/Sphere | flip Grid4x4 OneShot 1.25 | EMIT 1e+03 @0 | z -1
E BodyAura       | tex 14647331432 (A  BodyAura) | col #FF2C10 | LE1 LI0 Br15 | life 0.35-0.885 | size swell 0->1.66@0.08->0 | tr flat 0.00 | spd 2.8-8.4 drag 2 spread 180 | FacingCamera/Disc | EMIT 12 @0 | z -1
E BodyAura       | tex 16785499304 | col #FF2C10 | LE1 LI0 Br12 | life 0.3-0.55 | size const 0.84 | tr flat 0.00 | spd 2.8-8.4 drag 5 spread 180 | FacingCamera | flip Grid4x4 OneShot 32 | EMIT 25 @0 | z -1
E Fire           | tex 17187912415 | col #000000->#7D2A00->#FF5500 | LE0 LI0 Br10 | life 0.25 | size const 6.4 | tr 1.00..0.00 vis 0.05-0.60 ->1.00 | spd 0.008 spread 360--360 | FacingCamera | squash const -0.25 | flip Grid8x8 OneShot 32 | locked | EMIT 1 @0 | z 1.5
E flameaura      | tex 119485017096147 (D Grid8x8 2) | col #FF4F1A | LE0 LI0 Br0 | life 0.35 | size const 8 | tr 1.00..0.00 vis 0.30-0.53 ->1.00 | spd 0.016 | FacingCamera | flip Grid8x8 OneShot 64 | locked | EMIT 1 @0 | z -1.5
E flameaura      | tex 119485017096147 (D Grid8x8 2) | col #FF4F1A | LE1 LI0 Br4.8 | life 0.35 | size const 7 | tr 1.00..0.00 vis 0.30-0.53 ->1.00 | spd 0.016 | FacingCamera | flip Grid8x8 OneShot 64 | locked | EMIT 1 @0 | z -1
E BodyAura       | tex 13816054573 (M  BodyAura) | col #FF2C10 | LE1 LI0 Br5 | life 0.15-0.7 | size grow 0->1.68 | tr 1.00..0.63 vis 0.09-0.09 ->1.00 | spd 2.8-8.4 spread 360 | FacingCamera | locked | EMIT 3 @0 | z -1
E BodyAura       | tex 16745499967 | col #FF871E->#FF2A00 | LE0.25 LI0 Br3 | life 0.32-0.6 | size grow 0->0.821 | tr flat 0.00 | spd 2.8-8.4 drag 8.75 spread 360 acc 0-0.747-0 | FacingCamera/Sphere | flip Grid4x4 OneShot 1.25 | EMIT 1e+03 @0 | z -1
E BodyAura       | tex 14647331432 (A  BodyAura) | col #FF2C10 | LE1 LI0 Br15 | life 0.35-0.885 | size swell 0->1.66@0.08->0 | tr flat 0.00 | spd 2.8-8.4 drag 2 spread 180 | FacingCamera/Disc | EMIT 12 @0 | z -1
E BodyAura       | tex 16785499304 | col #FF2C10 | LE1 LI0 Br12 | life 0.3-0.55 | size const 0.84 | tr flat 0.00 | spd 2.8-8.4 drag 5 spread 180 | FacingCamera | flip Grid4x4 OneShot 32 | EMIT 25 @0 | z -1
E BodyAura       | tex 13816054573 (M  BodyAura) | col #FF2C10 | LE1 LI0 Br5 | life 0.15-0.7 | size grow 0->1.68 | tr 1.00..0.63 vis 0.09-0.09 ->1.00 | spd 2.8-8.4 spread 360 | FacingCamera | locked | EMIT 3 @0 | z -1
E BodyAura       | tex 16745499967 | col #FF871E->#FF2A00 | LE0.25 LI0 Br3 | life 0.32-0.6 | size grow 0->0.821 | tr flat 0.00 | spd 2.8-8.4 drag 8.75 spread 360 acc 0-0.747-0 | FacingCamera/Sphere | flip Grid4x4 OneShot 1.25 | EMIT 1e+03 @0 | z -1
E BodyAura       | tex 14647331432 (A  BodyAura) | col #FF2C10 | LE1 LI0 Br15 | life 0.35-0.885 | size swell 0->1.66@0.08->0 | tr flat 0.00 | spd 2.8-8.4 drag 2 spread 180 | FacingCamera/Disc | EMIT 12 @0 | z -1
E BodyAura       | tex 16785499304 | col #FF2C10 | LE1 LI0 Br12 | life 0.3-0.55 | size const 0.84 | tr flat 0.00 | spd 2.8-8.4 drag 5 spread 180 | FacingCamera | flip Grid4x4 OneShot 32 | EMIT 25 @0 | z -1
E BodyAura       | tex 13816054573 (M  BodyAura) | col #FF2C10 | LE1 LI0 Br5 | life 0.15-0.7 | size grow 0->1.68 | tr 1.00..0.63 vis 0.09-0.09 ->1.00 | spd 2.8-8.4 spread 360 | FacingCamera | locked | EMIT 3 @0 | z -1
E BodyAura       | tex 16745499967 | col #FF871E->#FF2A00 | LE0.25 LI0 Br3 | life 0.32-0.6 | size grow 0->0.821 | tr flat 0.00 | spd 2.8-8.4 drag 8.75 spread 360 acc 0-0.747-0 | FacingCamera/Sphere | flip Grid4x4 OneShot 1.25 | EMIT 1e+03 @0 | z -1
E BodyAura       | tex 14647331432 (A  BodyAura) | col #FF2C10 | LE1 LI0 Br15 | life 0.35-0.885 | size swell 0->1.66@0.08->0 | tr flat 0.00 | spd 2.8-8.4 drag 2 spread 180 | FacingCamera/Disc | EMIT 12 @0 | z -1
E BodyAura       | tex 16785499304 | col #FF2C10 | LE1 LI0 Br12 | life 0.3-0.55 | size const 0.84 | tr flat 0.00 | spd 2.8-8.4 drag 5 spread 180 | FacingCamera | flip Grid4x4 OneShot 32 | EMIT 25 @0 | z -1
E BodyAura       | tex 13816054573 (M  BodyAura) | col #FF2C10 | LE1 LI0 Br5 | life 0.15-0.7 | size grow 0->1.68 | tr 1.00..0.63 vis 0.09-0.09 ->1.00 | spd 2.8-8.4 spread 360 | FacingCamera | locked | EMIT 3 @0 | z -1
E BodyAura       | tex 16745499967 | col #FF871E->#FF2A00 | LE0.25 LI0 Br3 | life 0.32-0.6 | size grow 0->0.821 | tr flat 0.00 | spd 2.8-8.4 drag 8.75 spread 360 acc 0-0.747-0 | FacingCamera/Sphere | flip Grid4x4 OneShot 1.25 | EMIT 1e+03 @0 | z -1
E BodyAura       | tex 14647331432 (A  BodyAura) | col #FF2C10 | LE1 LI0 Br15 | life 0.35-0.885 | size swell 0->1.66@0.08->0 | tr flat 0.00 | spd 2.8-8.4 drag 2 spread 180 | FacingCamera/Disc | EMIT 12 @0 | z -1
E BodyAura       | tex 16785499304 | col #FF2C10 | LE1 LI0 Br12 | life 0.3-0.55 | size const 0.84 | tr flat 0.00 | spd 2.8-8.4 drag 5 spread 180 | FacingCamera | flip Grid4x4 OneShot 32 | EMIT 25 @0 | z -1
E BodyAura       | tex 13816054573 (M  BodyAura) | col #FF2C10 | LE1 LI0 Br5 | life 0.15-0.7 | size grow 0->1.68 | tr 1.00..0.63 vis 0.09-0.09 ->1.00 | spd 2.8-8.4 spread 360 | FacingCamera | locked | EMIT 3 @0 | z -1
E BodyAura       | tex 16745499967 | col #FF871E->#FF2A00 | LE0.25 LI0 Br3 | life 0.32-0.6 | size grow 0->0.821 | tr flat 0.00 | spd 2.8-8.4 drag 8.75 spread 360 acc 0-0.747-0 | FacingCamera/Sphere | flip Grid4x4 OneShot 1.25 | EMIT 1e+03 @0 | z -1
E BodyAura       | tex 14647331432 (A  BodyAura) | col #FF2C10 | LE1 LI0 Br15 | life 0.35-0.885 | size swell 0->1.66@0.08->0 | tr flat 0.00 | spd 2.8-8.4 drag 2 spread 180 | FacingCamera/Disc | EMIT 12 @0 | z -1
E BodyAura       | tex 16785499304 | col #FF2C10 | LE1 LI0 Br12 | life 0.3-0.55 | size const 0.84 | tr flat 0.00 | spd 2.8-8.4 drag 5 spread 180 | FacingCamera | flip Grid4x4 OneShot 32 | EMIT 25 @0 | z -1
E BodyAura       | tex 13816054573 (M  BodyAura) | col #FF2C10 | LE1 LI0 Br5 | life 0.15-0.7 | size grow 0->1.68 | tr 1.00..0.63 vis 0.09-0.09 ->1.00 | spd 2.8-8.4 spread 360 | FacingCamera | locked | EMIT 3 @0 | z -1
E BodyAura       | tex 16745499967 | col #FF871E->#FF2A00 | LE0.25 LI0 Br3 | life 0.32-0.6 | size grow 0->0.821 | tr flat 0.00 | spd 2.8-8.4 drag 8.75 spread 360 acc 0-0.747-0 | FacingCamera/Sphere | flip Grid4x4 OneShot 1.25 | EMIT 1e+03 @0 | z -1
E BodyAura       | tex 14647331432 (A  BodyAura) | col #FF2C10 | LE1 LI0 Br15 | life 0.35-0.885 | size swell 0->1.66@0.08->0 | tr flat 0.00 | spd 2.8-8.4 drag 2 spread 180 | FacingCamera/Disc | EMIT 12 @0 | z -1
E BodyAura       | tex 16785499304 | col #FF2C10 | LE1 LI0 Br12 | life 0.3-0.55 | size const 0.84 | tr flat 0.00 | spd 2.8-8.4 drag 5 spread 180 | FacingCamera | flip Grid4x4 OneShot 32 | EMIT 25 @0 | z -1
P {"k": "Part", "name": "Head", "size": [2.0, 1.0, 1.0], "mat": "Plastic", "transp": 0.0}
P {"k": "Part", "name": "Torso", "size": [2.0, 2.0, 1.0], "mat": "Plastic", "transp": 0.0}
P {"k": "Part", "name": "Left Arm", "size": [1.0, 2.0, 1.0], "mat": "Plastic", "transp": 0.0}
P {"k": "Part", "name": "Right Arm", "size": [1.0, 2.0, 1.0], "mat": "Plastic", "transp": 0.0}
P {"k": "Part", "name": "Left Leg", "size": [1.0, 2.0, 1.0], "mat": "Plastic", "transp": 0.0}
P {"k": "Part", "name": "Right Leg", "size": [1.0, 2.0, 1.0], "mat": "Plastic", "transp": 0.0}
```
