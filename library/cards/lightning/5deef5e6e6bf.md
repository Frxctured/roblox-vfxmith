# 5deef5e6e6bf: Testing_ServerNote_in_desc.rbxl :: ServerScriptService/MiscControllers

- Category: **lightning**; tags: ice, lightning, star
- Layers: 6 emitters, 0 beams, 0 trails, 0 mesh parts, 0 lights; estimated length 6.0 s
- Fired by: saved running (Enabled + Rate)
- Pack file: `Older OS (2025 and older)/important (cool) rbx (Nov 2023)/Testing_ServerNote_in_desc.rbxl` (instance referent 37955): cut it into Studio with `kit/scripts/rbxcut.py "<pack>/Older OS (2025 and older)/important (cool) rbx (Nov 2023)/Testing_ServerNote_in_desc.rbxl" --ref 37955 --out <studio content>/vfxlib/fx_5deef5e6e6bf.rbxmx`
- Frames: none captured yet (play it with kit/studio/VFXLibPlayer.luau)

## Layers (one line each, in firing order; E emitter, B beam, T trail, P part, S script)
```
E ParticleEmitte | tex 243043229 | col #000CFF->#00FFEA | LE1 LI0 Br1 | life 1 | size swell 1.56->6.65@0.65->4.25 | tr 0.00..0.00 vis 0.00-0.36 ->1.00 | spd 3 spread 4e+04 rotSpd 400 | FacingCamera | locked | RATE 2 (continuous)
E Sparkles       | tex 1084970835 (A  ParticleEmit) | col #FFFFFF | LE1 LI0 Br1 | life 4-6 | size shrink 0.4->0.2 | tr 0.00..0.00 vis 0.00-0.93 ->1.00 | spd 1-10 drag 3 spread -360-360 acc 0-0.5-0 | FacingCamera | locked | RATE 10 (continuous) | z 1
E Circles        | tex 1084982817 (M  ParticleEmit) | col #00FFCC | LE1 LI0 Br1 | life 1.1 | size const 0.3 | tr 1.00..0.00 vis 0.10-0.10 ->1.00 | spd 20 drag 8 spread 90 | FacingCamera | RATE 8 (continuous)
E Flare          | tex 867619398 (M  Glow) | col #1100FF | LE1 LI0 Br1 | life 1 | size const 7 | tr 1.00..0.00 vis 0.10-0.10 ->1.00 | spd 0 | FacingCamera | locked | RATE 1 (continuous) | z 4
E Rays           | tex 1084975295 (A  Rays) | col #00FF48 | LE1 LI0 Br1 | life 1.5 | size swell 0->9@0.10->0 | tr 0.30..0.30 vis 0.00-0.75 ->1.00 | spd 0 rotSpd 22.5 | FacingCamera | locked | RATE 1 (continuous)
E Rays           | tex 1053548563 (A  Star1b) | col #00FF9D | LE1 LI0 Br1 | life 1 | size grow 0->10 | tr 0.40..0.40 vis 0.00-0.00 ->1.00 | spd 0 | FacingCamera | locked | RATE 8 (continuous)
P {"k": "Part", "name": "Part1", "size": [4.0, 1.0, 2.0], "mat": "Plastic", "transp": 0.0}
P {"k": "Part", "name": "Part", "size": [4.0, 1.0, 2.0], "mat": "Plastic", "transp": 0.0}
S Script PotionPurchaseTracker len17575 flags=delay
S Script StaffPassives len73709 flags=anim,bezier,debris,delay,heartbeat,raycast,remote,tween
S Script CompiledFeatures len52382 flags=anim,colorcorr,debris,delay,emit,heartbeat,remote,tween
S Script Commands len7427 flags=anim,remote
S Script MasterClockController len164 flags=heartbeat
```
