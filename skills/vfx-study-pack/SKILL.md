---
name: vfx-study-pack
description: Safely study, scan and clean a downloaded Roblox VFX pack (.rbxm/.rbxl/.rbxmx, often from Discord) without opening it in Studio - finds backdoors (remote require, getfenv markers, obfuscated scripts, webhooks), catalogues every effect and texture, cuts single effects out with all scripts removed, replays them in Studio and learns from them. Use for "is this pack safe", "learn from these VFX", "add this pack to the library".
---

# Study a VFX pack safely

`ROOT` = `<base directory>/../..`. Packs shared online are full of experienced artists' work AND of backdoors: remote
`require(<asset id>)` hidden in rigs behind hundreds of blank lines, `_G.x = getfenv()` plugin-virus markers,
obfuscated scripts under Terrain, Discord webhooks, files ripped from live games with exploit "SaveInstance" tools.
Real findings: `SECURITY.md`.

## Rules
- Unzip into its own new folder, outside any game project. Never open a pack file in Studio and never press Play in
  one before it is scanned and cleaned. Never copy a script out of a pack.
- Read files only with these scripts (pure Python, nothing in the file runs): `kit/scripts/rbxdump.py` decodes
  binary and XML Roblox files (tree, every property, attributes, script sources as text).

## 1. Catalogue + scan
```bash
python3 -I "ROOT/kit/scripts/vfx_catalog.py" <pack folder> <out>
```
Writes `effects.jsonl` (every effect: layers, textures, timing, tags), `textures.json`, `stats.json`, and `files.json`
with `suspicious` scripts per file (remote require, getfenv/setfenv, loadstring, escape-string blobs, webhooks). Read
every flagged script as text (`rbxdump.py <file> --scripts <dir>`), and also grep the extracted sources for: blank-line
padding before code, `InsertService`/`GetObjects`, outside URLs, `TeleportService`, purchase prompts, and banners like
"Saved by ...SaveInstance" or "Decompiled with" (ripped from a live game: not open source, leave it out).

## 2. Clean
- Remove one bad script or secret without touching anything else (lossless, binary files):
  `python3 -I "ROOT/kit/scripts/rbxpatch.py" <in> <out> --ref <referent> [--ref ...] --note "removed: <why>"` or
  `--replace "https://discord.com/api/webhooks/" "<removed>"`. It verifies the result by decoding it again.
- Or take only the effect: `kit/scripts/rbxcut.py <file> --ref <referent> --out <x>.rbxmx` cuts one effect out with
  every script removed by construction.
- VFX Forge's emit module (inside some packs) is licensed VFX-DL: Roblox games only, keep the licence, never load it
  in a plugin or tool (`LICENSES/VFX-DL.txt`). Effects authored with its attributes are fine to study.

## 3. Look and learn
- Texture vocabulary: `kit/scripts/texture_sheets.py --catalog <out> --out <dir>` (contact sheets of the most shared
  textures; LOOK at them). Layer list of one effect: `kit/scripts/layer_table.py <out> <effect id>`.
- See effects: cut them into Studio's content folder and replay them with `kit/studio/VFXLibPlayer.luau`
  (`prepare`, `calibrate`, `batch`; stills with `kit/scripts/stills.py --follow`, framing measured with
  `kit/scripts/framing.py`; sheets with `kit/scripts/still_sheet.py`). Check ONE effect's frames before any batch.
  The player follows `knowledge/archive/os-conventions.md`; motion made by an effect's own scripts is missing.
- Study per effect type with analyst agents (sheets + layer tables + conventions + texture vocabulary); write what you
  learn into `knowledge/archive/categories/<type>.md` and cross-type rules into `knowledge/archive/patterns.md`.
- To add the pack to this library: catalogue the cleaned copy and rebuild the cards (`library/`) and search index the
  same way (`library/README.md`).
