# House example: ice slam (no plugin)

**Rating:** 8/10 from the owner, 8.0 from a blind panel (tied with vfxmith 0.1.6, which cost about the same). Made by
Claude Opus 5.5 with Studio screenshots and no plugin, from the brief: heavy melee skill, fist lands at 0.25 s, main
action ~1.5 s, frost lingers to ~2.5 s, crisp anime ice. Owner's words: best moment "when the ice crystals exploded,
when the thing disappeared"; "the glow was basically perfect"; "I liked how [the frost] stayed a bit there"; "in some
fighting game, I would use it as is". Feedback: `feedback/2026-11-15-ice-slam-no-plugin.md`.

Learn the techniques below for any effect type; don't copy the effect. Line numbers refer to `effect.luau`.

## What makes it work
1. **Restrained light.** One PointLight, Range 12 (l.570-571), at most 0.8 in the wind-up, 3 at contact, off by
   0.55 s, nothing at the break. Particles keep Brightness 1. The floor stays clean, so the hit reads as a jump (lit
   area x6.4 at contact) and the shapes carry the look. White: 4.1% of the frame at the hit, gone by 0.45 s.
2. **A wind-up that leads into the hit.** A frost ring closes in and a "fist comet" falls (l.785-832, inQuad), brightest
   on the frame before contact.
3. **A hit made of shapes, not a ball.** An 8-stud Neon dome for ~0.11 s (l.535-544), a sparkle star at Size 16 (32
   studs, l.458-470) and 22 thin Neon speed lines (l.575-597) that thin out.
4. **A hero that carries its own colours.** Faceted crystals built in code (`A.buildSpikeMesh`, l.282): vertex colours
   deep blue at the base, cyan body, white tip, alternating lighter/darker facets, SmoothPlastic, so they read as
   solid ice in daylight without glowing. Now in the kit as `ctx.Crystal`.
5. **The break (the owner's favourite).** Each spike turns Neon white-hot for 0.045 s (l.911), then breaks in one frame
   into a stump (24-32% of its height, l.628) and 3-7 shards along its body, with dust and a glint star. Breaks travel
   from the centre outward over ~0.16 s, so you see ~29 separate pops. No light pop lights the scene first. 145
   shards fly with gravity 62 (l.379), land and stay.
6. **Residue that stays.** A near-opaque frost patch (transparency 0.05) with cracks, the stumps and 15 small ground
   crystals hold until 1.8 s, then fade slow-at-first (inQuad, l.887-892). The frost is still ~4% of the frame at 2.2 s.
7. **Built-in textures only for particles** (`rbxasset://textures/particles/...`), its own textures for the ground
   decals; nothing uploaded.

## What it does worse (fix these when you borrow from it)
- The ring is a plain fading circle; the owner prefers an animated, textured flipbook ring (0.1.6 had one).
- A lopsided grey smoke lump on the left from 0.5 to 1.2 s.
- About 2 frames of a white ball at contact; a small hard cut at 2.45 s with the frost still partly visible.
- The owner would make it a little less saturated.

## Caveats
- Crystals use EditableMesh and the ground decals EditableImage: in a live game both need Experience Settings >
  Security > "Allow Mesh / Image APIs" and client memory. `ctx.Crystal` has an automatic fallback; decals made with
  EditableImage do not (use an uploaded or library texture in a game).
- `effect.luau` is a test build: it defines `_G.BlindTestPlay` / `_G.BlindTestStop`. For a game, rebuild it as a
  VFXTimeline spec or a client module.

Full frame-by-frame comparison with 0.1.6 (24 fps, same take): the maintainer's test notes (ice re-run, 2026-11-15).
