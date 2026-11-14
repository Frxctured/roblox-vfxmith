# dbabf5952aba: Goro_-_Thunder_Wrath_Skill.rbxl :: StarterPlayer/StarterPlayerScripts/Replicator/Goro

- Category: **impact**; tags: floor, impact, lightning, star
- Layers: 5 emitters, 0 beams, 0 trails, 0 mesh parts, 1 lights; estimated length 3.0 s
- Fired by: EmitCount attributes
- Pack file: `Older OS (2025 and older)/important (cool) rbx (Nov 2023)/Goro_-_Thunder_Wrath_Skill.rbxl` (instance referent 9153): cut it into Studio with `kit/scripts/rbxcut.py "<pack>/Older OS (2025 and older)/important (cool) rbx (Nov 2023)/Goro_-_Thunder_Wrath_Skill.rbxl" --ref 9153 --out <studio content>/vfxlib/fx_dbabf5952aba.rbxmx`
- Frames: none captured yet (play it with kit/studio/VFXLibPlayer.luau)

## Layers (one line each, in firing order; E emitter, B beam, T trail, P part, S script)
```
E Specs          | tex 6910301489 (M  ParticleEmit) | col #55AAFF | LE0.5 LI0 Br7 | life 1.1-1.7 | size swell 0->4.05@0.24->0 | tr flat 0.00 | spd 51.4-82.3 drag 7 spread -90-90 acc 0--13.9-0 rotSpd 150-225 | FacingCamera | EMIT 20 @0 | z 5.55
E Shards         | tex 8708744804 (M Grid4x4 1) | col #55AAFF | LE0.5 LI0 Br4 | life 0.4-0.5 | size swell 0->3.58@0.30->0 | tr flat 0.00 | spd 75-105 drag 7.5 spread -120-120 | VelocityParallel | squash grow 0->1.99 | EMIT 20 @0 | z 2.75
E Rocks2         | tex 6730730442 (D  Rocks) | col #000000 | LE0 LI0 Br0 | life 3 | size shrink 1.69->0 | tr 0.00..0.00 vis 0.00-0.00 ->0.50 | spd 20-80 drag 3 spread 90--90 acc 0--12.9-0 rotSpd -300-300 | FacingCamera | EMIT 15 @0 | z 1.94
E Main           | tex 8693729108 | col #55FFFF->#00557F | LE0.3 LI0 Br4 | life 0.3-0.5 | size swell 0->9.19@0.21->0 | tr flat 0.00 | spd 30-50 drag 6.5 spread -360-360 rotSpd -180-180 | FacingCamera | EMIT 25 @0 | z 2
E Ground         | tex 8172249266 (D  Wave) | col #000000 | LE0 LI0 Br0 | life 3 | size const 15 | tr 0.00..0.00 vis 0.00-0.87 ->1.00 | spd 0.0054 | VelocityPerpendicular | EMIT 1 @0 | z 1
S ModuleScript Z len2669 flags=anim,attr,debris,delay,emit,tween
```
