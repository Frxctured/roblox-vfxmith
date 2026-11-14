# Library: real effects, one card each

1188 effects from the open-source pack (all with 3 or more layers), one markdown card each in
`cards/<category>/<id>.md`: category, tags, layer counts, how it is fired, the source pack file and instance
referent, its frames in `gallery/effects/` when captured, and one line per layer with every value that shapes it.

Search: `python3 -I kit/scripts/find_effects.py "<description>"` (or the `vfx-find` skill / `vfx-librarian`
agent). `index.jsonl` is the search index (one JSON line per card).

Categories: slash 246, beam 201, impact 161, explosion 116, darkportal 115, projectile 79, aura 77, misc 72, lightning 71, fire 32, icewater 18.

Layer line format: `E` emitter, `B` beam, `T` trail; texture id (light mode A additive / D dark / M mixed,
flipbook grid, common layer name); colour ramp; LE/LI/Br = LightEmission/LightInfluence/Brightness; life =
Lifetime; size = Size curve shape (grow 0->12 = from 0 to 12 studs; swell a->peak@t->end); tr = Transparency
(start..min, vis = when most visible as a fraction of life, ->end); spd/drag/spread/acc/rotSpd; orientation;
squash; flip (layout, mode, fps); z = ZOffset; `EMIT n @t (for d)` = burst, `RATE r` = continuous.

The values are the creators' (see THIRD_PARTY.md); texture ids are their uploads.
