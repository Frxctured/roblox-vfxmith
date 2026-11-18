---
title: AI review panels disagree with humans
tags: [vfx, review, panel, rating, vision, finding]
type: finding
updated: 2026-11-18
source: blind tests T3, T5, lab rounds 1-2, Storm Katana (2026-11-14 to 11-17)
---
# AI review panels disagree with humans

> TL;DR
> - AI panels reversed people's ranking of two ice slams (T5) and scored a portal 6 that people rated 8-9.
> - In-run panels score about 1 point below outside panels; a builder rates its own work about 1 point high.
> - Following panel advice literally removed things people liked (frost, resting shards, break flashes).
> - AI marked down bold saturated colour that people preferred.
> - So v1 uses AI only for objective faults; quality judgement comes from humans or a judge proven to agree with them.

## Evidence
- T5: panel ranked beta3 above beta2; people preferred beta2.
- Lab round 2: portal 6-6.5 from the panel vs 8-9 from people; aura 6-6.5 vs 8.
- 0.1.6 regressions came from fixing "frost plate", "shards freezing" and "crown goes white" literally.
- The owner: "Computer vision doesn't seem to compare to human vision."

## What v1 does instead
- A fault checker reports only measurable problems (invisible, clipping, wrong size against the brief, over budget,
  payoff not the biggest beat).
- Any model used for quality must first pass the vision bake-off against the owner's labels.
