# a6ad2fba038c: Samurai.rbxl :: ReplicatedFirst/Part

- Category: **explosion**; tags: explosion, water
- Layers: 7 emitters, 0 beams, 0 trails, 0 mesh parts, 0 lights; estimated length 0.8 s
- Fired by: EmitCount attributes
- Pack file: `190 OS (Oct 2024-Mar 2026)/Samurai.rbxl` (instance referent 8397). Watch it in Studio: `kit/scripts/rbxcut.py --id a6ad2fba038c --studio`, then `P.load("fx_a6ad2fba038c")` (needs the pack: `kit/scripts/get_pack.py`)
- Frames: none captured yet (play it with kit/studio/VFXLibPlayer.luau)

## Layers (one line each, in firing order; E emitter, B beam, T trail, P part, S script)
```
E dots           | tex 8030760338 (M Grid4x4 Specs) | col #0F2794 | LE1 LI0 Br80 | life 0.3-0.6 | size shrink 1.31->0 | tr flat 0.00 | spd 140-219 drag 20 spread -360-360 acc 0--50-0 | FacingCamera | EMIT 10 @0
E qick shards    | tex 15431912045 (M  ParticleEmit) | col #0F2794 | LE1 LI0 Br80 | life 0.11 | size shrink 1.31->0 | tr flat 0.00 | spd 140-219 drag 20 spread -360-360 acc 0--50-0 | VelocityParallel | EMIT 10 @0
E shards         | tex 15431912045 (M  ParticleEmit) | col #0F2794 | LE1 LI0 Br80 | life 0.3-0.6 | size shrink 1.31->0 | tr flat 0.00 | spd 140-219 drag 20 spread -360-360 acc 0--50-0 | VelocityParallel | EMIT 10 @0
E waters         | tex 15814918201 | col #0F2791 | LE0 LI0 Br50 | life 0.3-0.7 | size grow 0->4 | tr flat 0.00 | spd 140-200 drag 20 spread -360-360 acc 0--50-0 | FacingCamera | flip Grid4x4 OneShot 30 | EMIT 20 @0
E water bomb     | tex 15814918201 | col #0F2794 | LE0 LI0 Br50 | life 0.6 | size grow 0->15 | tr flat 0.00 | spd 0.001 | FacingCamera | flip Grid4x4 OneShot 30 | EMIT 1 @0 | z 2
E water          | tex 15484052560 (D Grid4x4 water) | col #0F2791 | LE0 LI0 Br50 | life 0.3-0.8 | size grow 0->4 | tr 0.00..0.00 vis 0.00-0.00 ->1.00 | spd 140-200 drag 20 spread -360-360 acc 0--50-0 | FacingCamera | flip Grid4x4 OneShot 30 | EMIT 20 @0
E B              | tex 15056626828 | col #0F2794 | LE1 LI0 Br40 | life 0.3-0.6 | size shrink 1.31->0 | tr flat 0.00 | spd 140-200 drag 20 spread -360-360 acc 0--50-0 | FacingCamera | flip Grid2x2 OneShot 30 | EMIT 10 @0
P {"k": "Part", "name": "Part", "size": [4.0, 1.0, 2.0], "mat": "Plastic", "transp": 0.0}
```
