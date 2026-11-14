# 40cdc6ec6f7c: summon os (ca co).rbxm :: Model

- Category: **beam**; tags: beam
- Layers: 17 emitters, 3 beams, 0 trails, 0 mesh parts, 0 lights; estimated length 10.0 s
- Fired by: saved running (Enabled + Rate)
- Pack file: `Older OS (2025 and older)/Oct 2024 - Jan 2025/summon os (ca co).rbxm` (instance referent 0): cut it into Studio with `kit/scripts/rbxcut.py "<pack>/Older OS (2025 and older)/Oct 2024 - Jan 2025/summon os (ca co).rbxm" --ref 0 --out <studio content>/vfxlib/fx_40cdc6ec6f7c.rbxmx`
- Frames: none captured yet (play it with kit/studio/VFXLibPlayer.luau)

## Layers (one line each, in firing order; E emitter, B beam, T trail, P part, S script)
```
E ParticleEmitte | tex 17050858819 | col #5B1AFF | LE0.65 LI0 Br22 | life 0.15-0.2 | size const 12 | tr flat 0.00 | spd 400-800 | VelocityParallel | squash const 1 | RATE 60 (continuous) | z 1.55
E ParticleEmitte | tex 12942158384 (M  ParticleEmit) | col #FF1014->#5922FF->#641CFF | LE0.45 LI0 Br80 | life 0.3-0.4 | size swell 0->4.06@0.27->0 | tr flat 0.00 | spd 300-450 drag 4 rotSpd -250-250 | FacingCamera | RATE 65 (continuous) | z 1.67
E ParticleEmitte | tex 17062491564 | col #FF1115 | LE0.88 LI0 Br28 | life 0.45-0.6 | size grow 0->1.5 | tr flat 0.00 | spd 0.001 spread -360-360 | FacingCamera | flip Grid4x4 OneShot 1 | RATE 3 (continuous) | z 0.22
E ParticleEmitte | tex 17062491564 | col #5F15FF | LE0.88 LI0 Br22 | life 0.45-0.6 | size grow 0->1.5 | tr flat 0.00 | spd 0.001 spread -360-360 | FacingCamera | flip Grid4x4 OneShot 1 | RATE 3 (continuous) | z 0.2
E ParticleEmitte | tex 17062454366 | col #FFFFFF | LE0 LI1 Br1 | life 5-10 | size const 1 | tr flat 0.00 | spd 5 | FacingCamera | z 0.655
E ParticleEmitte | tex 16879573368 | col #FF1C20 | LE0.25 LI0 Br22 | life 0.4-0.45 | size grow 0->1 | tr flat 0.00 | spd 22-65 drag 6 spread -45-45 | FacingCamera | flip Grid4x4 OneShot 1 | RATE 28 (continuous) | z 0.688
E ParticleEmitte | tex 16879573368 | col #5218FF | LE0.25 LI0 Br22 | life 0.4-0.45 | size grow 0->1 | tr flat 0.00 | spd 22-65 drag 6 spread -45-45 | FacingCamera | flip Grid4x4 OneShot 1 | RATE 28 (continuous) | z 0.655
E ParticleEmitte | tex 12817881196 (M Grid4x4 ParticleEmit) | col #4719FF | LE0.65 LI0 Br45 | life 0.25-0.8 | size grow 0->8 | tr flat 0.00 | spd 0.001 | FacingCamera | flip Grid4x4 OneShot 1 | RATE 4 (continuous) | z 0.55
E ParticleEmitte | tex 12817881196 (M Grid4x4 ParticleEmit) | col #FF1519 | LE0.65 LI0 Br45 | life 0.25-0.8 | size grow 0->8 | tr flat 0.00 | spd 0.001 | FacingCamera | flip Grid4x4 OneShot 1 | RATE 4 (continuous) | z 0.455
E ParticleEmitte | tex 16892258895 | col #FF1014->#4F1AFF | LE0.45 LI0 Br12 | life 0.2-0.22 | size grow 0->12 | tr 1.00..0.58 vis 0.12-0.12 ->1.00 | spd 0.001 spread -360-36 | VelocityPerpendicular | RATE 22 (continuous) | z -0.45
E ParticleEmitte | tex 14762708319 (M Grid4x4 PulseRing) | col #5F15FF->#FF0C10->#5F15FF | LE0.65 LI0 Br22 | life 0.25-0.33 | size grow 0->6.31 | tr flat 0.00 | spd 0.001 | FacingCamera | flip Grid4x4 OneShot 1 | RATE 4 (continuous) | z -1.45
E ParticleEmitte | tex 10803191201 | col #511CFF | LE0.55 LI0 Br6.6 | life 0.6-0.8 | size grow 0->3 | tr 1.00..0.68 vis 0.17-0.17 ->1.00 | spd 12-45 drag 8 spread -360-360 rotSpd -40-40 | FacingCamera | RATE 22 (continuous) | z -2.2
E ParticleEmitte | tex 10803191201 | col #FF1424 | LE0.55 LI0 Br6.6 | life 0.6-0.8 | size grow 0->3 | tr 1.00..0.68 vis 0.17-0.17 ->1.00 | spd 12-45 drag 8 spread -360-360 rotSpd -40-40 | FacingCamera | RATE 22 (continuous) | z -2.1
E ParticleEmitte | tex 17062452122 (M   0.1) | col #FF1519 | LE0.65 LI0 Br45 | life 0.25-0.3 | size swell 0->6.06@0.10->0 | tr flat 0.00 | spd 80-100 drag 80 spread -360-360 | VelocityParallel | RATE 6 (continuous) | z 3.55
E ParticleEmitte | tex 17062452122 (M   0.1) | col #791AFF | LE0.65 LI0 Br45 | life 0.25-0.3 | size swell 0->6.06@0.10->0 | tr flat 0.00 | spd 80-100 drag 60 spread -360-360 | VelocityParallel | RATE 6 (continuous) | z 4
E ParticleEmitte | tex 11518019293 | col #D0181C | LE0.45 LI0 Br22 | life 0.3-0.35 | size grow 0->12 | tr flat 0.00 | spd 0.001 | FacingCamera | flip Grid4x4 OneShot 1 | RATE 6 (continuous) | z -1.55
E ParticleEmitte | tex 11518019293 | col #7119FF | LE0.65 LI0 Br26 | life 0.3-0.35 | size grow 0->8 | tr flat 0.00 | spd 0.001 | FacingCamera | flip Grid4x4 OneShot 1 | RATE 6 (continuous) | z -1.55
B Beam           | tex 14919963322 | col #FF1014 | LE1 LI0 Br22 | w 120-120 curve 0-0 seg 10 face | tr 1.00..0.00 vis 0.19-0.77 ->1.00 | tex Stretch 0.6 spd 4 | z -1.2
B Beam           | tex 15824130839 (A  Beam) | col #FF1519 | LE1 LI0 Br8.8 | w 100-100 curve 0-0 seg 10 face | tr 1.00..0.00 vis 0.22-0.69 ->1.00 | tex Stretch 0.22 spd 2 | z -0.96
B Beam           | tex 15824238175 | col #853EFF | LE1 LI0 Br6.6 | w 100-100 curve 0-0 seg 10 face | tr 1.00..0.00 vis 0.19-0.77 ->1.00 | tex Stretch 0.6 spd 4 | z -1.85
P {"k": "Part", "name": "Right Leg", "size": [1.0, 2.0, 1.0], "mat": "Plastic", "transp": 0.0}
P {"k": "Part", "name": "Left Leg", "size": [1.0, 2.0, 1.0], "mat": "Plastic", "transp": 0.0}
P {"k": "Part", "name": "Right Arm", "size": [1.0, 2.0, 1.0], "mat": "Plastic", "transp": 0.0}
P {"k": "Part", "name": "Left Arm", "size": [1.0, 2.0, 1.0], "mat": "Plastic", "transp": 0.0}
P {"k": "Part", "name": "Torso", "size": [2.0, 2.0, 1.0], "mat": "Plastic", "transp": 0.0}
P {"k": "Part", "name": "Head", "size": [2.0, 1.0, 1.0], "mat": "Plastic", "transp": 0.0}
P {"k": "SpecialMesh", "name": "Mesh", "mesh": 14606419979, "meshTex": 14606288060, "scale": [1.0, 1.0, 1.0]}
P {"k": "Part", "name": "Handle", "size": [1.0, 1.0, 1.0], "mat": "Plastic", "transp": 0.0}
P {"k": "SpecialMesh", "name": "SpecialMesh", "mesh": 18966777670, "meshTex": 18966777769, "scale": [1.0, 1.0, 1.0]}
P {"k": "Part", "name": "Handle", "size": [1.13922, 1.12572, 1.12572], "mat": "Plastic", "transp": 0.0}
P {"k": "SpecialMesh", "name": "SpecialMesh", "mesh": 18650038999, "meshTex": 18650039156, "scale": [1.13961, 1.12572, 1.12572]}
P {"k": "Part", "name": "Handle", "size": [1.0, 1.0, 1.0], "mat": "Plastic", "transp": 0.0}
P {"k": "SpecialMesh", "name": "SpecialMesh", "mesh": 18538734231, "meshTex": 18538739528, "scale": [1.0, 1.0, 1.0]}
P {"k": "Part", "name": "Handle", "size": [0.01, 0.01, 0.01], "mat": "Plastic", "transp": 0.0}
P {"k": "SpecialMesh", "name": "SpecialMesh", "mesh": 17730280802, "meshTex": 17730269535, "scale": [0.01, 0.01, 0.01]}
P {"k": "Part", "name": "Handle", "size": [1.0, 1.0, 1.0], "mat": "Plastic", "transp": 0.0}
P {"k": "SpecialMesh", "name": "SpecialMesh", "mesh": 17224069459, "meshTex": 17224085052, "scale": [1.0, 1.0, 1.0]}
P {"k": "Part", "name": "Handle", "size": [1.0, 1.0, 1.0], "mat": "Plastic", "transp": 0.0}
P {"k": "SpecialMesh", "name": "SpecialMesh", "mesh": 15014438476, "meshTex": 15014443369, "scale": [1.0, 1.0, 1.0]}
P {"k": "Part", "name": "Handle", "size": [1.0, 1.0, 1.0], "mat": "Plastic", "transp": 0.0}
```
