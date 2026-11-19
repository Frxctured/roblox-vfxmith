---
name: vfx-make
description: Build a Roblox VFX effect end to end from a description ("frost nova", "holy smite", "purple aura on the player") by finding the best-matching professional open-source effects, loading their real instance trees into Studio, adapting colour/scale/timing/placement to the brief, combining pieces, one objective fault check from captured frames, and exporting a self-contained Luau file. Use for "make a VFX", "improve this effect", any new effect.
---

# Make a Roblox effect from pro compositions

`ROOT` = `<base directory>/../..` (`${CLAUDE_PLUGIN_ROOT}`); quote it. Follow `ROOT/START.md` step by step; this
skill only adds the user checkpoints and the agents.

## Steps
1. **Brief** (START step 2). Ask the user only what the request leaves open (one message): where it lives, size,
   length, colours, game style. Write `<effect>/brief.md` with the style register and the named-elements table
   (every thing the request names + when it is on screen).
2. **Find** (START step 3): `compose.py "<request>" --size <studs>` (ranks by type and style register), cut 2-4
   candidates, capture 2-3 frames of each (spawn the `vfx-capturer` agent for this to keep frames out of your
   context).
3. **Checkpoint 1 (default)**: show the user the candidates' frames and say which you would pick and why; let them
   pick. In **auto mode** (the user said "just do it", or no user is reachable) take the closest yourself.
4. **Scale first, then build** (START steps 3b and 4): measure every piece and set its `size` to the brief before
   any styling; then spawn `vfx-builder` with the brief, the chosen ids and the folder, or do it yourself
   for a small effect. Spec in `<effect>/spec.luau`, exported with `export_compose.py`.
5. **Fault check** (START step 5): `vfx-capturer` takes 6-8 moments (incl. each named element's time), a dummy size
   frame, the peak with coverage() and a top-down view; `vfx-fault-checker` reports objective faults only (guide
   section 6: scale beyond 30%, named elements, streaks vs motion path, opposite style register, ...). Fix,
   re-check once. There is no taste review: AI judges disagreed with people, so quality comes from the pro pieces
   and the user.
6. **Checkpoint 2 (default)**: show the user the frames; ask what they like and dislike (`vfx-feedback`). Apply
   their changes. Skip in auto mode.
7. **Export**: `final.luau` from export_compose.py (+ `pieces/`); for a game, the same file run once in Studio
   builds the templates, or keep the spec + VFXCompose as ModuleScripts on the client.

Rules: scale to the scene before styling; every named element on screen at its time; streaks follow the motion
path; never draw textures/meshes in code; a weak library mesh is noted, not replaced by primitives; texture swaps
only via `compose.py --swap`; prefer dropping, tinting, scaling and retiming over adding layers.
