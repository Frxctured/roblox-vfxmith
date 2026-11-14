# Security review of the pack

Open-source Roblox packs often carry backdoors: scripts that hand control of your game to someone else. Every script in
the pack (10,103 of them, in 507 Roblox files) was decoded **without opening anything in Studio**
(`kit/scripts/rbxdump.py`) and searched for:
- modules loaded by asset id (`require(123...)`);
- `getfenv`/`setfenv` and `loadstring`;
- scripts that clone themselves;
- `InsertService`/`GetObjects` loading;
- Discord webhooks and every outside URL;
- obfuscated code and obfuscator signatures;
- remotes that run code they receive;
- kicks, bans, teleports and purchase prompts;
- code hidden below long runs of blank lines;
- auto-updating packages;
- decompiler and exploit-tool banners.

Every hit was read by hand.

## What was found and done

| File | Finding | Action |
|---|---|---|
| `November 2023/ANINE FX.rbxl` | **Backdoor.** A Script named `Fix` hidden inside a rig (`Workspace/Model/R15/LowerTorso/RightHipRigAttachment/OriginalPosition/Fix`), disguised as "this script secures your game from exploiters", with ~300 blank lines pushing the code out of sight. It runs `require(3667797501)` and `require(3664252382)`: remote modules whose owner can change them at any time (typically admin/server control of your game) | **Cleaned**: Source replaced by a comment, script disabled |
| `November 2023/VFX__trash_fireball_1_month_and_1_week_progression.rbxl` | **Plugin-virus markers.** 3 tiny Scripts (`Fix`, `LoadCharacter`, `Welding`) hidden in effect parts, each `_G.AC = getfenv()` with a fake "licence plates" comment: the mark a malicious Studio plugin leaves in models, a hook for other malicious code | **Cleaned** (same way) |
| `190 OS/Ranked.rbxl` | A real Discord webhook token (the game posted messages to its author's Discord) | **Token removed** from the source; the full game also has admin commands, a server-location lookup (ip-api.com) and an unused web-proxy module |
| `2026 OS Jan-April (part 2)/ToolboxMeshes.rbxm` | 2 copies of the old Roblox chat script stuffed inside "GravityBallShockwave" meshes (toolbox junk, no remote code) | **Cleaned** |
| `2026 OS Mar-April/STARCORE MAIN.rbxl` | Obfuscated LocalScript hidden under `Workspace/Terrain/Clouds` (scrambled VM + `getfenv`), a Discord webhook, and every script decompiled from a live game | **Excluded** (see `PACK.md`) |
| `Jingliu.rbxl`, `iso_textures.rbxl`, `Tap.rbxm`, `asfile.rbxm` | Saved from live games with an exploit SaveInstance tool | **Excluded** |
| `November 2023/some back normal combat stuff.rbxl` | Contains HD Admin; its loader runs `require(3239236979)` (the genuine HD Admin module, still remote code that updates itself) | Kept, flagged |
| `2026 OS Jan-April (part 2)/PacketPlus.rbxm` | A package link with AutoUpdate on | Kept, flagged |
| `2026 OS Jan-April (part 2)/BloodifyPlugin.rbxmx` | A Studio plugin; its `loadstring` only runs its own settings script (normal), but plugins get full Studio access | Kept, flagged |

Cleaning is lossless: `kit/scripts/rbxpatch.py` rewrites only the affected scripts' `Source` (and their
Disabled flag) inside the binary file; every other instance and property is byte-identical, checked by decoding the
file before and after.

## Safe habits with any pack (including this one)
- A pattern scan can miss something cleverly hidden. Treat every script you did not write as untrusted.
- Prefer taking the **effect instances** (emitters, beams, attachments, meshes) and leaving the scripts behind:
  `rbxcut.py` cuts one effect out of any file with every script removed.
- Before pressing Play in a place built from downloaded files, search it for `require(` with a number, `getfenv`,
  `loadstring`, `InsertService`, webhooks, and scripts in odd places (inside rigs, Terrain, deep in effect parts).
- If you used the original, uncleaned files in a game before, search that game for scripts named `Fix`,
  `LoadCharacter` or `Welding`, and for `require(3667797501)`.
- Re-run the scan yourself: `python3 -I kit/scripts/vfx_catalog.py <pack folder> <out>`, then look at
  `files.json` (`suspicious`).
