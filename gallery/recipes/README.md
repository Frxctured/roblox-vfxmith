# Starting recipes, as they play

Each sheet is one `knowledge/categories/<type>_recipe.luau` played by `kit/runtime/VFXTimeline.luau` in Studio on a
dark stage and frozen at t = 0.03, 0.1, 0.2, 0.35, 0.55, 0.8, 1.2, 1.8, 2.6 s (a missing time = that still was not
captured). They are starting points tuned once against the real effects in `gallery/effects/<type>/`: build on them
with the `vfx-make` loop, do not ship them as they are.
