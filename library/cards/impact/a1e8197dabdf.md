# a1e8197dabdf: RedFidgetSpinnerwow.rbxm :: Redspinner

- Category: **impact**; tags: flash, impact, portal, shockwave, star
- Layers: 45 emitters, 0 beams, 0 trails, 1 mesh parts, 0 lights; estimated length 7.2 s
- Fired by: its own scripts (not included in the card)
- Pack file: `190 OS (Oct 2024-Mar 2026)/RedFidgetSpinnerwow.rbxm` (instance referent 0): cut it into Studio with `kit/scripts/rbxcut.py "<pack>/190 OS (Oct 2024-Mar 2026)/RedFidgetSpinnerwow.rbxm" --ref 0 --out <studio content>/vfxlib/fx_a1e8197dabdf.rbxmx`
- Frames: none captured yet (play it with kit/studio/VFXLibPlayer.luau)

## Layers (one line each, in firing order; E emitter, B beam, T trail, P part, S script)
```
E Main           | col #FF0600 | LE0 LI0 Br0 | life 0.3-0.4 | size const 1.6 | tr 1.00..0.45 vis 0.50-0.50 ->1.00 | spd 0 drag 1 spread 12 | FacingCamera | squash grow 0->6
E X              | col #FFFFFF | LE0 LI0 Br0 | life 0 | size const 0 | tr flat 0.00 | spd 0 | FacingCamera
E Y              | col #FFFFFF | LE0 LI0 Br0 | life 0 | size const 0 | tr flat 0.00 | spd 0 | FacingCamera | squash shrink 0->-200
E Z              | col #FFFFFF | LE0 LI0 Br0 | life 0 | size const 0 | tr flat 0.00 | spd 0 | FacingCamera
E Z              | col #000000 | LE0 LI0 Br0 | life 0 | size grow 0->6 | tr flat 0.00 | spd 0 | FacingCamera
E Y              | col #000000 | LE0 LI0 Br0 | life 0 | size shrink 12->2 | tr flat 0.00 | spd 0 | FacingCamera
E X              | col #000000 | LE0 LI0 Br0 | life 0 | size grow 0->6 | tr flat 0.00 | spd 0 | FacingCamera
E X              | col #000000 | LE0 LI0 Br0 | life 0 | size const 0 | tr flat 0.00 | spd 0 | FacingCamera
E Y              | col #000000 | LE0 LI0 Br0 | life 0 | size const 0 | tr flat 0.00 | spd 0 | FacingCamera
E Z              | col #000000 | LE0 LI0 Br0 | life 0 | size const 0 | tr flat 0.00 | spd 0 | FacingCamera
E Main           | col #FFFFFF | LE0 LI0 Br0 | life 0.4-0.6 | size const 1 | tr 0.61..0.61 vis 0.00-0.00 ->1.00 | spd 0 drag 1 spread 12 | FacingCamera | squash grow 0->24 | flip Grid4x4 OneShot 1
E X              | col #FFFFFF | LE0 LI0 Br0 | life 0 | size const 0 | tr flat 0.00 | spd 0 | FacingCamera | squash grow 0->120
E Y              | col #FFFFFF | LE0 LI0 Br0 | life 0 | size const 0 | tr flat 0.00 | spd 0 | FacingCamera | squash const 1
E Z              | col #FFFFFF | LE0 LI0 Br0 | life 0 | size const 0 | tr flat 0.00 | spd 0 | FacingCamera | squash const 1
E Z              | col #000000 | LE0 LI0 Br0 | life 0 | size grow 0->2 | tr flat 0.00 | spd 0 | FacingCamera
E Y              | col #000000 | LE0 LI0 Br0 | life 0 | size grow 0->2 | tr flat 0.00 | spd 0 | FacingCamera
E X              | col #000000 | LE0 LI0 Br0 | life 0 | size shrink 2->1 | tr flat 0.00 | spd 0 | FacingCamera
E X              | col #000000 | LE0 LI0 Br0 | life 0 | size const 0 | tr flat 0.00 | spd 0 | FacingCamera
E Y              | col #000000 | LE0 LI0 Br0 | life 0 | size const 0 | tr flat 0.00 | spd 0 | FacingCamera
E Z              | col #000000 | LE0 LI0 Br0 | life 0 | size const 0 | tr flat 0.00 | spd 0 | FacingCamera
E burst4         | tex 123882326932447 | col #FFFFFF | LE0 LI0 Br12 | life 0.3-0.5 | size grow 0->46 | tr 1.00..0.97 vis 0.14-0.47 ->1.00 | spd 0.001 spread 360--360 | VelocityPerpendicular
E impact         | tex 89956780005603 | col #ED474F | LE-3 LI0 Br12 | life 0.15-0.2 | size grow 0->14 | tr flat 0.00 | spd 0.001 spread 260--60 | VelocityPerpendicular | flip Grid4x4 OneShot 1 | z 1
E Star           | tex 118309336615233 | col #ED474F | LE-3 LI0 Br12 | life 0.15-0.2 | size swell 0->9.38@0.50->0 | tr flat 0.00 | spd 240-440 drag 10 spread 360--360 | FacingCamera | squash swell 0->1.95@0.16->0 | z 0.4
E ParticleEmitte | tex 108523870700360 (M  Flare213New) | col #ED474F | LE0.6 LI0 Br8 | life 0.15-0.2 | size const 30 | tr 1.00..0.91 vis 0.10-0.50 ->1.00 | spd 2-4 spread 360--360 rotSpd -10-10 | FacingCamera
E burst3         | tex 114394605556712 | col #EE474F | LE-4 LI0 Br12 | life 0.3-0.5 | size grow 0->46 | tr 1.00..0.76 vis 0.14-0.56 ->1.00 | spd 0.001 spread 360--360 | VelocityPerpendicular
E burst2         | tex 100681748913310 | col #ED474F | LE-3 LI0 Br12 | life 0.15-0.2 | size grow 0->46 | tr 1.00..0.00 vis 0.12-0.56 ->1.00 | spd 0.001 spread 360--360 | VelocityPerpendicular
E impact         | tex 15343033007 | col #ED474F | LE-3 LI0 Br12 | life 0.2-0.3 | size grow 0->18 | tr 1.00..0.00 vis 0.10-0.64 ->1.00 | spd 0.001 spread 360--360 | VelocityPerpendicular | flip Grid4x4 OneShot 1 | z 1
E wind2          | tex 11866794293 (M Grid4x4 Darkening re) | col #FFFFFF | LE0 LI0 Br3 | life 0.8-1.2 | size grow 0->14 | tr 1.00..0.96 vis 0.16-0.80 ->1.00 | spd 120-160 drag 6 spread 360-0 | FacingCamera | flip Grid4x4 OneShot 1 | EMIT 0 @0 for 6
E wind3          | tex 13992327687 | col #FFFFFF | LE0 LI0 Br6 | life 0.8-1.2 | size grow 0->10 | tr 1.00..0.96 vis 0.14-0.80 ->1.00 | spd 120-160 drag 6 spread 360-0 | FacingCamera | flip Grid4x4 OneShot 1 | EMIT 0 @0 for 6
E wind           | tex 11855544753 (D Grid4x4 Stylized Smo) | col #FFFFFF | LE0 LI0 Br3 | life 0.8-1.2 | size grow 0->10 | tr 1.00..0.96 vis 0.16-0.80 ->1.00 | spd 120-160 drag 6 spread 360-0 | FacingCamera | flip Grid4x4 OneShot 1 | EMIT 0 @0 for 6
E Star2          | tex 118309336615233 | col #ED474F | LE-3 LI0 Br12 | life 0.12-0.16 | size swell 0->16.2@0.50->0 | tr flat 0.00 | spd 240-440 drag 10 spread 360--360 | FacingCamera | squash swell 0->1.95@0.16->0 | EMIT 12 @0 | z 0.4
E Burst3         | tex 15413764911 (D Grid4x4 FL121AME SHA) | col #ED474F | LE-3 LI0 Br12 | life 0.4-0.6 | size grow 0->30 | tr 1.00..0.00 vis 0.10-0.62 ->1.00 | spd 140-200 drag 8 spread 360--360 | VelocityParallel | squash grow 0->1.73 | flip Grid4x4 OneShot 1 | EMIT 12 @0 | z 1.8
E Burst2         | tex 16509892607 (M Grid4x4 Small realis) | col #ED474F | LE-3 LI0 Br12 | life 0.4-0.5 | size grow 0->74 | tr 1.00..0.00 vis 0.10-0.62 ->1.00 | spd 0.001 drag 10 spread 360--360 | VelocityPerpendicular | flip Grid4x4 OneShot 1 | EMIT 8 @0 | z 1.8
E Burst          | tex 18140248952 (D Grid4x4 Circular Sma) | col #ED474F | LE-3 LI0 Br12 | life 0.4 | size grow 0->56 | tr 1.00..0.00 vis 0.10-0.62 ->1.00 | spd 0.001 drag 10 spread 360--360 | FacingCamera | flip Grid4x4 OneShot 1 | EMIT 3 @0 | z 1.8
E Star           | tex 118309336615233 | col #ED474F | LE-3 LI0 Br12 | life 0.15 | size swell 0->45.2@0.50->0 | tr flat 0.00 | spd 0.001 drag 10 spread 360--360 | FacingCamera | squash swell 0->1.95@0.16->0 | EMIT 1 @0 | z 2
E Main           | col #FFFFFF | LE0 LI0 Br0 | life 0.3-0.4 | size const 0 | tr 1.00..0.92 vis 0.50-0.50 ->1.00 | spd 0 drag 1 spread 12 | FacingCamera | squash const 2.4 | flip Grid4x4 OneShot 1
E X              | col #FFFFFF | LE0 LI0 Br0 | life 0 | size const 0 | tr flat 0.00 | spd 0 | FacingCamera | squash grow 0->200
E Y              | col #FFFFFF | LE0 LI0 Br0 | life 0 | size const 0 | tr flat 0.00 | spd 0 | FacingCamera | squash const 1
E Z              | col #FFFFFF | LE0 LI0 Br0 | life 0 | size const 0 | tr flat 0.00 | spd 0 | FacingCamera | squash const 1
E Z              | col #000000 | LE0 LI0 Br0 | life 0 | size grow 0->86 | tr flat 0.00 | spd 0 | FacingCamera
E Y              | col #000000 | LE0 LI0 Br0 | life 0 | size grow 0->86 | tr flat 0.00 | spd 0 | FacingCamera
E X              | col #000000 | LE0 LI0 Br0 | life 0 | size grow 0->36 | tr flat 0.00 | spd 0 | FacingCamera
E X              | col #000000 | LE0 LI0 Br0 | life 0 | size const 0 | tr flat 0.00 | spd 0 | FacingCamera
E Y              | col #000000 | LE0 LI0 Br0 | life 0 | size const 0 | tr flat 0.00 | spd 0 | FacingCamera
E Z              | col #000000 | LE0 LI0 Br0 | life 0 | size const 0 | tr flat 0.00 | spd 0 | FacingCamera
P {"k": "SpecialMesh", "name": "Mesh", "mesh": 136867373491158, "meshTex": null, "scale": [0.0, 0.0, 0.0]}
P {"k": "SpecialMesh", "name": "Mesh", "mesh": 8501563708, "meshTex": null, "scale": [0.0, 0.0, 0.0]}
P {"k": "MeshPart", "name": "spinwind", "size": [6.15986, 7.98338, 8.14972], "mat": "Neon", "transp": 1.0, "mesh": 5926607506}
```
