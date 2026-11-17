---
name: vfx-direct
description: Build a Roblox VFX effect with the directed loop (the default in this beta) - a short brief, then a builder agent that builds with tested VFXKit blocks and checks itself from five cameras, and a separate director agent that watches each version and writes one ranked fix list, for at most three director rounds, then the user's feedback. Use for "make a VFX", "make a slash / punch / impact / strike / ability effect", "improve this effect", any new or reworked effect; use vfx-make (classic) for a recreation of a reference video or when the user asks for the classic loop.
---

# Make a Roblox effect: the directed loop

`ROOT` = the plugin root: `<base directory>/../..` (also `${CLAUDE_PLUGIN_ROOT}`). All paths are relative to ROOT;
resolve it to an absolute path first and quote it (it may contain spaces). Python 3 + Pillow run the scripts; Studio
is driven through the Studio MCP server (`execute_luau`, `screen_capture`), Edit mode only.

**Why this loop.** A builder alone repeats the same first-version mistakes and cannot see them: it built the thing,
so it reads its own frames kindly. In the test this loop comes from, a builder with the kit, the pro guide, the
checklist and a self-check, plus a director who only watches and writes one ranked list, went from 6.0 to 6.8 in one
round on a fire punch, and a sword combo directed the same way was rated 8/10 by its owner. You are the **lead**:
you write the brief, pass messages between the two agents, and talk to the user. You do not build and you do not
judge; keep your own context small (paths and scores, not images).

| Role | Agent | Does |
|---|---|---|
| Lead | you | brief, hand-offs, round count, shows the user the result, runs `vfx-feedback` |
| Builder | `vfxmith:vfx-builder` (Opus) | reads the kit guide, pro guide, checklist, self-check and taste; builds with VFXKit blocks; writes a reason on every layer (`fx:Layers()` into LOG.md); runs the self-check before EVERY report |
| Director | `vfxmith:vfx-director` (Opus), fresh each round | watches the version from 5 views and in motion, reads the layer table (values + reasons), judges against the brief, references and checklist, writes ONE ranked list of at most 8 fixes |

If the plugin's agents are not available (plain folder use), spawn general-purpose agents on an Opus-class model told
to read and follow `ROOT/agents/vfx-builder.md` / `ROOT/agents/vfx-director.md`.

## 0. Before anything: Studio
Search once for the Studio MCP tools (ToolSearch "Roblox Studio") and note the Studio id of the place to work in. If
they are missing, say so now: this loop is about looking, and without Studio nothing can be looked at. Offer ONE
careful unseen draft through `vfx-make` instead, marked untested. Ask (or decide, if the user is away) where the test
stage may stand: an empty place is best; in the user's own place pick a spot well away from their build. Everything the
loop creates is named `LAB_...`.

## 1. Brief (with the user, short)
Follow `knowledge/design-brief.md`: ask only what the request leaves open, in one message (none if it is
descriptive; defaults from the wording if the user is away). Write `<effect>/brief.md`: purpose and scale, total
length, the beats with their hero shape and size in studs and in character heights (H = 5 studs), the peak moment,
motion, style, palette, lighting, anything the user said they like (the director may never remove or shorten those),
and the caster (a character move, a weapon, an object, a spot on the ground). Everything after this serves the brief.
`<effect>` is a new folder in the user's project (`vfx/<slug>/`) unless they name one.

**Run every agent in the FOREGROUND and wait for its reply** (never `run_in_background`, never end your turn while
an agent is still building or directing): the whole loop runs to the end in one go. A turn that ends while the
builder works leaves the user with nothing, and headless hosts stop background agents.

## 2. Builder round 1 (and, in the same message, references for the director)
Spawn both in ONE message (both in the foreground):
- **Builder:** `vfxmith:vfx-builder` with `ROOT=<root>`, the effect folder, the Studio id, where the stage may stand,
  `mode directed`, `round 1`. It builds v1, runs the whole self-check and writes `<effect>/builder_reply1.md`.
