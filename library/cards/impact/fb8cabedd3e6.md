# fb8cabedd3e6: Testing_ServerNote_in_desc.rbxl :: ServerStorage/Elements/Telekenesis

- Category: **impact**; tags: aura, flash, lightning, portal, shockwave
- Layers: 60 emitters, 0 beams, 2 trails, 2 mesh parts, 9 lights; estimated length 4.0 s
- Fired by: saved running (Enabled + Rate)
- Pack file: `Older OS (2025 and older)/important (cool) rbx (Nov 2023)/Testing_ServerNote_in_desc.rbxl` (instance referent 44689): cut it into Studio with `kit/scripts/rbxcut.py "<pack>/Older OS (2025 and older)/important (cool) rbx (Nov 2023)/Testing_ServerNote_in_desc.rbxl" --ref 44689 --out <studio content>/vfxlib/fx_fb8cabedd3e6.rbxmx`
- Frames: none captured yet (play it with kit/studio/VFXLibPlayer.luau)

## Layers (one line each, in firing order; E emitter, B beam, T trail, P part, S script)
```
E Effect         | tex 243728104 | col #2EFF00->#0E5F00 | LE0.75 LI0 Br1 | life 1-2 | size swell 0->10@0.70->0 | tr 0.00..0.00 vis 0.00-0.00 ->1.00 | spd 1 drag 1.5 spread -15-15 rotSpd 25-100 | FacingCamera | RATE 50 (continuous)
E Bolts          | tex 1084959112 | col #11FF00 | LE1 LI0 Br1 | life 0.333 | size const 1.25 | tr 0.88..0.13 vis 0.22-0.22 ->1.00 | spd 0 | FacingCamera | locked | RATE 6 (continuous)
E Bolts          | tex 1084959312 (A  Bolts) | col #00FF08 | LE1 LI0 Br1 | life 0.333 | size const 1 | tr 0.88..0.13 vis 0.22-0.22 ->1.00 | spd 0 | FacingCamera | locked | RATE 6 (continuous)
E Core           | tex 867619398 (M  Glow) | col #0CFF00 | LE1 LI0 Br1 | life 1 | size const 0.5 | tr 1.00..0.00 vis 0.50-0.50 ->1.00 | spd 0 | FacingCamera | locked | RATE 3 (continuous)
E Bolts          | tex 1084959583 | col #00FF15 | LE1 LI0 Br1 | life 0.333 | size const 0.7 | tr 0.88..0.13 vis 0.22-0.22 ->1.00 | spd 0 | FacingCamera | locked | RATE 6 (continuous)
E Glow           | tex 867619398 (M  Glow) | col #22FF00 | LE1 LI0 Br1 | life 1 | size const 1.2 | tr 1.00..0.72 vis 0.50-0.50 ->1.00 | spd 0 | FacingCamera | locked | RATE 3 (continuous)
E ParticleEmitte | tex 243043229 | col #D5FF00->#00FF1D | LE1 LI0 Br1 | life 1 | size swell 1.56->1.94@1.00->1.94 | tr 0.00..0.00 vis 0.00-0.36 ->0.25 | spd 3 spread 4e+04 rotSpd 400 | FacingCamera | RATE 30 (continuous)
E Wave           | tex 1084977655 | col #37FF00 | LE1 LI0 Br1 | life 1 | size grow 0->10 | tr 0.00..0.00 vis 0.00-0.50 ->1.00 | spd 0 rotSpd -100-100 | FacingCamera | locked | RATE 3 (continuous) | z -0.001
E Rays           | tex 1084975295 (A  Rays) | col #1C550B | LE1 LI0 Br1 | life 1 | size const 210 | tr 1.00..0.70 vis 0.50-0.50 ->1.00 | spd 0 rotSpd 60 | FacingCamera | locked | RATE 4 (continuous) | z -0.001
E Glow           | tex 867619398 (M  Glow) | col #00FF1D | LE1 LI0 Br1 | life 2 | size const 210 | tr 1.00..0.50 vis 0.50-0.50 ->1.00 | spd 0 | FacingCamera | locked | RATE 0.8 (continuous) | z 0.002
E Wave           | tex 1084977655 | col #37FF00 | LE1 LI0 Br1 | life 1 | size const 0 | tr 0.00..0.00 vis 0.00-0.50 ->1.00 | spd 0 rotSpd -100-100 | FacingCamera | locked | RATE 3 (continuous) | z -0.001
E Glow           | tex 867619398 (M  Glow) | col #00FF1D | LE1 LI0 Br1 | life 2 | size const 10 | tr 1.00..0.50 vis 0.50-0.50 ->1.00 | spd 0 | FacingCamera | locked | RATE 0.8 (continuous) | z 0.002
E Rays           | tex 1084975295 (A  Rays) | col #1C550B | LE1 LI0 Br1 | life 1 | size const 10 | tr 1.00..0.70 vis 0.50-0.50 ->1.00 | spd 0 rotSpd 60 | FacingCamera | locked | RATE 4 (continuous) | z -0.001
E ParticleEmitte | tex 243043229 | col #30FF02 | LE1 LI0 Br1 | life 1 | size swell 1.56->2.75@0.25->1.75 | tr 0.00..0.00 vis 0.00-0.36 ->0.25 | spd 3 spread 4e+04 rotSpd 400 | FacingCamera | RATE 30 (continuous)
E Rays           | tex 1053548563 (A  Star1b) | col #0CFF00 | LE1 LI0 Br1 | life 1-1.5 | size grow 0->10 | tr 0.70..0.70 vis 0.00-0.50 ->1.00 | spd 0 | FacingCamera | locked
E Vortex         | tex 1084969997 | col #11FF00 | LE1 LI0 Br1 | life 4 | size shrink 10->0 | tr 1.00..0.50 vis 0.30-1.00 ->0.50 | spd 0 rotSpd 360 | FacingCamera | locked | RATE 3 (continuous)
E Glow           | tex 867619398 (M  Glow) | col #11FF00 | LE1 LI0 Br1 | life 1 | size const 25 | tr 1.00..0.50 vis 0.50-0.50 ->1.00 | spd 0 | FacingCamera | locked | RATE 3 (continuous)
E Vortex_Bits    | tex 1084969783 (M  Vortex_Bits) | col #00FF08 | LE1 LI0 Br1 | life 0.6-1 | size shrink 10->0 | tr 1.00..0.50 vis 0.20-1.00 ->0.50 | spd 0 | FacingCamera | locked | RATE 4 (continuous)
E Puff           | tex 1084987899 (D  ParticleEmit) | col #096200 | LE0 LI0 Br1 | life 0.3-0.7 | size const 2 | tr 0.00..0.00 vis 0.00-0.50 ->1.00 | spd 90 drag 8 spread 90 acc 0-2-0 | FacingCamera | RATE 4 (continuous) | z -0.001
E Shockwave      | tex 1084991215 (A  Shield1) | col #FFFFFF | LE1 LI0 Br1 | life 0.3 | size grow 0->10 | tr 0.40..0.40 vis 0.00-0.00 ->1.00 | spd 0 | FacingCamera | RATE 1 (continuous)
E Puff           | tex 1084987899 (D  ParticleEmit) | col #144200 | LE0 LI0 Br1 | life 1 | size const 2 | tr 0.00..0.00 vis 0.00-0.70 ->1.00 | spd 300 drag 15 spread 90 acc 0-2-0 | FacingCamera | RATE 8 (continuous)
E Bolts          | tex 1084959112 | col #11FF00 | LE1 LI0 Br1 | life 0.333 | size const 1.25 | tr 0.88..0.13 vis 0.22-0.22 ->1.00 | spd 0 | FacingCamera | locked | RATE 6 (continuous)
E Bolts          | tex 1084959312 (A  Bolts) | col #00FF08 | LE1 LI0 Br1 | life 0.333 | size const 1 | tr 0.88..0.13 vis 0.22-0.22 ->1.00 | spd 0 | FacingCamera | locked | RATE 6 (continuous)
E Core           | tex 867619398 (M  Glow) | col #0CFF00 | LE1 LI0 Br1 | life 1 | size const 0.5 | tr 1.00..0.00 vis 0.50-0.50 ->1.00 | spd 0 | FacingCamera | locked | RATE 3 (continuous)
E Bolts          | tex 1084959583 | col #00FF15 | LE1 LI0 Br1 | life 0.333 | size const 0.7 | tr 0.88..0.13 vis 0.22-0.22 ->1.00 | spd 0 | FacingCamera | locked | RATE 6 (continuous)
E Glow           | tex 867619398 (M  Glow) | col #22FF00 | LE1 LI0 Br1 | life 1 | size const 1.2 | tr 1.00..0.72 vis 0.50-0.50 ->1.00 | spd 0 | FacingCamera | locked | RATE 3 (continuous)
E Wave           | tex 1084977655 | col #37FF00 | LE1 LI0 Br1 | life 1 | size const 0 | tr 0.00..0.00 vis 0.00-0.50 ->1.00 | spd 0 rotSpd -100-100 | FacingCamera | locked | RATE 3 (continuous) | z -0.001
E Glow           | tex 867619398 (M  Glow) | col #00FF1D | LE1 LI0 Br1 | life 2 | size const 3 | tr 1.00..0.50 vis 0.50-0.50 ->1.00 | spd 0 | FacingCamera | locked | RATE 0.8 (continuous) | z 0.002
E Rays           | tex 1084975295 (A  Rays) | col #1C550B | LE1 LI0 Br1 | life 1 | size const 3 | tr 1.00..0.70 vis 0.50-0.50 ->1.00 | spd 0 rotSpd 60 | FacingCamera | locked | RATE 4 (continuous) | z -0.001
E Wave           | tex 1084977655 | col #37FF00 | LE1 LI0 Br1 | life 1 | size grow 0->10 | tr 0.00..0.00 vis 0.00-0.50 ->1.00 | spd 0 rotSpd -100-100 | FacingCamera | locked | RATE 3 (continuous) | z -0.001
E Rays           | tex 1084975295 (A  Rays) | col #1C550B | LE1 LI0 Br1 | life 1 | size const 60 | tr 1.00..0.70 vis 0.50-0.50 ->1.00 | spd 0 rotSpd 60 | FacingCamera | locked | RATE 4 (continuous) | z -0.001
E Glow           | tex 867619398 (M  Glow) | col #00FF1D | LE1 LI0 Br1 | life 2 | size const 60 | tr 1.00..0.50 vis 0.50-0.50 ->1.00 | spd 0 | FacingCamera | locked | RATE 0.8 (continuous) | z 0.002
E Effect         | tex 243728104 | col #2EFF00->#0E5F00 | LE0.75 LI0 Br1 | life 1-2 | size swell 0->2.56@0.10->0 | tr 0.00..0.00 vis 0.00-0.00 ->1.00 | spd 1 drag 1.5 spread -15-15 rotSpd 25-100 | FacingCamera | RATE 50 (continuous)
E Wave           | tex 1084977655 | col #37FF00 | LE1 LI0 Br1 | life 1 | size const 0 | tr 0.00..0.00 vis 0.00-0.50 ->1.00 | spd 0 rotSpd -100-100 | FacingCamera | locked | RATE 3 (continuous) | z -0.001
E Glow           | tex 867619398 (M  Glow) | col #00FF1D | LE1 LI0 Br1 | life 2 | size const 10 | tr 1.00..0.50 vis 0.50-0.50 ->1.00 | spd 0 | FacingCamera | locked | RATE 0.8 (continuous) | z 0.002
E Rays           | tex 1084975295 (A  Rays) | col #1C550B | LE1 LI0 Br1 | life 1 | size const 10 | tr 1.00..0.70 vis 0.50-0.50 ->1.00 | spd 0 rotSpd 60 | FacingCamera | locked | RATE 4 (continuous) | z -0.001
E ParticleEmitte | tex 243043229 | col #30FF02 | LE1 LI0 Br1 | life 1 | size swell 1.56->2.75@0.25->1.75 | tr 0.00..0.00 vis 0.00-0.36 ->0.25 | spd 3 spread 4e+04 rotSpd 400 | FacingCamera | RATE 30 (continuous)
E Wave           | tex 1084977655 | col #37FF00 | LE1 LI0 Br1 | life 1 | size grow 0->10 | tr 0.00..0.00 vis 0.00-0.50 ->1.00 | spd 0 rotSpd -100-100 | FacingCamera | locked | RATE 3 (continuous) | z -0.001
E Rays           | tex 1084975295 (A  Rays) | col #1C550B | LE1 LI0 Br1 | life 1 | size const 60 | tr 1.00..0.70 vis 0.50-0.50 ->1.00 | spd 0 rotSpd 60 | FacingCamera | locked | RATE 4 (continuous) | z -0.001
E Glow           | tex 867619398 (M  Glow) | col #00FF1D | LE1 LI0 Br1 | life 2 | size const 60 | tr 1.00..0.50 vis 0.50-0.50 ->1.00 | spd 0 | FacingCamera | locked | RATE 0.8 (continuous) | z 0.002
E Effect         | tex 243728104 | col #2EFF00->#0E5F00 | LE0.75 LI0 Br1 | life 1-2 | size swell 0->2.56@0.10->0 | tr 0.00..0.00 vis 0.00-0.00 ->1.00 | spd 1 drag 1.5 spread -15-15 rotSpd 25-100 | FacingCamera | RATE 50 (continuous)
E Wave           | tex 1084977655 | col #37FF00 | LE1 LI0 Br1 | life 1 | size const 0 | tr 0.00..0.00 vis 0.00-0.50 ->1.00 | spd 0 rotSpd -100-100 | FacingCamera | locked | RATE 3 (continuous) | z -0.001
E Rays           | tex 1084975295 (A  Rays) | col #1C550B | LE1 LI0 Br1 | life 1 | size const 60 | tr 1.00..0.70 vis 0.50-0.50 ->1.00 | spd 0 rotSpd 60 | FacingCamera | locked | RATE 4 (continuous) | z -0.001
E Glow           | tex 867619398 (M  Glow) | col #00FF1D | LE1 LI0 Br1 | life 2 | size const 60 | tr 1.00..0.50 vis 0.50-0.50 ->1.00 | spd 0 | FacingCamera | locked | RATE 0.8 (continuous) | z 0.002
E 2 Efeito       | tex 243043091 | col #005E0C | LE1 LI0 Br1 | life 1 | size const 4.5 | tr flat 0.00 | spd 4 spread 15-30 rotSpd 100 | FacingCamera | locked | RATE 10 (continuous)
E aura 1         | tex 250186345 (A  aura 2) | col #37FF00->#125500 | LE1 LI0 Br1 | life 0.22 | size const 4 | tr flat 0.30 | spd 20 | FacingCamera | locked | RATE 40 (continuous) | z -0.2
E aura 2         | tex 250186345 (A  aura 2) | col #004F02 | LE0.7 LI0 Br1 | life 0.25 | size const 6 | tr flat 0.30 | spd 20 | FacingCamera | locked | RATE 50 (continuous) | z -0.3
E aura de fundo  | tex 530839385 | col #0CFF00 | LE1 LI0 Br1 | life 0.4 | size swell 0->8.12@0.45->0 | tr flat 0.90 | spd 12 spread 5 | FacingCamera | locked | RATE 60 (continuous)
E Effect         | tex 243728104 | col #2EFF00->#0E5F00 | LE0.75 LI0 Br1 | life 1-2 | size swell 0->2.56@0.10->0 | tr 0.00..0.00 vis 0.00-0.00 ->1.00 | spd 1 drag 1.5 spread -15-15 rotSpd 25-100 | FacingCamera | RATE 50 (continuous)
E Wave           | tex 1084977655 | col #37FF00 | LE1 LI0 Br1 | life 1 | size grow 0->10 | tr 0.00..0.00 vis 0.00-0.50 ->1.00 | spd 0 rotSpd -100-100 | FacingCamera | locked | RATE 3 (continuous) | z -0.001
E Rays           | tex 1084975295 (A  Rays) | col #1C550B | LE1 LI0 Br1 | life 1 | size const 10 | tr 1.00..0.70 vis 0.50-0.50 ->1.00 | spd 0 rotSpd 60 | FacingCamera | locked | RATE 4 (continuous) | z -0.001
E Glow           | tex 867619398 (M  Glow) | col #00FF1D | LE1 LI0 Br1 | life 2 | size const 10 | tr 1.00..0.50 vis 0.50-0.50 ->1.00 | spd 0 | FacingCamera | locked | RATE 0.8 (continuous) | z 0.002
E ParticleEmitte | tex 243043229 | col #D5FF00->#00FF1D | LE1 LI0 Br1 | life 1 | size swell 1.56->1.94@1.00->1.94 | tr 0.00..0.00 vis 0.00-0.36 ->0.25 | spd 3 spread 4e+04 rotSpd 400 | FacingCamera | RATE 30 (continuous)
E ParticleEmitte | tex 243043229 | col #D5FF00->#00FF1D | LE1 LI0 Br1 | life 1 | size swell 1.56->1.94@1.00->1.94 | tr 0.00..0.00 vis 0.00-0.36 ->0.25 | spd 3 spread 4e+04 rotSpd 400 | FacingCamera | RATE 30 (continuous)
E ParticleEmitte | tex 243043229 | col #D5FF00->#00FF1D | LE1 LI0 Br1 | life 1 | size swell 1.56->1.94@1.00->1.94 | tr 0.00..0.00 vis 0.00-0.36 ->0.25 | spd 3 spread 4e+04 rotSpd 400 | FacingCamera | RATE 30 (continuous)
E ParticleEmitte | tex 243043229 | col #D5FF00->#00FF1D | LE1 LI0 Br1 | life 1 | size swell 1.56->1.94@1.00->1.94 | tr 0.00..0.00 vis 0.00-0.36 ->0.25 | spd 3 spread 4e+04 rotSpd 400 | FacingCamera | RATE 30 (continuous)
E ParticleEmitte | tex 243043229 | col #D5FF00->#00FF1D | LE1 LI0 Br1 | life 1 | size swell 1.56->1.94@1.00->1.94 | tr 0.00..0.00 vis 0.00-0.36 ->0.25 | spd 3 spread 4e+04 rotSpd 400 | FacingCamera | RATE 30 (continuous)
E ParticleEmitte | tex 243043229 | col #D5FF00->#00FF1D | LE1 LI0 Br1 | life 1 | size swell 1.56->1.94@1.00->1.94 | tr 0.00..0.00 vis 0.00-0.36 ->0.25 | spd 3 spread 4e+04 rotSpd 400 | FacingCamera | RATE 30 (continuous)
E ParticleEmitte | tex 243043229 | col #D5FF00->#00FF1D | LE1 LI0 Br1 | life 1 | size swell 1.56->1.94@1.00->1.94 | tr 0.00..0.00 vis 0.00-0.36 ->0.25 | spd 3 spread 4e+04 rotSpd 400 | FacingCamera | RATE 30 (continuous)
E ParticleEmitte | tex 243043229 | col #D5FF00->#00FF1D | LE1 LI0 Br1 | life 1 | size swell 1.56->1.94@1.00->1.94 | tr 0.00..0.00 vis 0.00-0.36 ->0.25 | spd 3 spread 4e+04 rotSpd 400 | FacingCamera | RATE 30 (continuous)
T Trail          | tex 176137575 | col #44FF00->#2A8700 | LE0 LI1 Br1 | life 2 width const 1 | tr flat 0.50 | tex Stretch 1 spd None
T Trail          | tex 176137575 | col #44FF00->#2A8700 | LE0 LI1 Br1 | life 2 width const 1 | tr flat 0.50 | tex Stretch 1 spd None
P {"k": "Part", "name": "AttachmentsStorage", "size": [4.0, 1.0, 2.0], "mat": "Plastic", "transp": 0.0}
P {"k": "Part", "name": "Bullet", "size": [1.0, 1.0, 1.0], "mat": "Neon", "transp": 0.0}
P {"k": "Part", "name": "Explosion", "size": [0.05, 0.05, 0.05], "mat": "Neon", "transp": 0.3}
P {"k": "Part", "name": "Explosion", "size": [0.05, 0.05, 0.05], "mat": "Neon", "transp": 0.0}
P {"k": "MeshPart", "name": "Blast", "size": [0.05, 120.0, 0.05], "mat": "Neon", "transp": 1.0, "mesh": 489415447}
P {"k": "Part", "name": "IDK", "size": [0.05, 0.05, 0.05], "mat": "Neon", "transp": 0.0}
P {"k": "MeshPart", "name": "Shockwave", "size": [100.0, 2.0, 100.0], "mat": "Neon", "transp": 1.0, "mesh": 20329976}
P {"k": "Part", "name": "Impact", "size": [0.05, 0.05, 0.05], "mat": "Plastic", "transp": 0.3}
P {"k": "SpecialMesh", "name": "Mesh", "mesh": 9982590, "meshTex": null, "scale": [6.0, 6.0, 6.0]}
P {"k": "Part", "name": "Part", "size": [4.0, 1.0, 2.0], "mat": "Plastic", "transp": 0.0}
P {"k": "Part", "name": "Explosion", "size": [0.05, 0.05, 0.05], "mat": "Neon", "transp": 0.3}
P {"k": "Part", "name": "Explosion", "size": [0.05, 0.05, 0.05], "mat": "Neon", "transp": 0.0}
P {"k": "Part", "name": "TProjectile", "size": [2.8, 2.8, 2.8], "mat": "Neon", "transp": 0.0}
P {"k": "Part", "name": "Explosion", "size": [0.05, 0.05, 0.05], "mat": "Neon", "transp": 0.3}
P {"k": "Part", "name": "Explosion", "size": [0.05, 0.05, 0.05], "mat": "Neon", "transp": 0.0}
P {"k": "Part", "name": "Explosion", "size": [8.0, 8.0, 8.0], "mat": "Neon", "transp": 0.3}
P {"k": "Part", "name": "Explosion", "size": [8.0, 8.0, 8.0], "mat": "Neon", "transp": 0.0}
P {"k": "Part", "name": "Bullet7", "size": [0.5, 0.5, 0.5], "mat": "Neon", "transp": 0.0}
P {"k": "Part", "name": "Bullet4", "size": [0.5, 0.5, 0.5], "mat": "Neon", "transp": 0.0}
P {"k": "Part", "name": "Bullet8", "size": [0.5, 0.5, 0.5], "mat": "Neon", "transp": 0.0}
S Script PlrDespawn len354 flags=delay
S Script Orbit len717 flags=debris,delay,tween
S Script TeleDamage len2663 flags=anim,debris,delay,tween
S Script Script len102 flags=
S Script Script len449 flags=delay,remote
S Script Script len75 flags=debris,delay
S Script Script len588 flags=
S Script Script len813 flags=anim,tween
S Script Script len1933 flags=anim,debris,delay,remote,tween
S Script Script len117 flags=
S Script Script len2248 flags=anim,delay,tween
S Script Tween len912 flags=anim,delay,tween
S Script Script len115 flags=
S Script Script len115 flags=
S Script Script len115 flags=
S Script Script len115 flags=
S Script Script len172 flags=
S Script Tween len598 flags=anim,delay,tween
S Script Second len1097 flags=anim,delay,tween
S Script Script len1132 flags=anim,debris,delay,tween
S Script Fade len137 flags=delay
S Script Script len495 flags=anim,delay
S Script Tween len764 flags=anim,delay,tween
S Script Script len65 flags=delay
S Script Script len115 flags=
S Script Script len51 flags=debris
S Script Script len214 flags=
S Script Script len114 flags=
S Script Script len2086 flags=anim,debris,delay,tween
S Script Script len115 flags=
S Script Script len102 flags=
S Script Script len172 flags=remote
S Script RemoveScript len22 flags=
S Script Script len990 flags=delay
S Script Script len115 flags=
S Script Damage len949 flags=debris,delay,remote,shake
S Script Script len2086 flags=anim,debris,delay,tween
S Script Script len115 flags=
S LocalScript Movement len575 flags=delay,remote
S Script Script len102 flags=
S Script Damage len925 flags=debris,delay,remote,shake
S Script Script len1459 flags=anim,debris,delay,tween
S Script Script len115 flags=
S Script Script len117 flags=delay
S Script Script len97 flags=
S Script Damage len563 flags=delay,remote,shake
S Script Script len1391 flags=anim,debris,delay,tween
S Script Script len489 flags=remote
S Script Script len667 flags=delay
S Script TweenScript len358 flags=anim,tween
S Script Script len667 flags=delay
S Script TweenScript len358 flags=anim,tween
S Script Script len667 flags=delay
S Script TweenScript len358 flags=anim,tween
S Script Script len667 flags=delay
S Script TweenScript len358 flags=anim,tween
S Script Script len667 flags=delay
S Script TweenScript len358 flags=anim,tween
S Script Script len667 flags=delay
S Script TweenScript len358 flags=anim,tween
S Script Script len667 flags=delay
S Script TweenScript len358 flags=anim,tween
S Script Script len667 flags=delay
S Script TweenScript len358 flags=anim,tween
```
