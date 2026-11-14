# Design brief: ask, then plan (any effect type)

Before references and recipes, settle WHAT the effect should be: how long it lasts, when its best moment hits, how
big it is and what style it matches. In the second blind test (2026-11-14) the agent skipped this and copied size and
timing from a recipe; the payoff came out small and early, and it lost 5.5 to 7.5. Recipes decide HOW a part is
built. The brief decides how big, when, how long and in what style.

## 1. A short questionnaire (skip what the prompt already answers)
Read the request first. Ask ONLY the questions it leaves open; a very descriptive prompt ("a 4-second purple void rift
that opens slowly and implodes at the end, toon style, for a boss ultimate") needs none. If the user is away or the
session cannot ask, do not wait: pick the defaults below and write them in the brief as "Assumed".

In Claude Code, ask with the AskUserQuestion tool (up to 4 questions per call, 2-4 options each; the user can always
type their own answer). Ask the core round first; ask the second round only if something important is still unknown.
Other agents: ask the same questions in one plain message and offer "reply 'go' to use the defaults".

**Core round (the 4 that change the build most):**
| # | Question | Options |
|---|---|---|
| 1 | What is the effect for? | a basic attack or hit (small, fast) / a big ability or ultimate (a signature moment) / ambient or environment (a loop) / UI, pickup or reward feedback |
| 2 | How long should it last? | snappy, under 0.6 s / short, 0.6-1.5 s / medium, 1.5-3 s / long or cinematic, 3-6 s (or: it loops) |
| 3 | When should the most exciting moment hit? | instantly, frame 1 (an impact) / after a short wind-up, ~0.2-0.5 s / after a long build, 1 s or more / near the end (a finale) / it is a loop with pulses |
| 4 | What style should it match? | anime or toon (flat shapes, outlines, cel steps) / soft glowing and magical / grounded (smoke, fire, debris) / match my game (describe it or share a screenshot) |

**Second round (only what is still open and matters):**
| # | Question | Options |
|---|---|---|
| 5 | Main colours or element? | fire (orange-red) / ice or water (cyan-white) / holy or light (gold-white) / void or dark (purple-black) |
| 6 | How big on screen? | hand-sized / around one character / an area, 2-5 characters wide / huge, fills the screen |
| 7 | Where does it play? | a bright daytime map / dark, night or indoors / both / not sure |
| 8 | How does it move? | stays where it is cast / follows the character / travels from A to B (projectile, beam, dash) / covers an area |
| 9 | Does anything get pulled in or thrown out? | pulled in (debris, particles, light) / thrown out (debris, sparks, shards) / leaves marks behind (scorch, cracks) / nothing |

**For sustained effects (portal, rift, vortex, black hole, aura, field, charge) always ask 8 and 9, and whether it
stands on the ground or hangs in the air**, even when you think the word answers them. In blind test 3 (a void rift)
both plugin runs assumed "stays where it is cast" from the word "rift", never asked, and never heard that it pulls
debris in; both also guessed "on the ground" for a rift that hangs at head height. All three reviewers marked one of
them down for the missing pull.
Also ask for a reference (video, image, a game moment) if the user mentions one; it overrides the defaults.

## 2. Defaults from the request's wording (when nobody answers)
| The request says | Purpose / scale | Length | Peak | Size at gameplay distance |
|---|---|---|---|---|
| hit, punch, slash, swing, basic attack | basic attack | 0.3-0.8 s | frame 1-3 after contact | about one character |
| projectile, fireball, bolt, shot | attack with travel | launch 0.1-0.2 s, travel, impact 0.3-0.6 s | the impact | impact 1-2 characters |
| cool, epic, ultimate, big, boss, finisher | signature move | 2.5-5 s | after a clear build (0.5-1.5 s), with one bigger finale | the payoff fills ~1/3 of the screen |
| aura, buff, power-up, idle, charging | sustained | loop 1-3 s cycle (plus an optional burst on start) | pulses every cycle, no single peak | around the character, silhouette stays readable |
| portal, rift, vortex, field, zone | sustained with phases | open 0.3-1 s, hold (loop), close 0.3-1 s | the open or the collapse (say which) | an area |
| pickup, reward, level up, UI | feedback | 0.5-1.2 s | early (0.05-0.2 s), then a sparkle linger | small to one character |
| ambient, environment, torch, waterfall | ambient loop | seamless loop | none, steady with variation | as the scene needs |
No style given: say which one you chose and keep to it (patterns.md 15.7). No lighting given: tune for daylight and
check on the dark stage too.

## 3. The brief (write `<effect>/brief.md` before building)
- **Request** in the user's words, the answers, and every "Assumed" default.
- **Purpose and scale**, total length, peak time and what the peak is.
- **Beats**, one row each: name | from-to in seconds | the ONE hero shape | size in studs and as a share of the screen
  at gameplay distance | colour/value. Typical structures:
  - one-shot (hit, explosion, slash): anticipation -> peak -> release -> linger;
  - travel (projectile, beam, dash): launch -> travel -> impact -> linger;
  - sustained (aura, portal, field): start burst -> loop (1-3 s cycle with pulses) -> end;
  - build-up (charge, ultimate): long build with rising intensity -> quiet beat -> payoff -> aftermath.
- **Rules to check later:** the payoff is the biggest and brightest beat; anticipation is long enough to read (at least
  ~0.2 s, more for big moves); every repeated beat escalates and differs; the linger matches the scale (big moves
  leave smoke, marks or embers for 1-3 s); one hero shape per beat.
- **Motion:** where it sits (on the ground, in the air, on the character), whether it moves, and what it pulls in,
  throws out or leaves behind.
- **Style** (one), **palette** (three tones: core, body, ink), **lighting** (day, dark or both), **budget** (~150
  particles at the peak by default; mobile = `VFXTimeline.Quality` 0.6).
- **Capture camera** at gameplay distance: ~20-30 studs for a character-sized effect, ~40-60 for an area or a
  signature move.

## 4. Fit the recipes to the brief
Start from the category recipe(s) as usual (vfx-make step 2), then:
- **scale** them (`scale` in the spec or the opts) so each beat matches the size in the brief; recipes are sized for
  an average library effect, not for your request;
- **retime** them: shift `t`, stretch `life`, Lifetime and emit times so each beat lands where the brief puts it;
- **cut or add layers** so each beat has its one hero shape;
- give the brief to the reviewers (vfx-review): they judge against what the user asked for.
