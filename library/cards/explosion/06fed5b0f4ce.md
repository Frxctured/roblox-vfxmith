# 06fed5b0f4ce: CidIAmAtomic.rbxl :: Workspace/Cid/SigilAura

- Category: **explosion**; tags: aura, beam, impact, shockwave, star
- Layers: 11 emitters, 56 beams, 0 trails, 0 mesh parts, 1 lights; estimated length 6.8 s
- Fired by: EmitCount attributes
- Pack file: `2026 OS Mar-April/CidIAmAtomic.rbxl` (instance referent 24258). Watch it in Studio: `kit/scripts/rbxcut.py --id 06fed5b0f4ce --studio`, then `P.load("fx_06fed5b0f4ce")` (needs the pack: `kit/scripts/get_pack.py`)
- Frames: none captured yet (play it with kit/studio/VFXLibPlayer.luau)

## Layers (one line each, in firing order; E emitter, B beam, T trail, P part, S script)
```
E Images/image ( | tex 135391610489057 | col #5C2C5C | LE1 LI0 Br56 | life 1.5 | size grow 0->20.6 | tr 1.00..0.61 vis 0.50-0.50 ->1.00 | spd 3.8 | VelocityParallel | squash const 1.2 | flip Grid4x4 OneShot 25 | locked | EMIT 15 @0 for 4.3 | z -11
E Images/image ( | tex 103626715828661 | col #281328 | LE1 LI0 Br35 | life 1.5 | size grow 0->8.14 | tr 1.00..0.71 vis 0.50-0.50 ->1.00 | spd 1.5 drag 1 | VelocityParallel | squash const 1 | flip Grid8x8 OneShot 25 | locked | EMIT 25 @0 for 4.3 | z -6
E Images/DoubleC | tex 125523015121474 (A  Images/Doubl) | col #5F3D60 | LE1 LI0 Br15 | life 1 | size const 3.79 | tr 1.00..0.00 vis 0.50-0.50 ->1.00 | spd 50 drag 0.5 | FacingCamera | squash const 0.9 | locked | EMIT 100 @0 for 4.3 | z 10
E Images/18      | tex 16879840263 (M  Images/18) | col #5F3D60 | LE1 LI0 Br15 | life 1 | size const 7.28 | tr 1.00..0.00 vis 0.50-0.50 ->1.00 | spd 45 drag 0.5 | FacingCamera | squash const 0.9 | locked | EMIT 30 @0 for 4.3 | z 10
E Images/1714436 | tex 17334135713 (M  OffCentered ) | col #D589D7 | LE0 LI0 Br15 | life 1.2 | size swell 0.00293->5.64@0.13->0.00293 | tr flat 0.00 | spd 50 drag 0.355 | FacingCamera | squash const 0.8 | locked | EMIT 100 @0 for 4.3 | z 10
E Hit Blunt      | tex 6820821916 (M  Hit Blunt) | col #87578A | LE0.25 LI0 Br3 | life 1 | size const 4.85 | tr 1.00..0.00 vis 0.50-0.50 ->1.00 | spd 30 drag 0.5 | FacingCamera | squash const 0.8 | locked | EMIT 100 @0 for 4.3 | z -20
E Images/56      | tex 16867490141 (M Grid4x4 Smoke) | col #613363 | LE1 LI0 Br5 | life 2.5 | size grow 0->32.6 | tr 1.00..0.76 vis 0.50-0.50 ->1.00 | spd 6.76-13.5 drag 1 | VelocityParallel | squash const 1.5 | flip Grid4x4 OneShot 25 | locked | EMIT 100 @0 for 4.3 | z 25
E 3              | tex 11799607237 (D Grid8x8 Smoke) | col #050305 | LE1 LI0 Br3 | life 1.7 | size const 40.6 | tr 1.00..0.52 vis 0.50-0.50 ->1.00 | spd 33.8 drag 1 | VelocityParallel | squash const 0.6 | flip Grid8x8 OneShot 15 | locked | EMIT 100 @0 for 4.3 | z 25
E Images/36      | tex 81229411474913 | col #331B41 | LE1 LI0 Br45 | life 1.5 | size const 96.1 | tr 1.00..0.95 vis 0.31-0.31 ->1.00 | spd 0.016 | VelocityPerpendicular | locked | EMIT 25 @0 for 4.3 | z 0.06
E Images/36      | tex 81229411474913 | col #331B41 | LE1 LI0 Br45 | life 1.5 | size const 96.1 | tr 1.00..0.95 vis 0.31-0.31 ->1.00 | spd 0.016 | VelocityPerpendicular | locked | EMIT 25 @0 for 4.3 | z 0.03
E Images/36      | tex 16878076248 | col #261427 | LE1 LI0 Br85 | life 1.5 | size const 85.4 | tr 1.00..0.95 vis 0.31-0.31 ->1.00 | spd 0.0142 | VelocityPerpendicular | locked | EMIT 25 @0 for 4.3 | z 0.01
B grid           | col #282082 | LE0.5 LI0 Br1 | w 27-26 curve 7-0 seg 10 | tr 1.00..0.91 vis 0.50-0.50 ->1.00 | tex Stretch 1 spd 0.2 | z -0.5
B Wave           | tex 18250857768 | col #431884->#292082->#282082 | LE1 LI0 Br12 | w 27-26 curve 7-0 seg 10 | tr 0.00..0.00 vis 0.00-0.48 ->1.00 | tex Wrap 12 spd 0.5 | z -0.4
B Beam           | col #282082 | LE0.5 LI0 Br0.5 | w 27-26 curve 7-0 seg 10 | tr 0.00..0.00 vis 0.00-0.00 ->1.00 | tex Stretch 1 spd 1 | z -0.5
B grid           | col #282082 | LE0.5 LI0 Br1 | w 27-26 curve 7-0 seg 10 | tr 1.00..0.91 vis 0.50-0.50 ->1.00 | tex Stretch 1 spd 0.2 | z -0.5
B Wave           | tex 18250857768 | col #431884->#292082->#282082 | LE1 LI0 Br12 | w 27-26 curve 7-0 seg 10 | tr 0.00..0.00 vis 0.00-0.48 ->1.00 | tex Wrap 12 spd 0.5 | z -0.4
B Beam           | col #282082 | LE0.5 LI0 Br0.5 | w 27-26 curve 7-0 seg 10 | tr 0.00..0.00 vis 0.00-0.00 ->1.00 | tex Stretch 1 spd 1 | z -0.5
B grid           | col #282082 | LE0.5 LI0 Br1 | w 27-26 curve 7-0 seg 10 | tr 1.00..0.91 vis 0.50-0.50 ->1.00 | tex Stretch 1 spd 0.2 | z -0.5
B Wave           | tex 18250857768 | col #431884->#292082->#282082 | LE1 LI0 Br12 | w 27-26 curve 7-0 seg 10 | tr 0.00..0.00 vis 0.00-0.48 ->1.00 | tex Wrap 12 spd 0.5 | z -0.4
B Beam           | col #282082 | LE0.5 LI0 Br0.5 | w 27-26 curve 7-0 seg 10 | tr 0.00..0.00 vis 0.00-0.00 ->1.00 | tex Stretch 1 spd 1 | z -0.5
B grid           | col #282082 | LE0.5 LI0 Br1 | w 27-26 curve 7-0 seg 10 | tr 1.00..0.91 vis 0.50-0.50 ->1.00 | tex Stretch 1 spd 0.2 | z -0.5
B Wave           | tex 18250857768 | col #431884->#292082->#282082 | LE1 LI0 Br12 | w 27-26 curve 7-0 seg 10 | tr 0.00..0.00 vis 0.00-0.48 ->1.00 | tex Wrap 12 spd 0.5 | z -0.4
B Beam           | col #282082 | LE0.5 LI0 Br0.5 | w 27-26 curve 7-0 seg 10 | tr 0.00..0.00 vis 0.00-0.00 ->1.00 | tex Stretch 1 spd 1 | z -0.5
B grid           | col #282082 | LE0.5 LI0 Br1 | w 27-26 curve 7-0 seg 10 | tr 1.00..0.91 vis 0.50-0.50 ->1.00 | tex Stretch 1 spd 0.2 | z -0.5
B Wave           | tex 18250857768 | col #431884->#292082->#282082 | LE1 LI0 Br12 | w 27-26 curve 7-0 seg 10 | tr 0.00..0.00 vis 0.00-0.48 ->1.00 | tex Wrap 12 spd 0.5 | z -0.4
B Beam           | col #282082 | LE0.5 LI0 Br0.5 | w 27-26 curve 7-0 seg 10 | tr 0.00..0.00 vis 0.00-0.00 ->1.00 | tex Stretch 1 spd 1 | z -0.5
B grid           | col #282082 | LE0.5 LI0 Br1 | w 27-26 curve 7-0 seg 10 | tr 1.00..0.91 vis 0.50-0.50 ->1.00 | tex Stretch 1 spd 0.2 | z -0.5
B Wave           | tex 18250857768 | col #431884->#292082->#282082 | LE1 LI0 Br12 | w 27-26 curve 7-0 seg 10 | tr 0.00..0.00 vis 0.00-0.48 ->1.00 | tex Wrap 12 spd 0.5 | z -0.4
B Beam           | col #282082 | LE0.5 LI0 Br0.5 | w 27-26 curve 7-0 seg 10 | tr 0.00..0.00 vis 0.00-0.00 ->1.00 | tex Stretch 1 spd 1 | z -0.5
B grid           | col #282082 | LE0.5 LI0 Br1 | w 27-26 curve 7-0 seg 10 | tr 1.00..0.91 vis 0.50-0.50 ->1.00 | tex Stretch 1 spd 0.2 | z -0.5
B Wave           | tex 18250857768 | col #431884->#292082->#282082 | LE1 LI0 Br12 | w 27-26 curve 7-0 seg 10 | tr 0.00..0.00 vis 0.00-0.48 ->1.00 | tex Wrap 12 spd 0.5 | z -0.4
B Beam           | col #282082 | LE0.5 LI0 Br0.5 | w 27-26 curve 7-0 seg 10 | tr 0.00..0.00 vis 0.00-0.00 ->1.00 | tex Stretch 1 spd 1 | z -0.5
B grid           | col #282082 | LE0.5 LI0 Br1 | w 27-26 curve 7-0 seg 10 | tr 1.00..0.91 vis 0.50-0.50 ->1.00 | tex Stretch 1 spd 0.2 | z -0.5
B Wave           | tex 18250857768 | col #431884->#292082->#282082 | LE1 LI0 Br12 | w 24.5-23.5 curve 7-0 seg 10 | tr 0.00..0.00 vis 0.00-0.48 ->1.00 | tex Wrap 12 spd 0.5 | z -0.4
B Beam           | col #282082 | LE0.5 LI0 Br0.5 | w 24.5-23.5 curve 7-0 seg 10 | tr 0.00..0.00 vis 0.00-0.00 ->1.00 | tex Stretch 1 spd 1 | z -0.5
B Wave           | tex 18250857768 | col #431884->#292082->#282082 | LE1 LI0 Br12 | w 27-26 curve 7-0 seg 10 | tr 0.00..0.00 vis 0.00-0.48 ->1.00 | tex Wrap 12 spd 0.5 | z -0.4
B grid           | col #282082 | LE0.5 LI0 Br1 | w 27-26 curve 7-0 seg 10 | tr 1.00..0.91 vis 0.50-0.50 ->1.00 | tex Stretch 1 spd 0.2 | z -0.5
B Beam           | col #282082 | LE0.5 LI0 Br0.5 | w 27-26 curve 7-0 seg 10 | tr 0.00..0.00 vis 0.00-0.00 ->1.00 | tex Stretch 1 spd 1 | z -0.5
B grid           | col #282082 | LE0.5 LI0 Br1 | w 27-26 curve 7-0 seg 10 | tr 1.00..0.91 vis 0.50-0.50 ->1.00 | tex Stretch 1 spd 0.2 | z -0.5
B Wave           | tex 18250857768 | col #431884->#292082->#282082 | LE1 LI0 Br12 | w 27-26 curve 7-0 seg 10 | tr 0.00..0.00 vis 0.00-0.48 ->1.00 | tex Wrap 12 spd 0.5 | z -0.4
B Beam           | col #282082 | LE0.5 LI0 Br0.5 | w 27-26 curve 7-0 seg 10 | tr 0.00..0.00 vis 0.00-0.00 ->1.00 | tex Stretch 1 spd 1 | z -0.5
B grid           | col #282082 | LE0.5 LI0 Br1 | w 27-26 curve 7-0 seg 10 | tr 1.00..0.91 vis 0.50-0.50 ->1.00 | tex Stretch 1 spd 0.2 | z -0.5
B Wave           | tex 18250857768 | col #431884->#292082->#282082 | LE1 LI0 Br12 | w 27-26 curve 7-0 seg 10 | tr 0.00..0.00 vis 0.00-0.48 ->1.00 | tex Wrap 12 spd 0.5 | z -0.4
B Beam           | col #282082 | LE0.5 LI0 Br0.5 | w 27-26 curve 7-0 seg 10 | tr 0.00..0.00 vis 0.00-0.00 ->1.00 | tex Stretch 1 spd 1 | z -0.5
B grid           | col #282082 | LE0.5 LI0 Br1 | w 27-26 curve 7-0 seg 10 | tr 1.00..0.91 vis 0.50-0.50 ->1.00 | tex Stretch 1 spd 0.2 | z -0.5
B Wave           | tex 18250857768 | col #431884->#292082->#282082 | LE1 LI0 Br12 | w 27-26 curve 7-0 seg 10 | tr 0.00..0.00 vis 0.00-0.48 ->1.00 | tex Wrap 12 spd 0.5 | z -0.4
B Beam           | col #282082 | LE0.5 LI0 Br0.5 | w 27-26 curve 7-0 seg 10 | tr 0.00..0.00 vis 0.00-0.00 ->1.00 | tex Stretch 1 spd 1 | z -0.5
B grid           | col #282082 | LE0.5 LI0 Br1 | w 27-26 curve 7-0 seg 10 | tr 1.00..0.91 vis 0.50-0.50 ->1.00 | tex Stretch 1 spd 0.2 | z -0.5
B Wave           | tex 18250857768 | col #431884->#292082->#282082 | LE1 LI0 Br12 | w 27-26 curve 7-0 seg 10 | tr 0.00..0.00 vis 0.00-0.48 ->1.00 | tex Wrap 12 spd 0.5 | z -0.4
B Beam           | col #282082 | LE0.5 LI0 Br0.5 | w 27-26 curve 7-0 seg 10 | tr 0.00..0.00 vis 0.00-0.00 ->1.00 | tex Stretch 1 spd 1 | z -0.5
B grid           | col #282082 | LE0.5 LI0 Br1 | w 27-26 curve 7-0 seg 10 | tr 1.00..0.91 vis 0.50-0.50 ->1.00 | tex Stretch 1 spd 0.2 | z -0.5
B Wave           | tex 18250857768 | col #431884->#292082->#282082 | LE1 LI0 Br12 | w 27-26 curve 7-0 seg 10 | tr 0.00..0.00 vis 0.00-0.48 ->1.00 | tex Wrap 12 spd 0.5 | z -0.4
B Beam           | col #282082 | LE0.5 LI0 Br0.5 | w 27-26 curve 7-0 seg 10 | tr 0.00..0.00 vis 0.00-0.00 ->1.00 | tex Stretch 1 spd 1 | z -0.5
B grid           | col #282082 | LE0.5 LI0 Br1 | w 27-26 curve 7-0 seg 10 | tr 1.00..0.91 vis 0.50-0.50 ->1.00 | tex Stretch 1 spd 0.2 | z -0.5
B Wave           | tex 18250857768 | col #431884->#292082->#282082 | LE1 LI0 Br12 | w 27-26 curve 7-0 seg 10 | tr 0.00..0.00 vis 0.00-0.48 ->1.00 | tex Wrap 12 spd 0.5 | z -0.4
B Beam           | col #282082 | LE0.5 LI0 Br0.5 | w 27-26 curve 7-0 seg 10 | tr 0.00..0.00 vis 0.00-0.00 ->1.00 | tex Stretch 1 spd 1 | z -0.5
B grid           | col #282082 | LE0.5 LI0 Br1 | w 27-26 curve 7-0 seg 10 | tr 1.00..0.91 vis 0.50-0.50 ->1.00 | tex Stretch 1 spd 0.2 | z -0.5
B Wave           | tex 18250857768 | col #431884->#292082->#282082 | LE1 LI0 Br12 | w 19.5-18.5 curve 7-0 seg 10 | tr 0.00..0.00 vis 0.00-0.48 ->1.00 | tex Wrap 12 spd 0.5 | z -0.4
B Beam           | col #282082 | LE0.5 LI0 Br0.5 | w 19.5-18.5 curve 7-0 seg 10 | tr 0.00..0.00 vis 0.00-0.00 ->1.00 | tex Stretch 1 spd 1 | z -0.5
B Beam           | tex 18250857768 | col #A64DFF | LE1 LI0 Br5 | w 0.234-51.5 curve 0-0 seg 10 | tr 1.00..0.00 vis 0.05-0.95 ->1.00 | tex Stretch 1 spd 0.5 | z 1.1 | attrs {"EmitDuration": 4.3}
B Beam           | tex 18250857768 | col #A64DFF | LE1 LI0 Br5 | w 0.234-51.5 curve 0-0 seg 10 | tr 1.00..0.00 vis 0.05-0.95 ->1.00 | tex Stretch 1 spd 0.5 | z 1.1 | attrs {"EmitDuration": 4.3}
B Beam           | tex 18250857768 | col #A64DFF | LE1 LI0 Br5 | w 0.234-51.5 curve 0-0 seg 10 | tr 1.00..0.00 vis 0.05-0.95 ->1.00 | tex Stretch 1 spd 0.5 | z 1.1 | attrs {"EmitDuration": 4.3}
B Beam           | tex 18250857768 | col #A64DFF | LE1 LI0 Br5 | w 0.234-51.5 curve 0-0 seg 10 | tr 1.00..0.00 vis 0.05-0.95 ->1.00 | tex Stretch 1 spd 0.5 | z 1.1 | attrs {"EmitDuration": 4.3}
B Beam           | tex 18250857768 | col #A64DFF | LE1 LI0 Br5 | w 0.234-51.5 curve 0-0 seg 10 | tr 1.00..0.00 vis 0.05-0.95 ->1.00 | tex Stretch 1 spd 0.5 | z 1.1 | attrs {"EmitDuration": 4.3}
B Beam           | tex 18250857768 | col #A64DFF | LE1 LI0 Br5 | w 0.234-51.5 curve 0-0 seg 10 | tr 1.00..0.00 vis 0.05-0.95 ->1.00 | tex Stretch 1 spd 0.5 | z 1.1 | attrs {"EmitDuration": 4.3}
B Beam           | tex 18250857768 | col #A64DFF | LE1 LI0 Br5 | w 0.234-51.5 curve 0-0 seg 10 | tr 1.00..0.00 vis 0.05-0.95 ->1.00 | tex Stretch 1 spd 0.5 | z 1.1 | attrs {"EmitDuration": 4.3}
B Beam           | tex 18250857768 | col #A64DFF | LE1 LI0 Br5 | w 0.234-51.5 curve 0-0 seg 10 | tr 1.00..0.00 vis 0.05-0.95 ->1.00 | tex Stretch 1 spd 0.5 | z 1.1 | attrs {"EmitDuration": 4.3}
S Script Script len954 flags=delay
S Script Script len954 flags=delay
S Script Script len954 flags=delay
S Script Script len954 flags=delay
S Script Script len954 flags=delay
S Script Script len954 flags=delay
S Script Script len954 flags=delay
S Script Script len954 flags=delay
S Script Script len954 flags=delay
S Script Script len954 flags=delay
S Script Script len954 flags=delay
S Script Script len954 flags=delay
S Script Script len954 flags=delay
S Script Script len954 flags=delay
S Script Script len954 flags=delay
S Script Script len954 flags=delay
S Script Script len954 flags=delay
S Script Script len954 flags=delay
S Script Script len954 flags=delay
S Script Script len954 flags=delay
S Script Script len954 flags=delay
S Script Script len954 flags=delay
S Script Script len954 flags=delay
S Script Script len954 flags=delay
S Script Script len954 flags=delay
S Script Script len954 flags=delay
S Script Script len954 flags=delay
S Script Script len954 flags=delay
S Script Script len954 flags=delay
S Script Script len954 flags=delay
S Script Script len954 flags=delay
S Script Script len954 flags=delay
S Script Script len954 flags=delay
S Script Script len954 flags=delay
S Script Script len954 flags=delay
S Script Script len954 flags=delay
S Script Script len954 flags=delay
S Script Script len954 flags=delay
S Script Script len954 flags=delay
S Script Script len954 flags=delay
S Script Script len954 flags=delay
S Script Script len954 flags=delay
S Script Script len954 flags=delay
S Script Script len954 flags=delay
S Script Script len954 flags=delay
S Script Script len954 flags=delay
S Script Script len954 flags=delay
S Script Script len954 flags=delay
S Script Script len1832 flags=delay
S Script Script len1832 flags=delay
S Script Script len1832 flags=delay
S Script Script len1832 flags=delay
S Script Script len1832 flags=delay
S Script Script len1832 flags=delay
S Script Script len1832 flags=delay
S Script Script len1832 flags=delay
```