- **References:** `vfxmith:vfx-librarian` (fast model) with `ROOT=<root>`, the request, the brief's beats and the
  effect folder. Save its reply as `<effect>/refs.md`. It is for the director (what good looks like for this type:
  gallery sheets of real effects) and for the builder from round 2 on. Skip it only if the user is in a hurry.
Use a FRESH builder each round: it continues from `effect.luau`, `LOG.md` (the builder keeps it up to date: what
worked, what failed, values) and the director's message. Continuing one builder makes every round dearer as its
context grows (in the test: $7, $15, $23 for rounds 1-3); a fresh one reads the log instead.

## 3. Director round N (N = 1, 2, 3 at most)
Spawn a FRESH `vfxmith:vfx-director` with `ROOT=<root>`, the effect folder, the Studio id, `round N of 3`, and the path
of the builder's reply. It looks at the builder's sheets, takes its own stills of what it doubts, and writes
`<effect>/dir_msgN.md`: an honest score, what works (keep), at most 8 ranked fixes. It replies with the score and
the path. Do not soften, reorder or add to its list. The one thing you check before passing it on is the hard rule:
if a fix asks to turn, move, lengthen or brighten something toward a camera or "the side the player sees", strike that
fix and say so in the hand-off (in the test a director asked for longer flames on the camera's side; nobody caught it).

Tell the user one line per round: version, score, the top fix, the sheet path. Do not wait for an answer unless they
give one; anything they say outranks the director and goes into the next hand-off in their words.

**Stop early** when the director writes `SHIP` (score 8.5 or more and no hard-rule failure), or when a round gained
less than 0.3 with nothing but polish left on the list.

## 4. Builder round N+1
Spawn a fresh builder (foreground, `mode directed`, `round N+1`): "Director round N: read
`<effect>/dir_msgN.md` and apply it in rank order; keep everything under 'Keep'; run the self-check; write
`builder_reply<N+1>.md`." Then back to step 3. After the third director round the builder makes the final version and
there is no further director round.

## 5. Final capture and the person's opinion
The last builder reply names the final 5-view sheet and the dense strips. Show the user the sheet (and a live
recording if one was made; never block on it: `knowledge/selfcheck.md` section 3), where the effect stands in Studio
and how to play it (`_G.kitfx:Play()`), then run `vfx-feedback`: people judge better than any AI director, their
answers are saved and teach the plugin. What they ask for is one more builder round (no director), then a final sheet.
User away: finish with the last version and say which checklist lines are still open.

## 6. Finish
- The result is `<effect>/effect.luau`: one file that needs `kit/studio/VFXKit.luau` loaded first
  (`kit/scripts/kit_push.py` for both). It plays on the kit's review stage in Edit mode. It is NOT game code: to ship
  it, the layers (textures, sizes, lives, brightness, timing from the file) are rebuilt for the game's own effect
  runtime, or as a `kit/runtime/VFXTimeline.luau` spec (`knowledge/spec-format.md`); offer that as a follow-up.
- Clean up when the user is done looking: `_G.kitfx:Destroy()` and `_G.VFXKit.RestoreLighting()`.
- Texture ids come from the open-source library and the free VFX Studio catalogue: fine while building; shipping them
  in a published game is the user's call (`THIRD_PARTY.md`).
- Say what a run cost if you can see it (one builder round was about 25 minutes in the test).

## Rules for the lead
- **Caster space is a hard rule for everyone** (`knowledge/checklist.md` line 1): the effect is built in the caster's
  look / right / up vectors and must read from every angle. Cameras are for looking only.
- `knowledge/taste.md` and the user's own words outrank the director; the director outranks the builder's liking.
- Never remove, shorten or fade early something the brief or the user asked for because an agent disliked how it
  looks: change how it looks.
- Lessons stay general: when a run teaches something, add it to `knowledge/gotchas.md` / `patterns.md` phrased for
  every effect type, never tuned to this one request.
- The classic loop (`vfx-make`: data spec on `VFXTimeline`, capturer, three blind reviewers) is still there: use it
  when the user asks for it, for a recreation of a reference video, or when the effect must end as a `VFXTimeline`
  spec from the start.
