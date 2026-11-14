# cf52bd1bd54d: ThinIceBreaker.rbxm :: ThinIceBreakerTest

- Category: **explosion**; tags: aura, beam, explosion, flash, floor, ice, impact, lightning, portal, projectile, shockwave, slash, smoke, star
- Layers: 146 emitters, 2 beams, 0 trails, 16 mesh parts, 0 lights; estimated length 3.7 s
- Fired by: its own scripts (not included in the card)
- Pack file: `2026 OS Jan-April (part 2)/ThinIceBreaker.rbxm` (instance referent 0). Watch it in Studio: `kit/scripts/rbxcut.py --id cf52bd1bd54d --studio`, then `P.load("fx_cf52bd1bd54d")` (needs the pack: `kit/scripts/get_pack.py`)
- Frames: none captured yet (play it with kit/studio/VFXLibPlayer.luau)

## Layers (one line each, in firing order; E emitter, B beam, T trail, P part, S script)
```
E Flare1         | tex 138578711337491 | col #53FF98->#FF53FF | LE1 LI0 Br0.1 | life 0.1 | size shrink 10->0 | tr flat 0.00 | spd 0.001 | FacingCamera/Sphere | squash shrink 1->-3
E GlassSpec1     | tex 124619276075298 | col #53FF98->#FF53FF | LE1 LI0 Br1 | life 0.4-0.5 | size swell 0->0.5@0.35->0 | tr flat 0.00 | spd 5-15 drag 2 acc 0-15-0 | FacingCamera/Sphere | flip Grid8x8 OneShot 1
E ChromOrb1      | tex 113638059819125 (M Grid4x4 ParticleEmit) | col #53FF98->#FF53FF | LE1 LI0 Br1 | life 0.4 | size grow 0->8 | tr 0.90..0.90 vis 0.00-0.00 ->1.00 | spd 0.001 | VelocityPerpendicular/Sphere | flip Grid4x4 OneShot 1
E Rainbow1       | tex 75291700184033 | col #FFFFFF | LE1 LI0 Br0.5 | life 0.3 | size grow 0->14 | tr 1.00..0.89 vis 0.50-0.50 ->1.00 | spd 0.001 | FacingCamera
E RainbowFlare1  | tex 74612287108619 | col #53FF98->#FF53FF | LE1 LI0 Br0.05 | life 1 | size grow 0->35 | tr 0.00..0.00 vis 0.00-0.00 ->1.00 | spd 0.001 | FacingCamera
E ChromLightning | tex 137493898029098 | col #53FF98->#FF53FF | LE1 LI0 Br0.02 | life 0.1-0.2 | size grow 0->14 | tr flat 0.00 | spd 0.001 spread -1e+03-1e+03 | VelocityPerpendicular | flip Grid4x4 OneShot 1
E ChromAura1     | tex 12401154143 (A Grid8x8 Chromatic Sh) | col #53FF98->#FF53FF | LE1 LI0 Br0.1 | life 0.4 | size grow 0->14 | tr flat 0.80 | spd 0.001 | FacingCamera | flip Grid8x8 OneShot 1
E Flare1         | tex 81762212510392 | col #53FF98->#FF53FF | LE1 LI0 Br5 | life 0.4 | size grow 0->18 | tr 0.90..0.90 vis 0.00-0.00 ->1.00 | spd 0.001 | FacingCamera
E Flare2         | tex 15501970683 | col #53FF98->#FF53FF | LE1 LI0 Br0.05 | life 0.4 | size grow 0->18 | tr 0.90..0.90 vis 0.00-0.00 ->1.00 | spd 0.001 | FacingCamera
E Main           | tex 80442375429221 | col #FFFFFF | LE0 LI0 Br0 | life 0.4-0.6 | size const 1 | tr 5.00..1.00 vis 1.00-1.00 ->1.00 | spd 0 | FacingCamera | flip Grid4x4 OneShot 1
E X              | col #FFFFFF | LE0 LI0 Br0 | life 0 | size const 0 | tr flat 0.00 | spd 0 | FacingCamera
E Y              | col #FFFFFF | LE0 LI0 Br0 | life 0 | size const 0 | tr flat 0.00 | spd 0 | FacingCamera | squash grow 0->100
E Z              | col #FFFFFF | LE0 LI0 Br0 | life 0 | size const 0 | tr flat 0.00 | spd 0 | FacingCamera
E Z              | col #000000 | LE0 LI0 Br0 | life 0 | size shrink 25->0 | tr flat 0.00 | spd 0 | FacingCamera
E Y              | col #000000 | LE0 LI0 Br0 | life 0 | size const 0.5 | tr flat 0.00 | spd 0 | FacingCamera
E X              | col #000000 | LE0 LI0 Br0 | life 0 | size shrink 25->0 | tr flat 0.00 | spd 0 | FacingCamera
E X              | col #000000 | LE0 LI0 Br0 | life 0 | size const 0 | tr flat 0.00 | spd 0 | FacingCamera
E Y              | col #000000 | LE0 LI0 Br0 | life 0 | size const 0 | tr flat 0.00 | spd 0 | FacingCamera
E Z              | col #000000 | LE0 LI0 Br0 | life 0 | size const 0 | tr flat 0.00 | spd 0 | FacingCamera
E Main           | tex 80442375429221 | col #FFFFFF | LE0 LI0 Br0 | life 0.4-0.6 | size const 1 | tr 5.00..1.00 vis 1.00-1.00 ->1.00 | spd 0 | FacingCamera | flip Grid4x4 OneShot 1
E X              | col #FFFFFF | LE0 LI0 Br0 | life 0 | size const 0 | tr flat 0.00 | spd 0 | FacingCamera
E Y              | col #FFFFFF | LE0 LI0 Br0 | life 0 | size const 0 | tr flat 0.00 | spd 0 | FacingCamera | squash grow 0->100
E Z              | col #FFFFFF | LE0 LI0 Br0 | life 0 | size const 0 | tr flat 0.00 | spd 0 | FacingCamera
E Z              | col #000000 | LE0 LI0 Br0 | life 0 | size shrink 25->0 | tr flat 0.00 | spd 0 | FacingCamera
E Y              | col #000000 | LE0 LI0 Br0 | life 0 | size const 0.5 | tr flat 0.00 | spd 0 | FacingCamera
E X              | col #000000 | LE0 LI0 Br0 | life 0 | size shrink 25->0 | tr flat 0.00 | spd 0 | FacingCamera
E X              | col #000000 | LE0 LI0 Br0 | life 0 | size const 0 | tr flat 0.00 | spd 0 | FacingCamera
E Y              | col #000000 | LE0 LI0 Br0 | life 0 | size const 0 | tr flat 0.00 | spd 0 | FacingCamera
E Z              | col #000000 | LE0 LI0 Br0 | life 0 | size const 0 | tr flat 0.00 | spd 0 | FacingCamera
B BeamDisco      | tex 89582771264382 | col #53FF98->#FF53FF | LE0 LI0 Br5 | w 1-1 curve 0-0 seg 10 | tr flat 0.00 | tex Stretch 1 spd 1 | attrs {"EmitCount": 1.0, "EmitDelay": 1.0, "EmitDuration": 0.0, "IsEmitter": true, "Transformed": true}
B RenderTemplate | tex 89582771264382 | col #38EBFF | LE0 LI0 Br5 | w 1-1 curve 0-0 seg 10 face | tr 1.00..0.00 vis 0.13-0.88 ->1.00 | tex Stretch 1 spd 1 | attrs {"EmitDelay": 1.0}
E Flipbook       | tex 95988676643647 | col #000000 | LE0 LI0 Br0 | life 0 | size const 0 | tr flat 0.00 | spd 0 | FacingCamera | flip Grid4x4 OneShot 1
E LifeTime       | col #000000 | LE0 LI0 Br0 | life 0.9 | size const 0 | tr flat 0.00 | spd 0 | FacingCamera
E BlendSpeed     | col #FFFFFF | LE0 LI0 Br0 | life 0 | size const 0 | tr 0.00..0.00 vis 0.00-0.00 ->1.00 | spd 0 | FacingCamera
E Color          | col #53FF98->#FF53FF | LE0 LI0 Br1 | life 0 | size const 0 | tr flat 0.00 | spd 5 | FacingCamera
E BlendSpeed     | col #FFFFFF | LE0 LI0 Br0 | life 0 | size const 0 | tr 0.00..0.00 vis 0.00-0.20 ->1.00 | spd 0 | FacingCamera
E Transparency   | col #000000 | LE0 LI0 Br0 | life 0 | size const 0 | tr flat 1.00 | spd 0 | FacingCamera
E TextureLength  | col #FFFFFF | LE0 LI0 Br0 | life 0 | size const 1 | tr flat 0.00 | spd 0 | FacingCamera
E Width1         | col #FFFFFF | LE0 LI0 Br0 | life 0 | size grow 0->14 | tr flat 0.00 | spd 0 | FacingCamera
E Segments       | col #FFFFFF | LE0 LI0 Br0 | life 0 | size const 10 | tr flat 0.00 | spd 0 | FacingCamera
E TextureSpeed   | col #FFFFFF | LE0 LI0 Br0 | life 0 | size shrink 12->1 | tr flat 0.00 | spd 0 | FacingCamera
E CurveSize1     | col #FFFFFF | LE0 LI0 Br0 | life 0 | size const -5 | tr flat 0.00 | spd 0 | FacingCamera
E Width0         | col #FFFFFF | LE0 LI0 Br0 | life 0 | size grow 0->1 | tr flat 0.00 | spd 0 | FacingCamera
E Brightness     | col #FFFFFF | LE0 LI0 Br0 | life 0 | size const 5 | tr flat 0.00 | spd 0 | FacingCamera
E CurveSize0     | col #FFFFFF | LE0 LI0 Br0 | life 0 | size const 0 | tr flat 0.00 | spd 0 | FacingCamera
E LightEmission  | col #FFFFFF | LE0 LI0 Br0 | life 0 | size const 0 | tr flat 0.00 | spd 0 | FacingCamera
E Glow1          | tex 14159634300 | col #53FF98->#FF53FF | LE1 LI0 Br0.1 | life 0.7 | size grow 0->25 | tr 0.40..0.40 vis 0.00-0.00 ->0.80 | spd 0.001 | FacingCamera | EMIT 1 @1
E GlassSpec1     | tex 124619276075298 | col #53FF98->#FF53FF | LE1 LI0 Br5 | life 0.4-0.5 | size swell 0->0.5@0.35->0 | tr flat 0.00 | spd 25-75 drag 5 spread 0-125 acc 0-15-0 | FacingCamera | flip Grid8x8 OneShot 1 | EMIT 6 @1
E Wind3          | tex 128758882110383 (A  ParticleEmit) | col #FFFFFF | LE1 LI0.5 Br1 | life 0.2-0.5 | size grow 0->12 | tr 0.80..0.80 vis 0.00-0.00 ->1.00 | spd 0.001 spread 15 rotSpd -700--50 | VelocityPerpendicular | EMIT 2 @1
E Wind2          | tex 13131393513 (M  Impact563) | col #FFFFFF | LE1 LI0.5 Br1 | life 0.2-0.5 | size grow 0->12 | tr 0.80..0.80 vis 0.00-0.00 ->1.00 | spd 0.001 spread 15 rotSpd -700--50 | VelocityPerpendicular | EMIT 2 @1
E Wind1          | tex 14850595833 (M  spin sh) | col #FFFFFF | LE1 LI0.5 Br1 | life 0.2-0.5 | size grow 0->12 | tr 0.80..0.80 vis 0.00-0.00 ->1.00 | spd 0.001 spread 15 rotSpd -700--50 | VelocityPerpendicular | EMIT 2 @1
E Flare1         | tex 89480767232810 (D  Star97) | col #42C6FF | LE0 LI0 Br25 | life 0.05-0.15 | size swell 0->8.56@0.83->0 | tr flat 0.00 | spd 100-250 drag 45 spread 0-135 | FacingCamera | EMIT 6 @1
E Slash2         | tex 94179440426423 | col #53FF98->#FF53FF | LE1 LI0 Br5 | life 0.3 | size const 8 | tr flat 0.00 | spd 0.001 | VelocityPerpendicular | squash const -0.2 | flip Grid4x4 OneShot 1 | EMIT 1 @1 | z 0.1
E Slash1         | tex 99129082742397 | col #53FF98->#FF53FF | LE0 LI0 Br5 | life 0.2 | size const 6 | tr flat 0.00 | spd 0.001 | VelocityPerpendicular | squash const -0.2 | flip Grid4x4 OneShot 1 | EMIT 1 @1
E Main           | tex 136820326600095 | col #FFFFFF | LE0 LI0 Br0 | life 0.7 | size const 1 | tr 25.00..1.00 vis 1.00-1.00 ->1.00 | spd 0 drag 8 | FacingCamera | squash const 3 | flip Grid4x4 OneShot 1
E X              | col #FFFFFF | LE0 LI0 Br0 | life 0 | size const 0 | tr flat 0.00 | spd 0 | FacingCamera
E Y              | col #FFFFFF | LE0 LI0 Br0 | life 0 | size const 0 | tr flat 0.00 | spd 0 | FacingCamera
E Z              | col #FFFFFF | LE0 LI0 Br0 | life 0 | size const 0 | tr flat 0.00 | spd 0 | FacingCamera
E Z              | col #000000 | LE0 LI0 Br0 | life 0 | size const 3 | tr flat 0.00 | spd 0 | FacingCamera
E Y              | col #000000 | LE0 LI0 Br0 | life 0 | size grow 0->5 | tr flat 0.00 | spd 0 | FacingCamera
E X              | col #000000 | LE0 LI0 Br0 | life 0 | size const 12 | tr flat 0.00 | spd 0 | FacingCamera
E X              | col #000000 | LE0 LI0 Br0 | life 0 | size const 0 | tr flat 0.00 | spd 0 | FacingCamera
E Y              | col #000000 | LE0 LI0 Br0 | life 0 | size const 0 | tr flat 0.00 | spd 0 | FacingCamera
E Z              | col #000000 | LE0 LI0 Br0 | life 0 | size const 0 | tr flat 0.00 | spd 0 | FacingCamera
E Main           | tex 136820326600095 | col #FFFFFF | LE0 LI0 Br0 | life 0.2 | size const 1 | tr 5.00..1.00 vis 1.00-1.00 ->1.00 | spd 0 | FacingCamera | flip Grid4x4 OneShot 1
E X              | col #FFFFFF | LE0 LI0 Br0 | life 0 | size const 0 | tr flat 0.00 | spd 0 | FacingCamera
E Y              | col #FFFFFF | LE0 LI0 Br0 | life 0 | size const 0 | tr flat 0.00 | spd 0 | FacingCamera | squash shrink 0->-100
E Z              | col #FFFFFF | LE0 LI0 Br0 | life 0 | size const 0 | tr flat 0.00 | spd 0 | FacingCamera
E Z              | col #000000 | LE0 LI0 Br0 | life 0 | size grow 0->15 | tr flat 0.00 | spd 0 | FacingCamera
E Y              | col #000000 | LE0 LI0 Br0 | life 0 | size const 4 | tr flat 0.00 | spd 0 | FacingCamera
E X              | col #000000 | LE0 LI0 Br0 | life 0 | size grow 0->15 | tr flat 0.00 | spd 0 | FacingCamera
E X              | col #000000 | LE0 LI0 Br0 | life 0 | size const 0 | tr flat 0.00 | spd 0 | FacingCamera
E Y              | col #000000 | LE0 LI0 Br0 | life 0 | size const 0 | tr flat 0.00 | spd 0 | FacingCamera
E Z              | col #000000 | LE0 LI0 Br0 | life 0 | size const 0 | tr flat 0.00 | spd 0 | FacingCamera
E Ray            | tex 13276329894 | col #45C7FF | LE1 LI0 Br5 | life 0.05 | size grow 0->25 | tr flat 0.00 | spd 0.001 spread 1e+03--1e+03 rotSpd -1e+03-1e+03 | VelocityParallel | squash const 2 | EMIT 0 @1.7 for 1.2
E WindBlast3     | tex 7417145436 (A  Impact446) | col #FFFFFF | LE1 LI0 Br5 | life 0.05-0.1 | size grow 0->45 | tr 0.90..0.90 vis 0.00-0.00 ->1.00 | spd 0.001 spread -1e+03-1e+03 | VelocityPerpendicular | EMIT 0 @1.7 for 1.2
E WindBlast2     | tex 10176632695 (M Grid4x4 Impact245) | col #FFFFFF | LE1 LI0 Br5 | life 0.05-0.1 | size grow 0->45 | tr 0.90..0.90 vis 0.00-0.00 ->1.00 | spd 0.001 spread -1e+03-1e+03 | VelocityPerpendicular | EMIT 0 @1.7 for 1.2
E WindBlast1     | tex 15333808121 (M  Impact117) | col #FFFFFF | LE1 LI0 Br5 | life 0.05-0.1 | size grow 0->45 | tr 0.90..0.90 vis 0.00-0.00 ->1.00 | spd 0.001 spread -1e+03-1e+03 | VelocityPerpendicular | EMIT 0 @1.7 for 1.2
E GlowWall       | tex 2065086791 (M  BlurThingImO) | col #53FF98->#FF53FF | LE1 LI0 Br0.02 | life 0.1 | size grow 0->35 | tr 0.00..0.00 vis 0.00-0.00 ->1.00 | spd 0.001 | VelocityPerpendicular | EMIT 0 @1.7 for 1.2
E RainbowImpact1 | tex 103830849790057 | col #53FF98->#FF53FF | LE1 LI0 Br5 | life 0.05-0.1 | size grow 0->15 | tr 0.00..0.00 vis 0.00-0.00 ->1.00 | spd 0.001 spread -1e+03-1e+03 rotSpd -500-500 | VelocityPerpendicular | EMIT 0 @1.7 for 1.2
E RainbowImpact2 | tex 15502007854 | col #53FF98->#FF53FF | LE1 LI0 Br5 | life 0.05-0.1 | size grow 0->15 | tr 0.00..0.00 vis 0.00-0.00 ->1.00 | spd 0.001 spread -1e+03-1e+03 rotSpd -500-500 | VelocityPerpendicular | EMIT 0 @1.7 for 1.2
E RainbowImpact3 | tex 15502011883 | col #53FF98->#FF53FF | LE1 LI0 Br5 | life 0.05-0.1 | size grow 0->15 | tr 0.00..0.00 vis 0.00-0.00 ->1.00 | spd 0.001 spread -1e+03-1e+03 rotSpd -500-500 | VelocityPerpendicular | EMIT 0 @1.7 for 1.2
E RainbowImpact4 | tex 77811543431201 | col #53FF98->#FF53FF | LE1 LI0 Br5 | life 0.05-0.1 | size grow 0->15 | tr 0.00..0.00 vis 0.00-0.00 ->1.00 | spd 0.001 spread -1e+03-1e+03 rotSpd -500-500 | VelocityPerpendicular | EMIT 0 @1.7 for 1.2
E CE1            | tex 16865844052 | col #53FF98->#FF53FF | LE-1 LI0 Br5 | life 0.1 | size grow 0->8 | tr flat 0.00 | spd 50-150 spread -1e+03-1e+03 | VelocityParallel | flip Grid4x4 OneShot 1 | EMIT 0 @1.7 for 1.2
E CE2            | tex 137666963718741 (D Grid4x4 Water Wisps) | col #53FF98->#FF53FF | LE-1 LI0 Br25 | life 0.1 | size grow 0->8 | tr flat 0.00 | spd 50-150 spread -1e+03-1e+03 | VelocityParallel | flip Grid4x4 OneShot 1 | EMIT 0 @1.7 for 1.2
E CE1            | tex 17510992903 (D Grid8x8 smoke) | col #53FF98->#FF53FF | LE-1 LI0 Br15 | life 0.1 | size grow 0->8 | tr flat 0.00 | spd 50-150 spread -1e+03-1e+03 | VelocityParallel | flip Grid8x8 OneShot 1 | EMIT 0 @1.7 for 1.2
E CESwirl3       | tex 14525931482 | col #53FF98->#70FFA0->#FF53FF | LE0 LI0 Br5 | life 0.05 | size grow 0->8 | tr 0.00..0.00 vis 0.00-0.00 ->1.00 | spd 0.001 spread -1e+03-1e+03 rotSpd -800-800 | VelocityPerpendicular | EMIT 0 @1.7 for 1.2
E CESwirl2       | tex 15232762362 | col #53FF98->#70FFA0->#FF53FF | LE0 LI0 Br5 | life 0.05 | size grow 0->8 | tr 0.00..0.00 vis 0.00-0.00 ->1.00 | spd 0.001 spread -1e+03-1e+03 rotSpd -800-800 | VelocityPerpendicular | EMIT 0 @1.7 for 1.2
E CESwirl1       | tex 15232760101 | col #53FF98->#70FFA0->#FF53FF | LE0 LI0 Br5 | life 0.05 | size grow 0->8 | tr 0.00..0.00 vis 0.00-0.00 ->1.00 | spd 0.001 spread -1e+03-1e+03 rotSpd -800-800 | VelocityPerpendicular | EMIT 0 @1.7 for 1.2
E Wind1          | tex 14850595833 (M  spin sh) | col #FFFFFF | LE1 LI0.5 Br1 | life 0.2-0.5 | size grow 0->25 | tr 0.80..0.80 vis 0.00-0.00 ->1.00 | spd 0.001 spread 15 rotSpd -100-100 | VelocityPerpendicular | EMIT 0 @1.7 for 1.2
E Wind2          | tex 13131393513 (M  Impact563) | col #FFFFFF | LE1 LI0.5 Br1 | life 0.2-0.5 | size grow 0->25 | tr 0.80..0.80 vis 0.00-0.00 ->1.00 | spd 0.001 spread 15 rotSpd -100-100 | VelocityPerpendicular | EMIT 0 @1.7 for 1.2
E Wind3          | tex 128758882110383 (A  ParticleEmit) | col #FFFFFF | LE1 LI0.5 Br1 | life 0.2-0.5 | size grow 0->25 | tr 0.80..0.80 vis 0.00-0.00 ->1.00 | spd 0.001 spread 15 rotSpd -100-100 | VelocityPerpendicular | EMIT 0 @1.7 for 1.2
E Smoke1         | tex 13726321388 (M Grid4x4 Stylized Smo) | col #595959 | LE1 LI0.5 Br1 | life 0.2-0.5 | size grow 0->8 | tr 1.00..0.82 vis 0.26-0.26 ->1.00 | spd 50-150 drag 5 spread 0-1e+03 acc 0-150-0 | VelocityParallel | flip Grid4x4 OneShot 1 | EMIT 0 @1.7 for 1.2 | z 1
E Smoke2         | tex 16867354344 (D Grid4x4 10) | col #595959 | LE1 LI0.5 Br1 | life 0.2-0.5 | size grow 0->8 | tr 1.00..0.82 vis 0.26-0.26 ->1.00 | spd 50-150 drag 5 spread 0-1e+03 acc 0-150-0 | VelocityParallel | flip Grid4x4 OneShot 1 | EMIT 0 @1.7 for 1.2 | z 1
E FloorBoom1     | tex 15333808121 (M  Impact117) | col #FFFFFF | LE1 LI0.5 Br1 | life 0.2 | size grow 0->45 | tr 0.80..0.80 vis 0.00-0.00 ->1.00 | spd 0.001 | VelocityPerpendicular | EMIT 0 @1.7 for 1.2
E Spec2          | tex 16878186706 (M  Spec3) | col #58FF7F | LE1 LI0 Br5 | life 0.4-0.8 | size swell 0->0.3@0.30->0 | tr flat 0.00 | spd 10-90 drag 4 spread 1e+03--1e+03 acc 0-60-0 | FacingCamera | EMIT 25 @1.7
E Spec1          | tex 7246982406 (M  Stripes) | col #58FF7F | LE1 LI0 Br5 | life 0.4-0.8 | size swell 0->0.625@0.30->0 | tr flat 0.00 | spd 10-90 drag 4 spread 1e+03--1e+03 acc 0-60-0 | VelocityParallel | EMIT 25 @1.7
E Glow1          | tex 2065086791 (M  BlurThingImO) | col #47FFF9 | LE1 LI0 Br5 | life 1 | size grow 0->25 | tr 0.90..0.90 vis 0.00-0.00 ->1.00 | spd 0.001 | FacingCamera | EMIT 1 @1.7 | z -0.1
E GlowImpact3    | tex 15502025766 | col #47FFF9 | LE1 LI0 Br5 | life 1 | size grow 0->15 | tr 0.80..0.80 vis 0.00-0.00 ->1.00 | spd 0.001 | FacingCamera | EMIT 1 @1.7
E GlowImpact1    | tex 15501999565 | col #47FFF9 | LE1 LI0 Br5 | life 1 | size grow 0->15 | tr 0.80..0.80 vis 0.00-0.00 ->1.00 | spd 0.001 | FacingCamera | EMIT 1 @1.7
E GlowImpact2    | tex 15502007854 | col #47FFF9 | LE1 LI0 Br5 | life 1 | size grow 0->25 | tr 0.80..0.80 vis 0.00-0.00 ->1.00 | spd 0.001 | FacingCamera | EMIT 1 @1.7
E Blast1         | tex 6991254829 (M  Impact411) | col #9E4AFF | LE1 LI0 Br5 | life 0.5 | size grow 0->45 | tr 0.00..0.00 vis 0.00-0.00 ->1.00 | spd 0.001 | FacingCamera | EMIT 1 @1.7
E Flare          | tex 16608943230 | col #14FF82 | LE1 LI0 Br25 | life 0.05-0.2 | size swell 0->18@0.81->0 | tr flat 0.00 | spd 50-500 drag 45 spread 1e+03--1e+03 | FacingCamera | EMIT 15 @1.7
E LineFlare1     | tex 14684195806 | col #53FF98->#FF53FF | LE1 LI0 Br25 | life 0.1 | size grow 0->65 | tr 0.00..0.00 vis 0.00-0.00 ->1.00 | spd 0.001 | FacingCameraWorldUp | squash shrink 0->-2 | EMIT 1 @1.7
E Wind3          | tex 128758882110383 (A  ParticleEmit) | col #FFFFFF | LE1 LI0.5 Br1 | life 0.8-2 | size grow 0->29 | tr 0.80..0.80 vis 0.00-0.00 ->1.00 | spd 0.001 spread 15 rotSpd -100-100 | VelocityPerpendicular | EMIT 2 @1.7
E Wind1          | tex 14850595833 (M  spin sh) | col #FFFFFF | LE1 LI0.5 Br1 | life 0.8-2 | size grow 0->29 | tr 0.80..0.80 vis 0.00-0.00 ->1.00 | spd 0.001 spread 15 rotSpd -100-100 | VelocityPerpendicular | EMIT 2 @1.7
E Wind2          | tex 13131393513 (M  Impact563) | col #FFFFFF | LE1 LI0.5 Br1 | life 0.8-2 | size grow 0->29 | tr 0.80..0.80 vis 0.00-0.00 ->1.00 | spd 0.001 spread 15 rotSpd -100-100 | VelocityPerpendicular | EMIT 2 @1.7
E Shockwave1     | tex 16877842776 (M Grid4x4 Circle3) | col #FFFFFF | LE0 LI0 Br5 | life 0.2 | size grow 0->150 | tr flat 0.00 | spd 0.001 | VelocityPerpendicular | flip Grid4x4 OneShot 1 | EMIT 1 @1.7
E Impact1        | tex 16892286605 | col #53FF98->#FF53FF | LE1 LI0 Br5 | life 0.05 | size shrink 16->12 | tr flat 0.00 | spd 0.001 | FacingCameraWorldUp | EMIT 1 @1.7 | z 5
E GlowEmit       | tex 2065086791 (M  BlurThingImO) | col #53FF98->#FF53FF | LE1 LI0 Br15 | life 0.1 | size grow 0->25 | tr 0.00..0.00 vis 0.00-0.00 ->1.00 | spd 0.001 | FacingCamera | EMIT 1 @1.7 | z 4.9
E Impact2        | tex 6991254829 (M  Impact411) | col #000000 | LE-2 LI0 Br0 | life 0.05 | size shrink 12->8 | tr flat 0.00 | spd 0.001 | FacingCameraWorldUp | EMIT 1 @1.7 | z 5.1
E StarImpact1    | tex 16608943230 | col #AD49FF | LE-5 LI0 Br150 | life 0.05 | size shrink 45->0 | tr flat 0.00 | spd 0.001 | FacingCamera | EMIT 1 @1.7 | z 5.5
E WindBlast1     | tex 15333808121 (M  Impact117) | col #FFFFFF | LE1 LI0 Br5 | life 0.05-0.1 | size grow 0->25 | tr 0.00..0.00 vis 0.00-0.00 ->1.00 | spd 0.001 spread -1e+03-1e+03 | VelocityPerpendicular | EMIT 2 @1.7
E WindBlast2     | tex 10176632695 (M Grid4x4 Impact245) | col #FFFFFF | LE1 LI0 Br5 | life 0.05-0.1 | size grow 0->25 | tr 0.00..0.00 vis 0.00-0.00 ->1.00 | spd 0.001 spread -1e+03-1e+03 | VelocityPerpendicular | EMIT 2 @1.7
E WindSwirl1     | tex 9281305957 (A  WindRing) | col #FFFFFF | LE1 LI0.5 Br1 | life 0.1-1.4 | size grow 0->35 | tr 0.80..0.80 vis 0.00-0.00 ->1.00 | spd 0.001 spread -1e+03-1e+03 rotSpd -150-150 | VelocityPerpendicular | EMIT 3 @1.7
E WindSwirl2     | tex 12403112662 (A  Impact444) | col #FFFFFF | LE1 LI0.5 Br1 | life 0.1-1.4 | size grow 0->35 | tr 0.80..0.80 vis 0.00-0.00 ->1.00 | spd 0.001 spread -1e+03-1e+03 rotSpd -150-150 | VelocityPerpendicular | EMIT 3 @1.7
E WindBlast3     | tex 7417145436 (A  Impact446) | col #FFFFFF | LE1 LI0 Br5 | life 0.05-0.1 | size grow 0->25 | tr 0.00..0.00 vis 0.00-0.00 ->1.00 | spd 0.001 spread -1e+03-1e+03 | VelocityPerpendicular | EMIT 2 @1.7
E ChromBreak1    | tex 86501395089413 | col #53FF98->#FF53FF | LE1 LI0 Br15 | life 0.2 | size grow 0->19 | tr flat 0.00 | spd 0.001 | VelocityPerpendicular | flip Grid4x4 OneShot 1 | EMIT 1 @1.7
E Main           | tex 136820326600095 | col #73A9FF | LE0 LI0 Br0 | life 0.1 | size const 1 | tr 0.00..0.00 vis 0.00-0.10 ->1.00 | spd 0 | FacingCamera | flip Grid4x4 OneShot 1
E X              | col #FFFFFF | LE0 LI0 Br0 | life 0 | size const 0 | tr flat 0.00 | spd 0 | FacingCamera
E Y              | col #FFFFFF | LE0 LI0 Br0 | life 0 | size const 0 | tr flat 0.00 | spd 0 | FacingCamera
E Z              | col #FFFFFF | LE0 LI0 Br0 | life 0 | size const 0 | tr flat 0.00 | spd 0 | FacingCamera
E Z              | col #000000 | LE0 LI0 Br0 | life 0 | size grow 0->25 | tr flat 0.00 | spd 0 | FacingCamera
E Y              | col #000000 | LE0 LI0 Br0 | life 0 | size grow 0->25 | tr flat 0.00 | spd 0 | FacingCamera
E X              | col #000000 | LE0 LI0 Br0 | life 0 | size const 1 | tr flat 0.00 | spd 0 | FacingCamera
E X              | col #000000 | LE0 LI0 Br0 | life 0 | size const 0 | tr flat 0.00 | spd 0 | FacingCamera
E Y              | col #000000 | LE0 LI0 Br0 | life 0 | size const 0 | tr flat 0.00 | spd 0 | FacingCamera
E Z              | col #000000 | LE0 LI0 Br0 | life 0 | size const 0 | tr flat 0.00 | spd 0 | FacingCamera
E Main           | tex 136820326600095 | col #FFFFFF | LE0 LI0 Br0 | life 0.02 | size const 1 | tr flat 0.50 | spd 0 | FacingCamera | flip Grid4x4 OneShot 1
E X              | col #FFFFFF | LE0 LI0 Br0 | life 0 | size const 0 | tr flat 0.00 | spd 0 | FacingCamera
E Y              | col #FFFFFF | LE0 LI0 Br0 | life 0 | size const 0 | tr flat 0.00 | spd 0 | FacingCamera
E Z              | col #FFFFFF | LE0 LI0 Br0 | life 0 | size const 0 | tr flat 0.00 | spd 0 | FacingCamera
E Z              | col #000000 | LE0 LI0 Br0 | life 0 | size const 12 | tr flat 0.00 | spd 0 | FacingCamera
E Y              | col #000000 | LE0 LI0 Br0 | life 0 | size const 12 | tr flat 0.00 | spd 0 | FacingCamera
E X              | col #000000 | LE0 LI0 Br0 | life 0 | size const 12 | tr flat 0.00 | spd 0 | FacingCamera
E X              | col #000000 | LE0 LI0 Br0 | life 0 | size const 0 | tr flat 0.00 | spd 0 | FacingCamera
E Y              | col #000000 | LE0 LI0 Br0 | life 0 | size const 0 | tr flat 0.00 | spd 0 | FacingCamera
E Z              | col #000000 | LE0 LI0 Br0 | life 0 | size const 0 | tr flat 0.00 | spd 0 | FacingCamera
E Main           | tex 136820326600095 | col #FFFFFF | LE0 LI0 Br0 | life 0.04 | size const 1 | tr flat 2.00 | spd 0 | FacingCamera | flip Grid4x4 OneShot 1 | RATE 35 (continuous)
E X              | col #FFFFFF | LE0 LI0 Br0 | life 0 | size const 0 | tr flat 0.00 | spd 0 | FacingCamera
E Y              | col #FFFFFF | LE0 LI0 Br0 | life 0 | size const 0 | tr flat 0.00 | spd 0 | FacingCamera
E Z              | col #FFFFFF | LE0 LI0 Br0 | life 0 | size const 0 | tr flat 0.00 | spd 0 | FacingCamera
E Z              | col #000000 | LE0 LI0 Br0 | life 0 | size const 45 | tr flat 0.00 | spd 0 | FacingCamera
E Y              | col #000000 | LE0 LI0 Br0 | life 0 | size const 45 | tr flat 0.00 | spd 0 | FacingCamera
E X              | col #000000 | LE0 LI0 Br0 | life 0 | size const 1 | tr flat 0.00 | spd 0 | FacingCamera
E X              | col #000000 | LE0 LI0 Br0 | life 0 | size const 0 | tr flat 0.00 | spd 0 | FacingCamera
E Y              | col #000000 | LE0 LI0 Br0 | life 0 | size const 0 | tr flat 0.00 | spd 0 | FacingCamera
E Z              | col #000000 | LE0 LI0 Br0 | life 0 | size const 0 | tr flat 0.00 | spd 0 | FacingCamera
P {"k": "MeshPart", "name": "GlowBreak", "size": [0.001, 0.001, 0.001], "mat": "Neon", "transp": 5.0, "mesh": 5862674837}
P {"k": "MeshPart", "name": "RenderTemplate", "size": [0.001, 0.001, 0.001], "mat": "Neon", "transp": 5.0, "mesh": 5862674837}
P {"k": "MeshPart", "name": "Explosion", "size": [0.001, 0.001, 0.001], "mat": "Glass", "transp": 0.0, "mesh": 5769826587}
P {"k": "MeshPart", "name": "RenderTemplate", "size": [0.001, 0.001, 0.001], "mat": "Glass", "transp": 0.0, "mesh": 5769826587}
P {"k": "MeshPart", "name": "DistortionBreak", "size": [0.001, 0.001, 0.001], "mat": "Glass", "transp": 5.0, "mesh": 5862674837}
P {"k": "MeshPart", "name": "RenderTemplate", "size": [0.001, 0.001, 0.001], "mat": "Glass", "transp": 5.0, "mesh": 5862674837}
P {"k": "MeshPart", "name": "SkyGrab1", "size": [0.001, 0.001, 0.001], "mat": "Glass", "transp": 5.0, "mesh": 113322248153294}
P {"k": "MeshPart", "name": "RenderTemplate", "size": [0.001, 0.001, 0.001], "mat": "Glass", "transp": 5.0, "mesh": 113322248153294}
P {"k": "MeshPart", "name": "SkyGrab2", "size": [0.001, 0.001, 0.001], "mat": "Glass", "transp": 5.0, "mesh": 132959345334881}
P {"k": "MeshPart", "name": "RenderTemplate", "size": [0.001, 0.001, 0.001], "mat": "Glass", "transp": 5.0, "mesh": 132959345334881}
P {"k": "MeshPart", "name": "FabricStretch", "size": [0.001, 0.001, 0.001], "mat": "Glass", "transp": 5.0, "mesh": 12722164876}
P {"k": "MeshPart", "name": "RenderTemplate", "size": [0.001, 0.001, 0.001], "mat": "Glass", "transp": 5.0, "mesh": 12722164876}
P {"k": "MeshPart", "name": "SkySlash1", "size": [0.001, 0.001, 0.001], "mat": "Glass", "transp": 0.0, "mesh": 74181482131152}
P {"k": "MeshPart", "name": "RenderTemplate", "size": [0.001, 0.001, 0.001], "mat": "Glass", "transp": 0.0, "mesh": 74181482131152}
P {"k": "Part", "name": "Right Leg", "size": [1.0, 2.0, 1.0], "mat": "Plastic", "transp": 0.0}
P {"k": "Part", "name": "Left Leg", "size": [1.0, 2.0, 1.0], "mat": "Plastic", "transp": 0.0}
P {"k": "Part", "name": "Right Arm", "size": [1.0, 2.0, 1.0], "mat": "Plastic", "transp": 0.0}
P {"k": "Part", "name": "Left Arm", "size": [1.0, 2.0, 1.0], "mat": "Plastic", "transp": 0.0}
P {"k": "Part", "name": "Torso", "size": [2.0, 2.0, 1.0], "mat": "Plastic", "transp": 0.0}
P {"k": "Part", "name": "Head", "size": [2.0, 1.0, 1.0], "mat": "Plastic", "transp": 0.0}
```
