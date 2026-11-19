# Texture shortlist (optional)

A few textures that work, by role, if you want a starting point. Nothing here is required: Studio's built-ins,
textures you draw with `kit/maketex.py`, plain parts and Neon/ForceField materials are all just as valid.

## Studio built-ins (load everywhere, no upload)
`rbxasset://textures/particles/<file>`

| file | looks like |
|---|---|
| `smoke_main.dds` | soft grey smoke puff |
| `fire_main.dds` | soft flame blob |
| `sparkles_main.dds` | small sparkle |
| `fire_sparks_main.dds` | tiny ember sparks |
| `explosion01_core_main.dds` | bright lumpy fireball core |
| `explosion01_implosion_main.dds` | soft round glow (a good default glow) |
| `explosion01_shockwave_main.dds` | soft ring |
| `explosion01_smoke_main.dds` | darker billowy smoke |
| `forcefield_vortex_main.dds` | swirl |
| `SquareParticle.png` | plain square |
| `rbxasset://textures/face.png` | the classic smiley face (decal) |

Note: `forcefield_glow_main.dds` has rendered blank on particles and beams. The ring and glow images have wide empty
margins, so they look smaller than their Size.

## Library textures (Roblox image ids, from open-source pro effects)
`rbxassetid://<id>`. All loaded in a load test from another account. Grid = flipbook layout
(`FlipbookLayout = Grid4x4` / `Grid8x8`, `FlipbookMode = OneShot` or `Loop`); a flipbook needs particles that age.
A = made for additive (LightEmission 1), D = made for normal blending (covers), M = both.

| role | id | grid | light | looks like |
|---|---|---|---|---|
| soft glow | `867619398` | - | M | big soft blob |
| flash behind a hit | `16879789169` | - | A | small soft dot, used very big |
| spark dot | `16878181512` | - | D | tight bright spec |
| lens star | `14590086212` | - | A | thin sharp cross star |
| spark streak | `8030734851` | - | A | one soft streak (VelocityParallel + Squash) |
| clean thin ring | `18682826321` | - | M | thin ring |
| ring burst | `126034245450101` | 4x4 | M | ring thinning to a hairline |
| shock disc | `9659008631` | - | A | bright disc flash |
| radial spike burst | `17296456452` | - | A | crisp starburst |
| soft smoke | `11871320339` | 4x4 | D | wispy puff curling away |
| dense billow | `15415212938` | 4x4 | D | realistic cumulus |
| rising smoke | `11866744589` | 4x4 | D | smoke rising from the ground |
| dust cloud | `7216851093` | - | D | grainy lingering dust |
| toon smoke | `16867483883` | 4x4 | D | solid white cartoon cloud breaking up |
| toon fire | `11846119288` | 4x4 | D | soft-edged cartoon flame |
| flame tongue | `11844017484` | 4x4 | M | single S-shaped flame |
| realistic fire | `11458438415` | 8x8 | A | energy fire |
| lightning | `13780092154` | 4x4 | M | thick electric curls |
| crescent slash | `13780268621` | 4x4 | M | crescent swipe |
| wind swirl | `109440284900004` | 4x4 | M | swirl |
| ground crack | `13782885260` | 4x4 | D | dark cracks round a white centre |
| rocks | `15441282898` | 2x2 | D | four rock sprites |
| liquid splat | `14431663347` | 4x4 | D | splash |
| beam flow | `16892453445` | - | M | smeared flowing noise (beams) |
| beam smoke strands | `12823611043` | - | A | thin smoke strands (beams) |

Things that often help: `Color` multiplies the image, so white art tints cleanly; art on a black card only works
additive. More ids by role: `python3 -I kit/scripts/compose.py --swap <id>`.
