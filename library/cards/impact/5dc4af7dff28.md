# 5dc4af7dff28: Triggerstuff.rbxl :: Workspace/ShotHeavyVFX

- Category: **impact**; tags: impact, lightning, projectile, shockwave, star
- Layers: 23 emitters, 0 beams, 0 trails, 0 mesh parts, 0 lights; estimated length 1.3 s
- Fired by: EmitCount attributes
- Pack file: `190 OS (Oct 2024-Mar 2026)/Triggerstuff.rbxl` (instance referent 390): cut it into Studio with `kit/scripts/rbxcut.py "<pack>/190 OS (Oct 2024-Mar 2026)/Triggerstuff.rbxl" --ref 390 --out <studio content>/vfxlib/fx_5dc4af7dff28.rbxmx`
- Frames: none captured yet (play it with kit/studio/VFXLibPlayer.luau)

## Layers (one line each, in firing order; E emitter, B beam, T trail, P part, S script)
```
E ImpactCircle2  | tex 14425843511 (M  Impact218) | col #4C89F9 | LE0 LI0 Br5 | life 1 | size grow 0->16.7 | tr 0.00..0.00 vis 0.00-0.00 ->1.00 | spd 0.00145 | VelocityPerpendicular | EMIT 1 @0
E CircleImpact   | tex 18140248952 (D Grid4x4 Circular Sma) | col #4A62FF | LE0 LI0 Br25 | life 0.3 | size const 3.34 | tr flat 0.00 | spd 0.00167 | VelocityPerpendicular | flip Grid4x4 OneShot 1 | EMIT 1 @0
E Impact1        | tex 10365552059 (M  Bang) | col #2A46FF | LE0 LI0 Br35 | life 0.085 | size shrink 20.1->0 | tr flat 0.00 | spd 0.00617 spread 360 | VelocityParallel | EMIT 2 @0 | z 2
E Impact2        | tex 16892242416 (D  Impact19) | col #2A46FF | LE0 LI0 Br35 | life 0.05 | size const 8 | tr flat 0.00 | spd 0.00617 spread 360 | VelocityParallel | EMIT 2 @0 | z 2
E Shards2        | tex 129314779106555 | col #2529FF | LE0 LI0 Br35 | life 0.1-0.25 | size const 2.51 | tr flat 0.00 | spd 8.36-25.1 drag 8 spread 30 | VelocityParallel | squash const 1 | flip Grid4x4 OneShot 1 | EMIT 5 @0
E Shard1         | tex 129314779106555 | col #2529FF | LE0 LI0 Br35 | life 0.05-0.15 | size const 4.18 | tr flat 0.00 | spd 0.00167 spread 25 | VelocityParallel | squash const 0.5 | flip Grid4x4 OneShot 1 | EMIT 5 @0
E ImpactShard1   | tex 12363834197 | col #2529FF | LE0 LI0 Br35 | life 0.1 | size const 5.01 | tr flat 0.00 | spd 8.36-25.1 drag 8 | VelocityParallel | squash const 1 | EMIT 1 @0
E MainLightning3 | tex 17005486894 (D Grid4x4 1) | col #FF712F->#483BDC->#3034F2 | LE1 LI0 Br45 | life 0.3 | size const 9 | tr 0.00..0.00 vis 0.00-1.00 ->0.00 | spd 0.00167 | VelocityPerpendicular | squash shrink -0.281->-2.09 | flip Grid4x4 OneShot 1 | EMIT 1 @0
E MainLightning2 | tex 11861841517 (A Grid4x4 Lightning) | col #FF712F->#483BDC->#3034F2 | LE1 LI0 Br45 | life 0.3-0.4 | size const 10 | tr 0.00..0.00 vis 0.00-1.00 ->0.00 | spd 0.00167 | VelocityPerpendicular | squash shrink 0.388->-1.5 | flip Grid4x4 OneShot 1 | EMIT 1 @0
E MainLightning1 | tex 11861841517 (A Grid4x4 Lightning) | col #FF712F->#483BDC->#3034F2 | LE1 LI0 Br45 | life 0.3-0.4 | size const 10 | tr 0.00..0.00 vis 0.00-1.00 ->0.00 | spd 0.00167 | VelocityPerpendicular | squash shrink 0.388->-1.5 | flip Grid4x4 OneShot 1 | EMIT 1 @0
E ImpactCircle2  | tex 15333808121 (M  Impact117) | col #FFFFFF | LE1 LI0 Br2 | life 0.5 | size grow 0->12 | tr 0.73..0.73 vis 0.00-0.00 ->1.00 | spd 80 drag 6 | VelocityPerpendicular | EMIT 1 @0
E LightningRing1 | tex 17005876540 | col #FF9925->#2A4AFF->#3E41FF | LE1 LI0 Br90 | life 0.3 | size const 12 | tr flat 0.00 | spd 0.00502 | VelocityPerpendicular | flip Grid4x4 OneShot 1 | EMIT 1 @0
E MessyLightning | tex 14367526987 | col #FF9925->#2A4AFF->#3E41FF | LE1 LI0 Br90 | life 0.2-0.5 | size grow 0->8.36 | tr flat 0.00 | spd 0.00502 spread 15 | VelocityParallel | flip Grid4x4 OneShot 1 | EMIT 3 @0
E ImpactCircle1  | tex 15333808121 (M  Impact117) | col #FFFFFF | LE1 LI0 Br2 | life 0.75 | size grow 0->9.65 | tr 0.73..0.73 vis 0.00-0.00 ->1.00 | spd 35 drag 6 | VelocityPerpendicular | EMIT 1 @0
E Wind2(2)       | tex 99030912594735 | col #484848 | LE1 LI0 Br2.1 | life 0.25-0.5 | size grow 0->20.1 | tr 0.49..0.49 vis 0.00-0.00 ->1.00 | spd 0.00059 spread 25 rotSpd 25-50 | VelocityPerpendicular | EMIT 2 @0
E Wind2(1)       | tex 86521711047914 | col #484848 | LE1 LI0 Br1.5 | life 0.5-1.2 | size grow 0->19.3 | tr 0.49..0.49 vis 0.00-0.00 ->1.00 | spd 0.00059 spread 25 rotSpd 25-50 | VelocityPerpendicular | EMIT 4 @0
E Wind2(3)       | tex 128758882110383 (A  ParticleEmit) | col #484848 | LE1 LI0 Br2.1 | life 0.5-1.15 | size grow 0->13.9 | tr 0.49..0.49 vis 0.00-0.00 ->1.00 | spd 0.00059 spread 25 rotSpd 25-50 | VelocityPerpendicular | EMIT 4 @0
E Wind1(2)       | tex 16034294138 (A  Impact496) | col #484848 | LE1 LI0 Br2 | life 0.25-0.5 | size grow 0->20.1 | tr 0.49..0.49 vis 0.00-0.00 ->1.00 | spd 0.00059 spread 25 rotSpd 25-50 | VelocityPerpendicular | EMIT 2 @0
E Wind1(1)       | tex 79454007816524 (A  Wind44) | col #484848 | LE1 LI0 Br1.5 | life 0.5-1.25 | size grow 0->21.5 | tr 0.49..0.49 vis 0.00-0.00 ->1.00 | spd 0.00059 spread 25 rotSpd 25-50 | VelocityPerpendicular | EMIT 4 @0
E Wind2          | tex 17388417211 | col #484848 | LE1 LI0 Br1 | life 0.85-1.3 | size grow 0->12.5 | tr 0.49..0.49 vis 0.00-0.00 ->1.00 | spd 0.00099 spread 25 rotSpd 50-165 | VelocityPerpendicular | EMIT 2 @0
E EnergyWave1    | tex 117107198522985 | col #4154D4 | LE0 LI0 Br10 | life 0.5 | size grow 0->8.36 | tr flat 0.00 | spd 0.00502 | VelocityPerpendicular | flip Grid4x4 OneShot 1 | EMIT 1 @0
E Wind1          | tex 10358014393 (D  Impact285) | col #484848 | LE1 LI0 Br2 | life 0.5-1.15 | size grow 0->12.5 | tr 0.49..0.49 vis 0.00-0.00 ->1.00 | spd 0.00099 spread 25 rotSpd 25-100 | VelocityPerpendicular | EMIT 2 @0
E WindEffect3    | tex 135857557868831 | col #4F66FF | LE0 LI0 Br15 | life 1 | size grow 0->19.1 | tr 0.00..0.00 vis 0.00-0.05 ->1.00 | spd 0.00023 | VelocityPerpendicular | EMIT 1 @0.05
```
