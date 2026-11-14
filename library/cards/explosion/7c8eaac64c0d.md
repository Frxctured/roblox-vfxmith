# 7c8eaac64c0d: EVENT PLACE.rbxl :: ReplicatedFirst/Content/ContentProvider/Event/Explode

- Category: **explosion**; tags: explosion, flash, projectile, smoke, star
- Layers: 13 emitters, 0 beams, 0 trails, 0 mesh parts, 1 lights; estimated length 2.4 s
- Fired by: EmitCount attributes
- Pack file: `190 OS (Oct 2024-Mar 2026)/EVENT PLACE.rbxl` (instance referent 447). Watch it in Studio: `kit/scripts/rbxcut.py --id 7c8eaac64c0d --studio`, then `P.load("fx_7c8eaac64c0d")` (needs the pack: `kit/scripts/get_pack.py`)
- Frames: none captured yet (play it with kit/studio/VFXLibPlayer.luau)

## Layers (one line each, in firing order; E emitter, B beam, T trail, P part, S script)
```
E Wiggly Ball    | tex 17062426399 (A Grid4x4 Star4) | col #FF46FF | LE0 LI0 Br15 | life 0.3-1.2 | size shrink 3.79->0 | tr flat 0.00 | spd 90-100 drag 1 spread -360-360 acc 0--25-0 | FacingCamera | flip Grid4x4 OneShot 35 | EMIT 8 @0 | z 1
E Flash          | tex 77024587778878 (M  Basic Blurry) | col #FF26D0->#FF8E31 | LE1 LI0 Br5 | life 0.035 | size grow 0->77.3 | tr flat 0.00 | spd 0 | FacingCamera | EMIT 1 @0 | z 8
E d              | tex 17612128831 (D Grid4x4 Fast spiky w) | col #FF6638 | LE-2 LI0 Br25 | life 0.3 | size grow 0->69.6 | tr flat 0.00 | spd 0 | FacingCamera | flip Grid4x4 OneShot 30 | EMIT 1 @0 | z 4 | attrs {"_vfxEditorGraphSize": "[{\"envelope\":0,\"direction\":\"InOut\",\"inde"}
E c              | tex 16879949189 (M Grid4x4 Impact1) | col #E734FF | LE-2 LI0 Br15 | life 0.3 | size grow 0->90.6 | tr flat 0.00 | spd 0 | FacingCamera | flip Grid4x4 OneShot 30 | EMIT 1 @0 | z 3 | attrs {"_vfxEditorGraphSize": "[{\"envelope\":0,\"direction\":\"InOut\",\"inde"}
E Blur           | tex 109985324958700 | col #FF2BFF | LE1 LI0 Br55 | life 0.07 | size grow 0->119 | tr flat 0.00 | spd 0 | FacingCamera | locked | EMIT 1 @0 | z -1 | attrs {"_vfxEditorGraphSize": "[{\"envelope\":0,\"direction\":\"InOut\",\"inde"}
E Wiggly Ball    | tex 14004161351 (D Grid4x4 Wiggly Ball) | col #FFAE4B | LE0 LI0 Br5 | life 0.3-1.2 | size shrink 3.79->0 | tr flat 0.00 | spd 90.9-303 drag 4 spread -360-360 acc 0--18.2-0 | VelocityParallel | squash const 1 | flip Grid4x4 Loop 35 | EMIT 10 @0 | z -0.1
E b              | tex 18140248952 (D Grid4x4 Circular Sma) | col #FFA946->#3B2C17->#110A06 | LE0 LI0 Br15 | life 0.3 | size const 37.6 | tr flat 0.00 | spd 0 | FacingCamera | flip Grid4x4 OneShot 1 | EMIT 1 @0 | z 5
E a              | tex 115257157082446 (M Grid4x4 Impact61) | col #B433FF | LE-1 LI0 Br10 | life 0.2 | size const 57.7 | tr flat 0.00 | spd 0 | FacingCamera | flip Grid4x4 OneShot 1 | EMIT 1 @0 | z 1
E Basic Blurry S | tex 77024587778878 (M  Basic Blurry) | col #FFC86A->#4F3EAF->#031107 | LE0 LI0 Br7 | life 0.3 | size grow 0->76.3 | tr 0.54..0.54 vis 0.00-0.00 ->1.00 | spd 0 | FacingCamera | EMIT 1 @0 | z -3.1
E Line           | tex 16879838922 (D  Spec39) | col #FF8446 | LE0 LI0 Br15 | life 0.1-0.2 | size swell 2.82->24.5@0.11->6.13 | tr flat 0.00 | spd 171-205 spread 360--360 acc 0--85.3-0 | VelocityParallel | locked | EMIT 17 @0 | z 5 | attrs {"_vfxEditorGraphSize": "[{\"envelope\":0,\"direction\":\"InOut\",\"inde", "_vfxEditorGraphTransparency": "[{\"envelope\
E stars          | tex 9533204568 | col #1C27FF | LE1 LI0 Br10 | life 1-2 | size swell 1.65->14.3@0.11->3.6 | tr flat 0.00 | spd 100-120 spread 360--360 acc 0--120-0 rotSpd -80-80 | FacingCamera | flip Grid8x8 OneShot 5 | locked | EMIT 25 @0 | z 5 | attrs {"_vfxEditorGraphSize": "[{\"envelope\":0,\"direction\":\"InOut\",\"inde", "_vfxEditorGraphTransparency": "[{\"envelope\
E BigBLur        | tex 77024587778878 (M  Basic Blurry) | col #856FFF->#FF52CB->#8345FF | LE0 LI0 Br3 | life 0.5 | size const 63.2 | tr 1.00..0.76 vis 0.28-0.45 ->1.00 | spd 0 | FacingCamera | locked | EMIT 3 @0 | z -1 | attrs {"_vfxEditorGraphSize": "[{\"envelope\":0,\"direction\":\"InOut\",\"inde", "_vfxEditorGraphTransparency": "[{\"envelope\
E Smoke          | tex 16172858603 (M Grid4x4 Greyish Smok) | col #966DFF->#C43FCD->#FF59FF | LE0 LI0 Br1 | life 1.5-2 | size grow 0->96.1 | tr 0.86..0.86 vis 0.00-0.22 ->1.00 | spd 25-40 drag 1 spread -360-360 | FacingCamera | flip Grid4x4 OneShot 30 | EMIT 12 @0.4 | attrs {"_vfxEditorGraphSize": "[{\"envelope\":0,\"direction\":\"InOut\",\"inde", "_vfxEditorGraphTransparency": "[{\"envelope\
```
