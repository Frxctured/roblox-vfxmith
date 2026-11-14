# 0faed0c3bd55: Testing_ServerNote_in_desc.rbxl :: ReplicatedStorage/ReplicatedAssets

- Category: **beam**; tags: beam, fire, flash, lightning, shockwave, star, water
- Layers: 46 emitters, 2 beams, 13 trails, 20 mesh parts, 0 lights; estimated length 10.0 s
- Fired by: saved running (Enabled + Rate)
- Pack file: `Older OS (2025 and older)/important (cool) rbx (Nov 2023)/Testing_ServerNote_in_desc.rbxl` (instance referent 54845). Watch it in Studio: `kit/scripts/rbxcut.py --id 0faed0c3bd55 --studio`, then `P.load("fx_0faed0c3bd55")` (needs the pack: `kit/scripts/get_pack.py`)
- Frames: none captured yet (play it with kit/studio/VFXLibPlayer.luau)

## Layers (one line each, in firing order; E emitter, B beam, T trail, P part, S script)
```
E BlueFire       | tex 348467696 (A  BlueFire) | col #FFFFFF | LE1 LI0 Br1 | life 1 | size shrink 2.08->0 | tr 0.87..0.47 vis 0.50-0.50 ->1.00 | spd 2 | FacingCamera | RATE 100 (continuous)
E BlueFire       | tex 348467696 (A  BlueFire) | col #FFFFFF | LE1 LI0 Br1 | life 1 | size shrink 2.08->0 | tr 0.87..0.47 vis 0.50-0.50 ->1.00 | spd 6 | FacingCamera | RATE 100 (continuous)
E ParticleEmitte | tex 347504241 | col #11FF00 | LE0 LI0 Br1 | life 0.5-1.5 | size swell 1->3.25@1.00->3.25 | tr 0.00..0.00 vis 0.00-0.00 ->0.91 | spd 75 drag 2 spread -360-360 rotSpd 500 | FacingCamera | RATE 20 (continuous)
E ParticleEmitte | tex 347504259 | col #04FF00 | LE0 LI0 Br1 | life 0.5-1.5 | size swell 1.19->4.56@1.00->4.56 | tr 0.00..0.00 vis 0.00-0.00 ->0.95 | spd 75 drag 2 spread -360-360 rotSpd 500 | FacingCamera | RATE 20 (continuous)
E Effect         | tex 243728104 | col #2EFF00->#0E5F00 | LE0.75 LI0 Br1 | life 1-2 | size swell 0->10@0.70->0 | tr 0.00..0.00 vis 0.00-0.00 ->1.00 | spd 1 drag 1.5 spread -15-15 rotSpd 25-100 | FacingCamera | RATE 50 (continuous)
E Effect         | tex 243728104 | col #2EFF00->#0E5F00 | LE0.75 LI0 Br1 | life 1-2 | size swell 0->2.56@0.10->0 | tr 0.00..0.00 vis 0.00-0.00 ->1.00 | spd 1 drag 1.5 spread -15-15 rotSpd 25-100 | FacingCamera | RATE 50 (continuous)
E Wave           | tex 1084977655 | col #37FF00 | LE1 LI0 Br1 | life 1 | size grow 0->10 | tr 0.00..0.00 vis 0.00-0.50 ->1.00 | spd 0 rotSpd -100-100 | FacingCamera | locked | RATE 3 (continuous) | z -0.001
E Rays           | tex 1084975295 (A  Rays) | col #1C550B | LE1 LI0 Br1 | life 1 | size const 10 | tr 1.00..0.70 vis 0.50-0.50 ->1.00 | spd 0 rotSpd 60 | FacingCamera | locked | RATE 4 (continuous) | z -0.001
E Glow           | tex 867619398 (M  Glow) | col #00FF1D | LE1 LI0 Br1 | life 2 | size const 10 | tr 1.00..0.50 vis 0.50-0.50 ->1.00 | spd 0 | FacingCamera | locked | RATE 0.8 (continuous) | z 0.002
E Rays_Thick     | tex 1053548563 (A  Star1b) | col #FF00EA->#000CFF | LE1 LI0 Br1 | life 1-2 | size const 10 | tr 0.00..0.00 vis 0.00-0.00 ->1.00 | spd 0 rotSpd -75-75 | FacingCamera | locked | RATE 2.5 (continuous)
E Rays_Thin      | tex 1084961641 | col #1500FF->#FF00DD | LE1 LI0 Br1 | life 1-2 | size const 50 | tr 0.00..0.00 vis 0.00-0.00 ->1.00 | spd 0 rotSpd -75-75 | FacingCamera | locked | RATE 2.5 (continuous)
E Core           | tex 1084962479 (A  Core) | col #0004FF->#FF00F3 | LE1 LI0 Br1 | life 1 | size const 0 | tr 1.00..0.00 vis 0.50-0.50 ->1.00 | spd 0 | FacingCamera | locked | RATE 3 (continuous) | z 0.001
E Other1Shock    | tex 286673503 | col #000000 | LE0 LI0 Br1 | life 1 | size const 5 | tr 1.00..0.00 vis 0.50-0.50 ->1.00 | spd 0 | FacingCamera | RATE 100 (continuous) | z -1
E ParticleEmitte | tex 242911609 | col #365ECE->#00F3FF | LE1 LI0 Br1 | life 0.25-1 | size shrink 10->0 | tr 1.00..0.01 vis 0.50-0.50 ->1.00 | spd 50 | FacingCamera | RATE 250 (continuous) | z -0.1
E ParticleEmitte | tex 243728104 | col #00FFFF->#007474 | LE1 LI0 Br1 | life 1-5 | size shrink 10->0 | tr 1.00..0.01 vis 0.50-0.50 ->1.00 | spd 20 rotSpd 20 | FacingCamera | RATE 10 (continuous) | z -0.5
E ParticleEmitte | tex 2119427041 | col #AAFFFF->#CFFFF3 | LE0.3 LI1 Br1 | life 2-6 | size const 10 | tr 1.00..0.01 vis 0.50-0.50 ->1.00 | spd 0.1-0.2 rotSpd -300-300 | FacingCamera | RATE 180 (continuous) | z -1
E ParticleEmitte | tex 714126682 | col #37FF00 | LE0 LI0 Br1 | life 1 | size grow 0->10 | tr 0.00..0.00 vis 0.00-0.00 ->1.00 | spd 1 drag 20 spread 50 rotSpd -500-500 | FacingCamera | locked | RATE 5 (continuous)
E ParticleEmitte | tex 243098098 (M  ParticleEmit) | col #0CFF00 | LE1 LI0 Br1 | life 0.2 | size swell 0->4.94@0.05->4.81 | tr flat 0.00 | spd 0 | FacingCamera | RATE 1e+03 (continuous)
E ParticleEmitte | tex 242996110 | col #095B00 | LE0 LI0 Br1 | life 0.7 | size swell 1->8.62@0.89->0.688 | tr 0.00..0.00 vis 0.00-1.00 ->0.00 | spd 0 rotSpd 300 | FacingCamera | RATE 50 (continuous)
E BlueFire       | tex 348467696 (A  BlueFire) | col #FFFFFF | LE1 LI0 Br1 | life 1 | size shrink 2.08->0 | tr 0.87..0.47 vis 0.50-0.50 ->1.00 | spd 5 | FacingCamera | RATE 200 (continuous)
E ParticleEmitte | tex 2273224484 | col #FF0004 | LE0 LI0 Br1 | life 0.5-2 | size const 0 | tr 1.00..0.00 vis 0.28-0.80 ->1.00 | spd 100 rotSpd -50-50 | FacingCamera | RATE 5e+03 (continuous) | z -2
E Sparkles       | tex 1053546634 (A  Sparkles) | col #FFF9A2 | LE1 LI0 Br1 | life 0.3-0.7 | size const 3 | tr 0.00..0.00 vis 0.00-0.50 ->1.00 | spd 100 drag 5 spread 90 acc 0-10-0 | FacingCamera
E Flare          | tex 1085001473 (A  Glow) | col #FEFFAA | LE1 LI0 Br1 | life 2 | size const 50 | tr 1.00..0.85 vis 0.50-0.50 ->1.00 | spd 0 rotSpd -10-10 | FacingCamera | locked
E ParticleEmitte | tex 2273224484 | col #D901FF | LE1 LI0 Br1 | life 5 | size swell 1.02->5.03@0.24->0 | tr 1.00..0.00 vis 0.10-0.80 ->1.00 | spd 30 drag 1 spread -360-360 rotSpd -50-50 | FacingCamera | RATE 50 (continuous) | z -2
E ParticleEmitte | tex 2273224484 | col #FFA2FE | LE1 LI0 Br1 | life 5 | size swell 1.02->4.61@0.28->2.46 | tr 1.00..0.00 vis 0.10-0.80 ->1.00 | spd 30 drag 1 spread -360-360 rotSpd -50-50 | FacingCamera | RATE 50 (continuous) | z -2
E ParticleEmitte | tex 346519018 | col #006EFF->#FF20ED->#006EFF | LE0.65 LI0 Br1 | life 0.5-0.65 | size shrink 4.97->0 | tr 0.10..0.10 vis 0.00-0.00 ->1.00 | spd 20 rotSpd -90-90 | FacingCamera | RATE 255 (continuous)
E Core           | tex 1084962479 (A  Core) | col #E200FF->#00C2FF | LE1 LI0 Br1 | life 1 | size shrink 10->0 | tr 1.00..0.00 vis 0.46-0.99 ->1.00 | spd 0 | FacingCamera | locked | RATE 2 (continuous)
E Sparkles       | tex 1053546634 (A  Sparkles) | col #E200FF->#00C2FF | LE1 LI0 Br1 | life 0.3-0.7 | size swell 0->6.35@0.80->0 | tr 0.50..0.50 vis 0.00-0.63 ->1.00 | spd 100 spread -360-360 rotSpd -300-300 | FacingCamera | RATE 100 (continuous)
E ParticleEmitte | tex 548866353 | col #FFFFFF | LE0 LI1 Br1 | life 0.5 | size shrink 1->0.688 | tr 1.00..0.00 vis 0.50-0.50 ->1.00 | spd 0 | FacingCamera
E ParticleEmitte | tex 516107903 | col #A50000 | LE0 LI0 Br1 | life 0.3 | size const 50 | tr 1.00..0.00 vis 0.50-0.50 ->1.00 | spd 0 | FacingCamera | RATE 10 (continuous)
E ParticleEmitte | tex 1486899653 | col #4C0000 | LE0 LI0 Br1 | life 0.5 | size grow 0->10 | tr 0.23..0.00 vis 1.00-1.00 ->0.00 | spd 0 | FacingCamera | z -1
E ParticleEmitte | tex 516107903 | col #A50000 | LE0 LI0 Br1 | life 0.5 | size const 50 | tr 1.00..0.01 vis 0.50-0.50 ->1.00 | spd 0 rotSpd -5-5 | FacingCamera
E Circles        | tex 1084982817 (M  ParticleEmit) | col #FFBF00 | LE1 LI0 Br1 | life 0.5-1 | size swell 2->2@0.00->2 | tr 0.00..0.00 vis 0.00-0.00 ->1.00 | spd 100 spread 180 | FacingCamera | locked | RATE 8 (continuous)
E Bubble         | tex 1053548563 (A  Star1b) | col #FFFFFF->#FFD041->#FFFFFF | LE1 LI0 Br1 | life 1 | size shrink 10->0 | tr 1.00..0.00 vis 0.50-0.50 ->1.00 | spd 0 | FacingCamera | locked | RATE 10 (continuous) | z 3
E Poison         | tex 243664672 (M  Poison) | col #000000 | LE0 LI0 Br1 | life 1 | size shrink 10->0 | tr 1.00..0.72 vis 0.51-0.51 ->1.00 | spd 50 spread -180-180 acc 0-1-0 rotSpd -200-200 | FacingCamera | RATE 150 (continuous) | z 2
E ParticleEmitte | tex 2273224484 | col #00FF51->#003BFF->#FF0004 | LE1 LI0 Br1 | life 0.5-2 | size shrink 4.01->0 | tr 1.00..0.00 vis 0.10-0.80 ->1.00 | spd 1-5 spread -360-360 rotSpd -50-50 | FacingCamera | RATE 50 (continuous)
E ParticleEmitte | tex 2273224484 | col #00FF51->#003BFF->#FF0004 | LE1 LI0 Br1 | life 0.5-2 | size shrink 10->0 | tr 1.00..0.00 vis 0.10-0.80 ->1.00 | spd 50-100 spread -360-360 rotSpd -50-50 | FacingCamera | RATE 100 (continuous)
E Poison         | tex 243664672 (M  Poison) | col #000000 | LE0 LI0 Br1 | life 1 | size shrink 10->0 | tr 1.00..0.72 vis 0.51-0.51 ->1.00 | spd 80 spread -180-180 acc 0-1-0 rotSpd -200-200 | FacingCamera | z 2
E Particles      | tex 3916186365 (D  Particles) | col #DAC7A2 | LE0 LI0 Br1 | life 1-2 | size grow 0->10 | tr 0.00..0.00 vis 0.00-0.00 ->1.00 | spd 0 rotSpd 360 | FacingCamera | z -1
E Particles      | tex 145532427 | col #030303 | LE0 LI0 Br1 | life 5-10 | size swell 0->5.15@0.50->0 | tr 0.00..0.00 vis 0.00-0.00 ->1.00 | spd 0 rotSpd 360 | FacingCamera
E Poison         | tex 243664672 (M  Poison) | col #303030 | LE0 LI0 Br1 | life 1 | size shrink 5.85->0 | tr 0.00..0.00 vis 0.00-0.00 ->1.00 | spd 20 acc 0-1-0 rotSpd -200-200 | FacingCamera | RATE 150 (continuous) | z -1
E PoisonSparkles | tex 118322059 | col #161616 | LE0 LI0 Br1 | life 1 | size swell 0->2.73@0.14->0.05 | tr 0.00..0.00 vis 0.00-0.80 ->1.00 | spd 20-40 acc 0-0.2-0 rotSpd 20-40 | FacingCamera | RATE 50 (continuous)
E Poison         | tex 243664672 (M  Poison) | col #303030 | LE0 LI0 Br1 | life 1 | size shrink 5.85->0 | tr 0.00..0.00 vis 0.00-0.00 ->1.00 | spd 20 acc 0-1-0 rotSpd -200-200 | FacingCamera | RATE 150 (continuous) | z -1
E PoisonSparkles | tex 118322059 | col #161616 | LE0 LI0 Br1 | life 1 | size swell 0->2.73@0.14->0.05 | tr 0.00..0.00 vis 0.00-0.80 ->1.00 | spd 20-40 acc 0-0.2-0 rotSpd 20-40 | FacingCamera | RATE 50 (continuous)
E Poison         | tex 243664672 (M  Poison) | col #303030 | LE0 LI0 Br1 | life 1 | size shrink 2.62->0 | tr 0.00..0.00 vis 0.00-0.00 ->1.00 | spd 10 acc 0-1-0 rotSpd -200-200 | FacingCamera | RATE 150 (continuous) | z -1
E PoisonSparkles | tex 118322059 | col #161616 | LE0 LI0 Br1 | life 1 | size swell 0->1.02@0.12->0.05 | tr 0.00..0.00 vis 0.00-0.80 ->1.00 | spd 10-20 acc 0-0.2-0 rotSpd 20-40 | FacingCamera | RATE 50 (continuous)
B Beam2          | col #000000 | LE0 LI0 Br1 | w 0-0 curve 25-25 seg 35 | tr flat 0.00 | tex Stretch 1 spd 0
B Beam           | col #000000 | LE0 LI0 Br1 | w 0-0 curve -25-25 seg 35 | tr flat 0.00 | tex Stretch 1 spd 0
T Trail          | col #FFFFFF | LE1 LI0 Br1 | life 1 width shrink 1->0 | tr 0.00..0.00 vis 0.00-0.30 ->1.00 | tex Stretch 1 spd None
T Trail          | col #DAC7A2 | LE1 LI1 Br1 | life 8 width shrink 1->0 | tr 1.00..0.01 vis 0.02-0.02 ->1.00 | tex Stretch 1 spd None
T Trail          | tex 1191605952 | col #000000->#346C00 | LE0 LI0 Br1 | life 2 width shrink 1->0 | tr 0.00..0.00 vis 0.00-0.60 ->1.00 | tex Stretch 1 spd None
T Trail          | col #00C2FF->#E200FF | LE1 LI1 Br1 | life 2 width shrink 1->0 | tr 1.00..0.01 vis 0.50-0.50 ->1.00 | tex Stretch 1 spd None
T Trail          | tex 1191605952 | col #FF9D00->#D99800->#C37800 | LE0 LI1 Br1 | life 4 width shrink 1->0 | tr 0.00..0.00 vis 0.00-0.00 ->1.00 | tex Stretch 1 spd None
T Trail          | tex 1191605952 | col #FF9D00->#D99800->#C37800 | LE0 LI1 Br1 | life 4 width shrink 1->0 | tr 0.00..0.00 vis 0.00-0.00 ->1.00 | tex Stretch 1 spd None
T Trail          | tex 1191605952 | col #FF9D00->#D99800->#C37800 | LE0 LI1 Br1 | life 4 width shrink 1->0 | tr 0.00..0.00 vis 0.00-0.00 ->1.00 | tex Stretch 1 spd None
T Trail          | tex 1191605952 | col #FF9D00->#D99800->#C37800 | LE0 LI1 Br1 | life 4 width shrink 1->0 | tr 0.00..0.00 vis 0.00-0.00 ->1.00 | tex Stretch 1 spd None
T Trail          | col #A6FF00->#1D6CFF->#FF08EB | LE1 LI1 Br1 | life 8 width shrink 1->0 | tr 0.00..0.00 vis 0.00-0.50 ->1.00 | tex Stretch 1 spd None
T Trail          | col #DAC7A2 | LE1 LI1 Br1 | life 8 width shrink 1->0 | tr 1.00..0.01 vis 0.02-0.02 ->1.00 | tex Stretch 1 spd None
T Trail          | col #000000 | LE0.6 LI0 Br1 | life 2 width shrink 1->0 | tr 0.00..0.00 vis 0.00-0.60 ->1.00 | tex Stretch 1 spd None
T Trail          | col #000000 | LE0.6 LI0 Br1 | life 2 width shrink 1->0 | tr 0.00..0.00 vis 0.00-0.60 ->1.00 | tex Stretch 1 spd None
T Trail          | col #000000 | LE0.6 LI0 Br1 | life 2 width shrink 1->0 | tr 0.00..0.00 vis 0.00-0.60 ->1.00 | tex Stretch 1 spd None
P {"k": "Part", "name": "DeathTrailTexture", "size": [0.05, 0.05, 0.05], "mat": "Granite", "transp": 0.0}
P {"k": "Part", "name": "DMSphere2", "size": [0.05, 0.05, 0.05], "mat": "Neon", "transp": 0.0}
P {"k": "Part", "name": "DMSphere", "size": [4.0, 4.0, 4.0], "mat": "Neon", "transp": 0.0}
P {"k": "Part", "name": "HydraSlash", "size": [0.05, 0.05, 0.05], "mat": "Neon", "transp": 0.0}
P {"k": "Part", "name": "PurityBlock", "size": [0.05, 0.05, 0.05], "mat": "Neon", "transp": 0.3}
P {"k": "Part", "name": "DeathExplosionSphere", "size": [0.05, 0.05, 0.05], "mat": "Neon", "transp": 0.0}
P {"k": "Part", "name": "ClonedBall", "size": [2.8, 2.8, 2.8], "mat": "Neon", "transp": 0.0}
P {"k": "Part", "name": "TeleExplosion", "size": [8.0, 8.0, 8.0], "mat": "Neon", "transp": 0.0}
P {"k": "Part", "name": "Explosion", "size": [8.0, 8.0, 8.0], "mat": "Neon", "transp": 0.0}
P {"k": "Part", "name": "PhantasmBullet", "size": [3.0, 3.0, 3.0], "mat": "Neon", "transp": 0.0}
P {"k": "Part", "name": "Part", "size": [37.02399, 37.02399, 37.02399], "mat": "Neon", "transp": 0.7}
P {"k": "Part", "name": "Part", "size": [42.71999, 42.71999, 42.71999], "mat": "ForceField", "transp": 0.0}
P {"k": "Part", "name": "PrimaryPart", "size": [28.48, 28.48, 28.48], "mat": "Neon", "transp": 0.0}
P {"k": "Part", "name": "EffectPart2", "size": [0.05, 0.05, 0.05], "mat": "Neon", "transp": 0.0}
P {"k": "Part", "name": "ExplosionSphere2", "size": [0.05, 0.05, 0.05], "mat": "Neon", "transp": 0.3}
P {"k": "Part", "name": "ExplosionSphere", "size": [0.05, 0.05, 0.05], "mat": "Neon", "transp": 0.0}
P {"k": "MeshPart", "name": "Ring", "size": [35.0, 0.05, 35.0], "mat": "Neon", "transp": 1.0, "mesh": 471124075}
P {"k": "MeshPart", "name": "Shockwave", "size": [0.75, 0.1305, 0.75], "mat": "Neon", "transp": 0.15, "mesh": 643098245}
P {"k": "Part", "name": "Part", "size": [0.05, 0.05, 0.05], "mat": "Neon", "transp": 0.0}
P {"k": "Part", "name": "Primary", "size": [0.05, 0.05, 0.05], "mat": "Neon", "transp": 0.0}
S Script Script len500 flags=anim,delay,tween
S Script Script len65 flags=delay
S Script Script len97 flags=
S Script Script len791 flags=anim,debris,delay,tween
S Script Special len3143 flags=anim,debris,delay,tween
S Script Damage len376 flags=delay
S Script Script len1547 flags=anim,debris,delay,tween
S Script Script len116 flags=
S Script Script len116 flags=
S ModuleScript DeathBoltEffects len2145 flags=anim,colorcorr,debris,delay,tween
S ModuleScript SpheresModule len3703 flags=debris,delay,remote
S ModuleScript RingsModule len2353 flags=debris,delay,remote
S Script Script len1918 flags=anim,debris,delay,tween
S Script Script len2506 flags=anim,debris,delay,tween
S Script Script len3288 flags=anim,delay,tween
S Script Script len1461 flags=anim,delay,tween
S Script Script len2876 flags=anim,bezier,delay,tween
S Script Script len593 flags=delay
S Script Script len79 flags=delay
S Script Script len794 flags=
S Script Script len115 flags=
S Script Script len655 flags=anim,delay,tween
S Script Script len2003 flags=anim,delay,tween
S Script Script len867 flags=
S Script Script len1978 flags=anim,debris,delay,tween
S Script Orbit len442 flags=delay,tween
S Script Orbit len442 flags=delay,tween
S Script Orbit len437 flags=delay,tween
S Script Orbit len443 flags=delay,tween
S Script Script len116 flags=
S Script Fader len128 flags=delay
S Script Script len242 flags=delay
S Script Script len37 flags=debris
S Script Script len37 flags=debris
S Script Script len37 flags=debris
```
