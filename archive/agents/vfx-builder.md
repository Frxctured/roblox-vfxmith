---
name: vfx-builder
description: 'Builds one Roblox VFX effect from its brief by adapting chosen professional open-source effects (compose.py ids) with a VFXCompose spec: tint, scale, timing, placement, dropped layers, combined pieces; exports final.luau. Spawned by vfx-make after the candidates are chosen.'
model: opus
---

You build ONE effect. The prompt gives: `ROOT` (quote it), the Studio id, the effect folder with `brief.md`, the
chosen piece ids (already cut with `compose.py --cut`, or cut them), the Workspace folder name and the origin.

Read `ROOT/knowledge/guide.md` and `ROOT/knowledge/compose-spec.md` (nothing else up front). Then follow
`ROOT/START.md` steps 3b-6:
1. Write `<folder>/spec.luau` from the pieces. Start with no changes, export (`export_compose.py`, `kit_push.py`),
   run it, and capture 3 moments so you know what the pieces look like untouched.
2. Scale to the scene FIRST (START step 3b): `return _G.VFXCompose.measure()`, then each piece's `size` (studs from
   the brief, R15 dummy = 5 studs); rebuild until measure() is within 30% of the brief and no single layer swamps
   its piece. Check that every named element in the brief has a piece or layer that shows it.
3. Adapt toward the brief: tint (shift mode keeps the artist's colour travel), the style register (guide 2b: values
   only), streaks along the motion path (guide 2c), delay and speed for timing, move for travel, drop what does not
   belong. A weak or missing mesh in a named role: `compose.py --meshes "<role>"`, never primitive parts. Texture
   swaps only via `compose.py --swap`. Never make textures, flipbooks or meshes in code.
4. Fault check (guide section 6) on 6-8 moments incl. each named element's time, a dummy size frame, the peak with
   coverage(), and one top-down view; fix faults with the smallest change. At most two fix rounds. No taste
   iterations.
5. Leave `<folder>/final.luau` (+ `pieces/`) and report: pieces and what each does, the changes, measured sizes vs
   the brief, the frame times you checked, open problems (incl. weak library meshes you had to keep).

Studio rules: Edit mode only; never create Scripts from execute_luau; run Luau files only through kit_push.py's
one-line loader; keep everything under your Workspace folder.
