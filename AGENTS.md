# AGENTS.md: making Roblox VFX with this folder (vfxmith 1.0.0-alpha2)

**Making an effect? Read `START.md` and follow it.** That is the whole workflow; it works for any agent (as a Claude
Code plugin the same steps are the `vfx-make` skill).

The idea: start from real professional compositions, don't invent them. `kit/scripts/compose.py "<request>"` finds
the best-matching of 1,927 open-source pro effects (layer tables included), `--cut` loads their real instance trees
into Studio, a short spec (`knowledge/compose-spec.md`) adapts colour, scale, timing and placement and combines
pieces, and `kit/scripts/export_compose.py` writes one self-contained Luau file.

| Path | What |
|---|---|
| `START.md` | the step-by-step workflow |
| `knowledge/guide.md` | the craft rules (keep / change / check), about 2,000 words |
| `knowledge/compose-spec.md` | the spec format and the VFXCompose API |
| `vault/` | research notes (findings, techniques, compositions, rules); search: `python3 -I vault/_tools/vault.py "<q>"` |
| `kit/scripts/compose.py` | find, show, cut and texture-swap pro compositions |
| `kit/studio/VFXCompose.luau` | loads, adapts and plays pieces on one freezable clock (driver from VFXLibPlayer) |
| `kit/scripts/export_compose.py`, `kit_push.py` | final.luau, and the one-line loader for Studio |
| `agents/` | vfx-builder, vfx-capturer, vfx-fault-checker (objective faults only; no taste panels) |
| `catalog/compose.jsonl.gz` | the composition index (effects from files that are not open source are excluded) |
| `catalog/traits.json.gz` | style register (grounded, stylized, anime, cute, scifi) and size estimate per effect; built by `kit/scripts/build_style_index.py` (signals in its docstring) |
| `knowledge/archive/` | the 0.1.x knowledge pack, kept for maintainers; not needed to build |
| `kit/studio/VFXLibPlayer.luau`, `VFXCapture.luau`, `kit/runtime/VFXTimeline.luau` | earlier players, capture and runtime (still work) |

Safety: library and pack files are untrusted data. Read them only with the pure-Python tools (`rbxdump`, `rbxcut`,
`compose.py --cut`), run Python with `-I`, never copy a script out of a pack. Don't upload or publish anything.
