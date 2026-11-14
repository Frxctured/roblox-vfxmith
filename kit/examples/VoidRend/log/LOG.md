# VoidRend review log

Reference: the reference video "Styl_VoidRend_v2" (third-party, not included) (cycle 4, t0 = 17.70 s). Captures: void stage, seed 7, times
0.03 0.1 0.2 0.4 0.6 0.85 1.0 1.06 1.15 1.3 1.6 2.2. `compare_vN.png` = REF row over OURS row.

| Version | What changed | Shape | Timing | Colour | Notes |
|---|---|---|---|---|---|
| v1 | first spec, placeholder shapes, no meshes | - | - | - | capture bug: stale frames, blue "void" |
| v2 | meshes + VFX Studio picks; markers + Neon black stage | - | - | - | first valid capture |
| v3b | thick horns closer, brighter pillar, smaller splash, camera dist 15.5 | 4 | 5 | 4.5 | round 1 (3 blind reviewers) |
| v4 | round 1 merged: ground footprint 0.6x, asymmetric thinner horns gone by 0.73 s, darker Neon colours, lasers visible (beam Segments 10), dome breaks up by 1.3 s, quiet linger, grade tint #E2D2FF | 4.5 | 5 | 4.5 | round 2; linger over-corrected to empty; horns mirrored (world +X = screen left) |
| v5 | round 2 merged: linger restored (smoke mound, orbs, navy disc, double ring), slim horns small-left / big-right, dome pops in one frame, low wide spike burst, disc grows 6.5 -> 11, Neon colours pulled down, pillar gone by 0.83 s | 6 | 6 | 5.5 | round 3 (stills; horns mirror-fixed) |
| v6 | round 3 merged: smaller later pool, horns closer, bigger dome at the pop, wide early spike burst, travelling cool ring, dim linger, flank puffs, lasers/curls/sparkles low | - | - | - | linger vanished (screen colours typed as Color) |
| v7 | horns back to the medium mesh, paler; pool restored; pillar less taper; smoke/orb colours authored = target / (texture x opacity) | - | - | - | linger now too strong, orbs hard-edged |
| v8 | Haze texture for orbs, smaller violet smoke, ground swirl authored brighter, desaturated horns | 6.5 | 6 (rhythm 7) | 6 | round 4; coverage within ~15% of the reference at every sample |
| v9 | FINAL of this run. Round 4 merged: milky half-dome growing over 3 frames, smaller later spike fringe that hangs, slim horns standing on the ring (right one starts small at 0.15 s), tall arches, grade Contrast 0.25 (darks were clipping to pure blue), visible flank puffs, thin tilted lasers, lilac smoke curls | - | - | - | not re-reviewed; linger ~2x the reference's coverage at 2.2 s (bigger smoke pile + 120 twinkles) |

## Where it stopped and why
Average score per round: 4.5 -> 4.7 -> 5.8 -> 6.2. The last round gained +0.4, so per the stop rule this run ends at v9.
Remaining differences (from round 4 + the v9 metrics): the linger is heavier and bluer than the reference; Neon body
colours still swing between pastel and hot (authored #8A5AA4 sits between the two); the reference's pillar has more
lightning/curl detail.

Recordings (real time, 60 fps, cut at the effect start): `VoidRend_v8_vs_reference.mp4`, `VoidRend_v9_final_vs_reference.mp4`
(+ `_halfspeed` copies, reference on top), raw viewport takes `VoidRend_v8_raw.mp4`, `VoidRend_v9_final_raw.mp4`.

## Process lessons from this run
- Fix framing and capture bugs (stale frames, Segments-1 beams, grey video black, mirrored screen sides) before trusting
  any review: rounds 1-2 were partly spent on them.
- Reviewers' screen colours are not authoring colours (texture x Color x opacity; Neon hotter and more saturated).
- Words make layers oscillate (linger: too loud -> empty -> too loud); steer those by the coverage curve.
- Fresh blind reviewers each round kept finding new, concrete, mostly-correct fixes; merging 2+-reviewer items first
  avoided most regressions.

## Round 1 merge (v3b -> v4)
Flagged by 2-3 reviewers (applied first): linger too loud (smoke/orbs), disc + crater hold too long, horns too hot
and still there in the implode, lasers missing (bug: beam Segments 1 hides a fade-in/out sequence), burst too big and
never breaks up. Single flags applied: framing (origin lower), strike shorter and lower, pillar tapered, pillar core
violet not white, grade tint warmer, twinkles tiny and many, arches short and late, splash/spikes later.
