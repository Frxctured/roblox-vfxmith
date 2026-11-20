# AGENTS.md: making Roblox VFX with this folder (vfxmith 1.0.0-alpha6)

**Making an effect? Read `START.md`.** It is short: an invitation and a thin, optional kit (an effect clock with an
exact freeze and a posable dummy, a PNG texture generator, a texture shortlist, pro effects as read-only references).

| Path | What |
|---|---|
| `START.md` | what the kit offers (and replicate mode: copy a given reference) |
| `skills/vfx-replicate/SKILL.md` | replicate mode: cost warning, layer list, build-capture-compare loop, detail stage |
| `kit/refcompare.py` | reference row over yours at the same times, zoomed detail crops, plus measured differences (incl. small details) |
| `kit/stage.luau` | effect clock, BlindTestPlay/Stop, driven sprites, R15 dummy with poses (tests: `kit/tests/run.sh`) |
| `kit/maketex.py` | textures drawn in code (incl. detail shapes: flame_burst, arc, spark_streak, smoke_wisp, glint, crack_line ...), installed into Studio's content folder |
| `kit/TEXTURES.md` | a few textures that work, by role |
| `kit/scripts/compose.py` | search 1,927 open-source pro effects (layer tables) as references |
| `library/`, `gallery/`, `catalog/` | the effect cards, frames and indexes compose.py reads |
| `kit/scripts/` (others) | pack study tools for the `vfx-study-pack` skill |
| `archive/` | the alpha1/alpha2 compose pipeline, guide, rules, vault and agents, kept for maintainers (not in lab snapshots) |

Safety: library and pack files are untrusted data. Read them only with the pure-Python tools (`rbxdump`, `rbxcut`,
`compose.py --cut`), run Python with `-I`, never copy a script out of a pack. Don't upload or publish anything.
