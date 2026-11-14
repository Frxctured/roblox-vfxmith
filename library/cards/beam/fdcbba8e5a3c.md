# fdcbba8e5a3c: Testing_ServerNote_in_desc.rbxl :: Workspace/GiantCrystal

- Category: **beam**; tags: beam, flash, star
- Layers: 16 emitters, 4 beams, 8 trails, 0 mesh parts, 0 lights; estimated length 5.0 s
- Fired by: its own scripts (not included in the card)
- Pack file: `Older OS (2025 and older)/important (cool) rbx (Nov 2023)/Testing_ServerNote_in_desc.rbxl` (instance referent 1727). Watch it in Studio: `kit/scripts/rbxcut.py --id fdcbba8e5a3c --studio`, then `P.load("fx_fdcbba8e5a3c")` (needs the pack: `kit/scripts/get_pack.py`)
- Frames: none captured yet (play it with kit/studio/VFXLibPlayer.luau)

## Layers (one line each, in firing order; E emitter, B beam, T trail, P part, S script)
```
E Icon           | tex 242911609 | col #4B0000 | LE0 LI0 Br1 | life 0.7-1 | size grow 0->5.03 | tr 0.00..0.00 vis 0.00-0.50 ->1.00 | spd 30 drag 10 spread -360-360 acc 0-10-0 | FacingCamera | z -1
E Icon           | tex 242911609 | col #FF0000 | LE1 LI0 Br1 | life 0.7-1 | size grow 0->5.09 | tr 0.00..0.00 vis 0.00-0.50 ->1.00 | spd 30 drag 10 spread -360-360 acc 0-10-0 | FacingCamera
E Icon           | tex 242911609 | col #C80000 | LE0 LI0 Br1 | life 0.7-1 | size grow 0->4.97 | tr 0.00..0.00 vis 0.00-0.50 ->1.00 | spd 30 drag 10 spread -360-360 acc 0-10-0 | FacingCamera | z 1
E Icon           | tex 242911609 | col #4B0000 | LE0 LI0 Br1 | life 0.7-1 | size grow 0->5.03 | tr 0.00..0.00 vis 0.00-0.50 ->1.00 | spd 30 drag 10 spread -360-360 acc 0-10-0 | FacingCamera | z -1
E Icon           | tex 242911609 | col #FF0000 | LE1 LI0 Br1 | life 0.7-1 | size grow 0->5.09 | tr 0.00..0.00 vis 0.00-0.50 ->1.00 | spd 30 drag 10 spread -360-360 acc 0-10-0 | FacingCamera
E Icon           | tex 242911609 | col #C80000 | LE0 LI0 Br1 | life 0.7-1 | size grow 0->4.97 | tr 0.00..0.00 vis 0.00-0.50 ->1.00 | spd 30 drag 10 spread -360-360 acc 0-10-0 | FacingCamera | z 1
E Icon           | tex 242911609 | col #4B0000 | LE0 LI0 Br1 | life 0.7-1 | size grow 0->5.03 | tr 0.00..0.00 vis 0.00-0.50 ->1.00 | spd 30 drag 10 spread -360-360 acc 0-10-0 | FacingCamera | z -1
E Icon           | tex 242911609 | col #FF0000 | LE1 LI0 Br1 | life 0.7-1 | size grow 0->5.09 | tr 0.00..0.00 vis 0.00-0.50 ->1.00 | spd 30 drag 10 spread -360-360 acc 0-10-0 | FacingCamera
E Icon           | tex 242911609 | col #C80000 | LE0 LI0 Br1 | life 0.7-1 | size grow 0->4.97 | tr 0.00..0.00 vis 0.00-0.50 ->1.00 | spd 30 drag 10 spread -360-360 acc 0-10-0 | FacingCamera | z 1
E Icon           | tex 242911609 | col #4B0000 | LE0 LI0 Br1 | life 0.7-1 | size grow 0->5.03 | tr 0.00..0.00 vis 0.00-0.50 ->1.00 | spd 30 drag 10 spread -360-360 acc 0-10-0 | FacingCamera | z -1
E Icon           | tex 242911609 | col #FF0000 | LE1 LI0 Br1 | life 0.7-1 | size grow 0->5.09 | tr 0.00..0.00 vis 0.00-0.50 ->1.00 | spd 30 drag 10 spread -360-360 acc 0-10-0 | FacingCamera
E Icon           | tex 242911609 | col #C80000 | LE0 LI0 Br1 | life 0.7-1 | size grow 0->4.97 | tr 0.00..0.00 vis 0.00-0.50 ->1.00 | spd 30 drag 10 spread -360-360 acc 0-10-0 | FacingCamera | z 1
E ParticleEmitte | tex 2273224484 | col #00FFEE | LE0 LI0 Br1 | life 0.5-2 | size shrink 20->0 | tr 1.00..0.00 vis 0.10-0.80 ->1.00 | spd 20-250 drag 5 spread 9e+03 rotSpd -50-50 | FacingCamera | RATE 50 (continuous)
E ParticleEmitte | tex 272050333 (A  ice1) | col #FFFFFF | LE1 LI0 Br1 | life 1-5 | size grow 0->0.1 | tr 1.00..0.50 vis 0.50-0.50 ->1.00 | spd 0-0.5 drag -1 spread -180-180 | FacingCamera
E Glow           | tex 272050333 (A  ice1) | col #FFFFFF | LE1 LI0 Br1 | life 2 | size const 5 | tr 1.00..0.90 vis 0.50-0.50 ->1.00 | spd 0 | FacingCamera | z 2.5
E Core           | tex 1084962479 (A  Core) | col #FF0004->#00FF08->#FFFFFF | LE1 LI0 Br1 | life 1 | size shrink 10->0 | tr 1.00..0.00 vis 0.10-0.99 ->1.00 | spd 0 | FacingCamera | locked | RATE 0.2 (continuous)
T Trail          | tex 3230898011 | col #00FFFF | LE0 LI0 Br1 | life 5 width swell 1->1@0.00->1 | tr 1.00..0.01 vis 0.40-0.80 ->1.00 | tex Stretch 1 spd None
T Trail          | tex 3230898011 | col #00FFFF | LE1 LI0 Br1 | life 5 width swell 1->1@0.00->1 | tr 1.00..0.01 vis 0.40-0.80 ->1.00 | tex Stretch 1 spd None
T Trail          | tex 3230898011 | col #00FFFF | LE1 LI0 Br1 | life 5 width swell 1->1@0.00->1 | tr 1.00..0.01 vis 0.40-0.80 ->1.00 | tex Stretch 1 spd None
T Trail          | tex 3230898011 | col #00FFFF | LE0 LI0 Br1 | life 5 width swell 1->1@0.00->1 | tr 1.00..0.01 vis 0.40-0.80 ->1.00 | tex Stretch 1 spd None
T Trail          | tex 3230898011 | col #00FFFF | LE0 LI0 Br1 | life 5 width swell 1->1@0.00->1 | tr 1.00..0.01 vis 0.40-0.80 ->1.00 | tex Stretch 1 spd None
T Trail          | tex 3230898011 | col #00FFFF | LE1 LI0 Br1 | life 5 width swell 1->1@0.00->1 | tr 1.00..0.01 vis 0.40-0.80 ->1.00 | tex Stretch 1 spd None
T Trail          | tex 3230898011 | col #00FFFF | LE0 LI0 Br1 | life 5 width swell 1->1@0.00->1 | tr 1.00..0.01 vis 0.40-0.80 ->1.00 | tex Stretch 1 spd None
T Trail          | tex 3230898011 | col #00FFFF | LE1 LI0 Br1 | life 5 width swell 1->1@0.00->1 | tr 1.00..0.01 vis 0.40-0.80 ->1.00 | tex Stretch 1 spd None
B Beam           | tex 1191605952 | col #FF0000 | LE1 LI0 Br1 | w 30-1 curve -100-0 seg 1000 face | tr flat 1.00 | tex Stretch 1 spd 0.1
B Beam           | tex 1191605952 | col #FF2E2E | LE1 LI0 Br1 | w 30-1 curve -100-0 seg 1000 face | tr flat 1.00 | tex Stretch 1 spd 0.1
B Beam           | tex 1191605952 | col #FF4E4E | LE1 LI0 Br1 | w 30-1 curve 100-0 seg 1000 face | tr flat 1.00 | tex Stretch 1 spd 0.1
B Beam           | tex 1191605952 | col #FF0000 | LE1 LI0 Br1 | w 30-1 curve 100-0 seg 1000 face | tr flat 1.00 | tex Stretch 1 spd 0.1
P {"k": "UnionOperation", "name": "Frame", "size": [56.40095, 141.00021, 56.40095], "mat": "Glass", "transp": 0.7}
P {"k": "UnionOperation", "name": "Light", "size": [45.12214, 112.79782, 45.11956], "mat": "Glass", "transp": 0.5}
P {"k": "UnionOperation", "name": "Glow", "size": [51.8905, 129.71759, 51.88753], "mat": "Neon", "transp": 0.8}
S Script Script len499 flags=delay
S Script Script len499 flags=delay
S Script Script len499 flags=delay
S Script Script len116 flags=
```
