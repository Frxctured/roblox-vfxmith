---
title: Magic-school palettes and team colour
tags: [vfx, color, palettes, technique]
type: technique
updated: 2026-11-18
source: Riot Games, League of Legends VFX Style Guide 2017 (local copy _vfx_os_library/tutorials/articles/lol_vfx_styleguide.txt + lol_pages/p-NN.png; original URL not recorded, UNVERIFIED), slides 22-26; https://www.mad-vfx.com/blogs/principles-of-visual-effects; https://80.lv/articles/from-realism-to-stylization-game-vfx-production
---
# Magic-school palettes and team colour

> TL;DR
> - Each school has a stable palette: poison green+dark green+toxic yellow, void deep purple+magenta, heal fresh green+yellow, frost cyan/light blue, gunpowder yellow-orange+brown-red, arcane cyan/blue+violet, nature green+yellow, celestial yellow+orange+pink, hextech cyan+blue+violet, water mid blues, wind pale grey-teal.
> - Pie charts show a dominant colour (roughly half or more of the area), one or two supports and a small bright accent plus a dark; read by eye, UNVERIFIED as exact shares.
> - Ally indicators go cyan to blue-violet; enemy indicators go pink-red to orange, so colour tells friend from foe.
> - Color is information first: red enemy, blue ally, red fire, blue ice (mad-vfx); a stylised colour set can still be tuned to a theme (80.lv).
> - Roblox translation (ours): ship a palette table per school and pick from it before choosing individual Color3 values.

## Palettes (slides 22-25, read from the images)
| School | Dominant | Support | Accent |
|---|---|---|---|
| Poison | bright green | dark green | toxic yellow, small purple |
| Void | deep purple | dark maroon, blue-violet | magenta, small red |
| Heal | fresh light green | yellow | pale yellow |
| Frost | light cyan | royal blue | deep blue, near-white |
| Gunpowder | gold-yellow | red-orange, brown | pale yellow |
| Arcane | mid blue | cyan | violet, light cyan |
| Nature | light lime green | yellow, amber | dark green, cream |
| Celestial | yellow | orange | pink, magenta |
| Shadow Isle | mint/aqua | teal | green, navy |
| Hextech | cyan | royal blue | violet, lavender |
| Wind | grey-teal | teal | white, dark brown |
| Water | steel blue | navy | light blue |

Proportions come from pie slices read by eye (UNVERIFIED); every palette is one dominant hue, one or two neighbours, a small accent and a dark. None is a rainbow.

## Team colour (slide 26)
Ally: gradient cyan to blue to violet. Enemy: pink-red to orange-red. The same circle indicator is drawn in both so only colour changes.

## Use
Pick the palette first, then assign: dominant to the primary element, supports to secondary layers, accent to the 1-3 hot points, the dark to the ink layer ([[Value range and dark backing]]).

## Roblox translation (ours)
A `Palettes` table of Color3 triples per school feeding ColorSequences; layer roles pick from it. Danger telegraphs use the enemy red-orange, friendly buffs use cyan/green. Fits typical game themes (fire, ice, void) without inventing new hues.
