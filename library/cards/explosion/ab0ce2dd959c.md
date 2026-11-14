# ab0ce2dd959c: gogeta.rbxm :: gogeta

- Category: **explosion**; tags: explosion, fire, flash, floor, lightning, portal, projectile, shockwave, star
- Layers: 38 emitters, 0 beams, 0 trails, 0 mesh parts, 1 lights; estimated length 2.0 s
- Fired by: EmitCount attributes
- Pack file: `Older OS (2025 and older)/Oct 2024 - Jan 2025/gogeta.rbxm` (instance referent 0): cut it into Studio with `kit/scripts/rbxcut.py "<pack>/Older OS (2025 and older)/Oct 2024 - Jan 2025/gogeta.rbxm" --ref 0 --out <studio content>/vfxlib/fx_ab0ce2dd959c.rbxmx`
- Frames: none captured yet (play it with kit/studio/VFXLibPlayer.luau)

## Layers (one line each, in firing order; E emitter, B beam, T trail, P part, S script)
```
E specs          | tex 17062452486 (M  Star15) | col #FFFFFF | LE1 LI0 Br4 | life 0.2 | size shrink 0.164->0 | tr 1.00..0.00 vis 0.40-1.00 ->0.00 | spd 8 | FacingCamera/Sphere | locked | EMIT 1 @0
E Star           | tex 11245861328 | col #2C6FFF->#FF7C1E | LE-4 LI0 Br15 | life 0.4-2 | size swell 0->0.856@0.69->0 | tr flat 0.00 | spd 2.6-16 drag 8 spread 100 acc 0-9.79-0 | FacingCamera | EMIT 9 @0 | z 1.65 | attrs {"EmitType": "attribute"}
E tornado13      | tex 15011464541 (M Grid8x8 tornado13) | col #FF5D1D | LE1 LI0 Br21 | life 0.4-0.65 | size shrink 5.36->0 | tr flat 0.00 | spd 0.205 drag 1 spread 10 | VelocityPerpendicular | flip Grid8x8 OneShot 40 | EMIT 0 @0 | attrs {"BaseEmitCount": 0.0, "BaseRate": 5.76}
E tornado14      | tex 15011464541 (M Grid8x8 tornado13) | col #285EFF | LE1 LI0 Br10 | life 0.4-0.65 | size shrink 5.36->0 | tr flat 0.00 | spd 0.205 drag 1 spread 10 | VelocityPerpendicular | flip Grid8x8 OneShot 40 | EMIT 0 @0 | attrs {"BaseEmitCount": 0.0, "BaseRate": 5.76}
E ParticleEmitte | tex 12362600879 | col #EA3F42->#1E938B->#E7414E | LE0.25 LI0 Br3.92 | life 0.45-0.75 | size swell 0->0.35@0.15->0 | tr 0.00..0.00 vis 0.00-0.00 ->0.92 | spd 0 drag 3.5 spread -360-360 acc 0-5-0 rotSpd -360-360 | FacingCamera | EMIT 25 @0 | z 1
E tornado13      | tex 15011464541 (M Grid8x8 tornado13) | col #FF5D1D | LE1 LI0 Br21 | life 0.4-0.65 | size shrink 5.36->0 | tr flat 0.00 | spd 0.205 drag 1 spread 21 | VelocityPerpendicular | flip Grid8x8 OneShot 40 | EMIT 0 @0 | attrs {"BaseEmitCount": 0.0, "BaseRate": 5.76}
E tornado14      | tex 15011464541 (M Grid8x8 tornado13) | col #285EFF | LE1 LI0 Br10 | life 0.4-0.65 | size shrink 5.36->0 | tr flat 0.00 | spd 0.205 drag 1 spread 21 | VelocityPerpendicular | flip Grid8x8 OneShot 40 | EMIT 0 @0 | attrs {"BaseEmitCount": 0.0, "BaseRate": 5.76}
E Star15         | tex 17062452486 (M  Star15) | col #EA3F42->#405DC6->#FFFFFF | LE1 LI0 Br6 | life 0.5-0.75 | size swell 0.164->1.69@0.10->0.1 | tr 0.00..0.00 vis 0.00-0.35 ->1.00 | spd 0.35 | VelocityPerpendicular/Sphere | locked | EMIT 0 @0
E big rays       | tex 8905957078 (M  ParticleEmit) | col #1C3E6B | LE0 LI0 Br15 | life 0.35 | size grow 0->5.75 | tr 0.00..0.00 vis 0.00-0.16 ->1.00 | spd 0.0144 drag 1 spread -360-360 rotSpd -70-70 | VelocityPerpendicular | squash grow 0->0.194 | locked | EMIT 2 @0 | z -0.5
E big rays       | tex 8905957078 (M  ParticleEmit) | col #000000 | LE-1 LI0 Br0 | life 0.1 | size swell 0->7.91@0.18->0 | tr 0.00..0.00 vis 0.00-0.16 ->1.00 | spd 0.0144 drag 1 spread -360-360 rotSpd -70-70 | VelocityPerpendicular | squash grow 0->0.194 | locked | EMIT 15 @0 | z -0.5
E big rays       | tex 8905957078 (M  ParticleEmit) | col #FF7D26 | LE0.15 LI0 Br15 | life 0.35 | size grow 0->5.75 | tr 0.00..0.00 vis 0.00-0.16 ->1.00 | spd 0.0144 drag 1 spread -360-360 rotSpd -70-70 | VelocityPerpendicular | squash grow 0->0.194 | locked | EMIT 2 @0 | z -0.5
E stars          | tex 17569189242 | col #FF831E | LE-1 LI0 Br25 | life 0.29-0.45 | size swell 0->0.648@0.32->0 | tr 1.00..0.00 vis 0.10-0.89 ->1.00 | spd 0.00033-21.8 drag 10 spread 360 rotSpd -360-360 | VelocityParallel | squash const 0.5 | flip Grid8x8 Loop 1 | locked | EMIT 13 @0 | z -0.3
E stars          | tex 17569189242 | col #2C6FFF | LE-1 LI0 Br25 | life 0.29-0.45 | size swell 0->0.648@0.32->0 | tr 1.00..0.00 vis 0.10-0.89 ->1.00 | spd 0.00033-21.8 drag 10 spread 360 rotSpd -360-360 | VelocityParallel | squash const 0.5 | flip Grid8x8 Loop 1 | locked | EMIT 13 @0 | z -0.3
E small explosio | tex 14091984485 (D Grid4x4 small explos) | col #FF7D26 | LE-2 LI0 Br10 | life 0.2-0.6 | size const 2 | tr flat 0.00 | spd 0.00056 spread -360-360 | VelocityPerpendicular | flip Grid4x4 OneShot 1 | locked | EMIT 2 @0 | z -0.3 | attrs {"EmitType": "attribute"}
E small explosio | tex 14091984485 (D Grid4x4 small explos) | col #2C6FFF | LE-2 LI0 Br10 | life 0.2-0.6 | size const 2 | tr flat 0.00 | spd 0.00056 spread -360-360 | VelocityPerpendicular | flip Grid4x4 OneShot 1 | locked | EMIT 2 @0 | z -0.3 | attrs {"EmitType": "attribute"}
E Flash2         | tex 12993580758 (M  Flash) | col #2C6FFF | LE1 LI0 Br2 | life 0.1 | size shrink 3.77->0 | tr flat 0.00 | spd 0.00087 spread -360-360 | FacingCamera | EMIT 1 @0 | z 3 | attrs {"EmitType": "attribute"}
E Flash          | tex 15292526242 | col #2C6FFF | LE0.5 LI0 Br5 | life 0.075-0.18 | size shrink 15.9->0 | tr flat 0.00 | spd 0.00118 spread -360-360 | VelocityParallel | EMIT 2 @0
E WHAT THE HELLL | tex 18281363731 | col #FF8138 | LE0.45 LI0 Br5 | life 0.25-0.5 | size grow 0->3.06 | tr flat 0.00 | spd 0.00898 drag 5 spread -8-8 | FacingCamera | flip Grid4x4 OneShot 1 | EMIT 2 @0
E Fire38         | tex 16860307403 (M Grid4x4 Fire38) | col #EA3F42->#405DC6->#E7414E | LE1 LI0 Br7.47 | life 0.75 | size const 1 | tr flat 0.00 | spd 0.1-0.5 drag 6 spread 180 | FacingCamera | flip Grid4x4 OneShot 1 | locked | EMIT 0 @0 | z 1.4
E Ground1        | tex 16879949189 (M Grid4x4 Impact1) | col #41A6FF | LE1 LI0 Br10 | life 0.2-0.5 | size grow 0->10 | tr 0.50..0.50 vis 0.00-0.00 ->1.00 | spd 0.1 | FacingCamera | flip Grid4x4 OneShot 1 | locked | EMIT 2 @0
E AnotherCresc   | tex 14864155491 (M Grid4x4 1) | col #FFFFFF | LE1 LI0 Br0.3 | life 0.01-0.1 | size grow 0->4.04 | tr 0.63..0.63 vis 0.00-0.00 ->1.00 | spd 1.25-6.27 drag 7 spread 10 rotSpd 100-200 | VelocityPerpendicular | flip Grid4x4 OneShot 1 | EMIT 0 @0 | attrs {"BaseRate": 10.0}
E AnotherCresc   | tex 14864155491 (M Grid4x4 1) | col #FFFFFF | LE1 LI0 Br0.3 | life 0.1-0.2 | size grow 0->4.04 | tr flat 0.00 | spd 1.23-6.14 drag 7 spread 10 rotSpd 100-200 | VelocityPerpendicular | flip Grid4x4 OneShot 1 | EMIT 0 @0 | attrs {"BaseRate": 10.0}
E outer-ring     | tex 13348242294 (A  ring) | col #D643FF | LE1 LI0 Br4 | life 2 | size const 0.5 | tr 1.00..0.00 vis 0.30-0.70 ->1.00 | spd 0.001 spread -360-360 rotSpd -500-500 | FacingCamera | locked | EMIT 0 @0 | z 1
E moving lightni | tex 13390196434 (D Grid4x4 moving light) | col #3083FF | LE0 LI0 Br12 | life 0.2-0.35 | size const 4 | tr 0.00..0.00 vis 0.00-1.00 ->0.00 | spd 0 drag 7 spread -360-360 | FacingCamera | flip Grid4x4 OneShot 30 | EMIT 7 @0 | z 1.7
E moving lightni | tex 13390196434 (D Grid4x4 moving light) | col #FF7839 | LE0 LI0 Br12 | life 0.2-0.35 | size const 4 | tr 0.00..0.00 vis 0.00-1.00 ->0.00 | spd 0 drag 7 spread -360-360 | FacingCamera | flip Grid4x4 OneShot 30 | EMIT 7 @0 | z 1.7
E ray1           | tex 14813420032 (D  ParticleEmit) | col #EA3F42->#405DC6->#E7414E | LE0 LI0 Br4 | life 0.5 | size const 7 | tr 1.00..0.94 vis 0.50-0.50 ->1.00 | spd 0.0015 spread -360-360 | FacingCamera | locked | EMIT 1 @0 | z 5
E middle colore  | tex 13816054573 (M  BodyAura) | col #EA3F42->#1E938B->#E7414E | LE0 LI0 Br4 | life 0.5 | size const 3 | tr 1.00..0.75 vis 0.50-0.50 ->1.00 | spd 0.0015 spread -360-360 | FacingCamera | locked | EMIT 1 @0
E inside firey   | tex 12823974848 (M Grid4x4 Smoke) | col #EA3F42->#405DC6->#E7414E | LE0.2 LI0 Br4 | life 0.25-0.5 | size const 0.5 | tr 1.00..0.43 vis 0.50-0.50 ->1.00 | spd 0.0015 spread -360-360 rotSpd -90-90 | FacingCamera | flip Grid4x4 Loop 30-60 | locked | EMIT 1 @0 | z 5.5
E inside firey   | tex 12823974848 (M Grid4x4 Smoke) | col #EA3F42->#405DC6->#E7414E | LE0.2 LI0 Br4 | life 0.25-0.5 | size const 1 | tr 1.00..0.00 vis 0.50-0.50 ->1.00 | spd 0.0015 spread -360-360 rotSpd -90-90 | FacingCamera | flip Grid4x4 Loop 30-60 | locked | EMIT 1 @0 | z 5.5
E orb manga      | tex 14914635500 | col #EA3F42->#405DC6->#E7414E | LE0.55 LI0 Br7.47 | life 0-0.2 | size const 0.7 | tr 1.00..0.45 vis 0.50-0.50 ->1.00 | spd 0.0015 spread -360-360 | FacingCamera | flip Grid4x4 Loop 5-30 | locked | EMIT 1 @0 | z 4
E orb manga      | tex 14914635500 | col #000000 | LE-6 LI0 Br4 | life 0-0.2 | size const 0.7 | tr 1.00..0.89 vis 0.50-0.50 ->1.00 | spd 0.0015 spread -360-360 | FacingCamera | flip Grid4x4 Loop 5-30 | locked | EMIT 1 @0 | z 5
E cover-ring     | tex 14928605172 | col #EA3F42->#1E938B->#E7414E | LE0.8 LI0 Br4 | life 0.5 | size const 0.6 | tr 1.00..0.00 vis 0.50-0.50 ->1.00 | spd 0.0015 spread -360-360 rotSpd -90-90 | FacingCamera | flip Grid4x4 Loop 30-60 | locked | EMIT 1 @0 | z 6
E colored flare  | tex 13417142950 | col #FF5500 | LE1 LI0 Br4 | life 0.8 | size const 10 | tr 1.00..0.94 vis 0.50-0.50 ->1.00 | spd 0.001 spread -360-360 | VelocityPerpendicular | locked | EMIT 2 @0 | z 3
E Glow1          | tex 10527344199 (A  ParticleEmit) | col #EA3F42->#1E938B->#E7414E | LE1 LI0 Br3 | life 0.3 | size grow 0->1.48 | tr 1.00..0.51 vis 0.50-0.50 ->1.00 | spd 0.01 spread -360-360 | FacingCamera | locked | EMIT 0 @0 | z 1
E Rainbow3       | tex 85664013418740 (A  Rainbow3) | col #F1F1F1 | LE1 LI0 Br15 | life 1 | size grow 0->3.61 | tr 1.00..0.89 vis 0.12-0.12 ->1.00 | spd 0.001 | VelocityPerpendicular | EMIT 0 @0
E a              | tex 14483718869 (D Grid8x8 a) | col #EA3F42->#405DC6->#E7414E | LE-1 LI0 Br9.24 | life 1 | size const 0.6 | tr flat 0.00 | spd 0 | FacingCamera | flip Grid8x8 OneShot 1 | locked | EMIT 1 @0 | z 1
E a              | tex 14483718869 (D Grid8x8 a) | col #EA3F42->#405DC6->#E7414E | LE-1 LI0 Br7.85 | life 1 | size const 0.6 | tr 1.00..0.00 vis 0.13-0.79 ->1.00 | spd 0 | FacingCamera | flip Grid8x8 OneShot 1 | locked | EMIT 1 @0 | z 4.9
E a              | tex 115893075150205 | col #EA3F42->#1E938B->#E7414E | LE-1 LI0 Br7.85 | life 1 | size const 1.4 | tr 1.00..0.61 vis 0.47-0.47 ->1.00 | spd 0 | FacingCamera | flip Grid4x4 OneShot 1 | locked | EMIT 1 @0 | z 3
P {"k": "Part", "name": "Part", "size": [0.97, 0.97, 0.97], "mat": "Neon", "transp": 0.85}
P {"k": "Part", "name": "Right Leg", "size": [1.0, 2.0, 1.0], "mat": "Plastic", "transp": 0.0}
P {"k": "Part", "name": "Left Leg", "size": [1.0, 2.0, 1.0], "mat": "Plastic", "transp": 0.0}
P {"k": "Part", "name": "Right Arm", "size": [1.0, 2.0, 1.0], "mat": "Plastic", "transp": 0.0}
P {"k": "Part", "name": "Left Arm", "size": [1.0, 2.0, 1.0], "mat": "Plastic", "transp": 0.0}
P {"k": "Part", "name": "Torso", "size": [2.0, 2.0, 1.0], "mat": "Plastic", "transp": 0.0}
P {"k": "Part", "name": "Head", "size": [2.0, 1.0, 1.0], "mat": "Plastic", "transp": 0.0}
P {"k": "Part", "name": "Handle", "size": [1.20001, 1.20456, 1.2], "mat": "Plastic", "transp": 0.0}
P {"k": "SpecialMesh", "name": "Mesh", "mesh": 17278895176, "meshTex": 17439224216, "scale": [1.0, 1.0, 1.0]}
P {"k": "Part", "name": "Handle", "size": [2.46719, 2.73217, 2.9588], "mat": "Plastic", "transp": 0.0}
P {"k": "SpecialMesh", "name": "Mesh", "mesh": 17429167486, "meshTex": 17429587070, "scale": [1.0, 1.0, 1.0]}
P {"k": "Part", "name": "Handle", "size": [1.0, 1.0, 1.0], "mat": "Plastic", "transp": 0.0}
P {"k": "SpecialMesh", "name": "SpecialMesh", "mesh": 13458517718, "meshTex": 13458517641, "scale": [1.0, 1.0, 1.0]}
```
