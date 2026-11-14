# Starting recipes, as they play

Each sheet is one `knowledge/categories/<type>_recipe.luau` played by `kit/runtime/VFXTimeline.luau` in Studio on a
dark stage and frozen at t = 0.03, 0.1, 0.2, 0.35, 0.55, 0.8, 1.2, 1.8, 2.6 s (a missing time = that still was not
captured). They are starting points tuned once against the real effects in `gallery/effects/<type>/`: build on them
with the `vfx-make` loop, do not ship them as they are.

Re-captured 2026-11-14 after the texture-traits pass (same camera and times): `explosion_recipe` (new flash and crack
textures, longer body, grey smoke rising from the ground, dust skirt), `beam_recipe` (white rune instead of the blue
one, crisper star) and `impact_recipe` (new flash and shock-ring textures; it is over by ~1 s, so its strip stops at
1.2 s). `misc_recipe`'s strip predates its one small swap (the glint's black twin). All strips are on the dark stage:
check your version in daylight too (`C.stage("day")`).
