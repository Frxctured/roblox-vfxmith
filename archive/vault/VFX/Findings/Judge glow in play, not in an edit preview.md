---
title: Judge glow in play, not in an edit preview
tags: [vfx, glow, bloom, lightemission, capture, finding]
type: finding
updated: 2026-11-18
source: anderdingus vault by Discord @1635 (free to use, confirmed by its owner 2026-11-18; local copy ~/Documents/Vaults/anderdingus), 'Rising Fire Wall' toned-down pass
---
# Judge glow in play, not in an edit preview

> TL;DR
> - In-game Bloom roughly doubles additive glow, so an effect tuned in an edit-mode preview is too strong in play.
> - Their fire wall read well in play at LightEmission 0.6 and Brightness about 1, much lower than the edit preview suggested.
> - Freshly uploaded textures render white or grey for a few seconds in Studio: wait before judging a capture.
> - For vfxmith: captures used for judging must include the place's real Bloom (or a play-mode capture).

## Note
This fits [[Value, contrast and glow]] and complicates [[Our effects look matte - Brightness and LightEmission vs pros]]:
pro Brightness values depend on the scene's Bloom settings, so compare values only under the same lighting.
