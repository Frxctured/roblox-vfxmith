# The pack: what is in it

Download: the release archive **Roblox VFX open-source pack** (462 MB unpacked). Folder layout is the original collection's (by the month the files were shared). Full per-file list: `pack_manifest.csv` (path, size, status, number of effects found, VFX Forge use, notes).

| | Files |
|---|---|
| Included as shared | 572 |
| Included after cleanup (`SECURITY.md`) | 4 |
| Left out: byte-identical duplicates | 16 |
| Left out: not open source | 6 |

By type: .rbxm 359, .rbxl 119, .png 85, .blend 8, .obj 3, .luau 1, .rbxmx 1.

The Roblox files hold about 1,900 distinct effects (emitter/beam/trail groups); `catalog/effects.csv` lists them with tags and layer counts, and `gallery/effects/` shows 77 of them frame by frame; `library/cards/` describes about 1,200 layer by layer.

## How to use the files safely
- Open a `.rbxm` by dragging it into Studio (or Model > Import), a `.rbxl` with File > Open. Do not press Play in a place you have not checked; read `SECURITY.md` first.
- Most effects are driven by attributes on the emitters (`EmitCount`, `EmitDelay`, `EmitDuration`): call `emitter:Emit(emitter:GetAttribute("EmitCount"))` after `EmitDelay`. The full conventions (also VFX Forge's) are in `knowledge/os-conventions.md`.
- Texture ids in the effects are other people's uploads: see `THIRD_PARTY.md`.

## Cleaned

| File | What changed |
|---|---|
| 190 OS (Oct 2024-Mar 2026)/Ranked.rbxl | Discord webhook token removed from ServerStorage/Modules/Utility (the game posted messages to its author's Discord); full game: has admin commands, ip-api.com server-location lookup and an unused web proxy module |
| 2026 OS Jan-April (part 2)/ToolboxMeshes.rbxm | junk removed: 2 copies of the old Roblox chat script hidden inside GravityBallShockwave meshes |
| Older OS (2025 and older)/November 2023/ANINE FX.rbxl | backdoor neutralised: hidden Script "Fix" (Workspace/Model/R15/LowerTorso/RightHipRigAttachment/OriginalPosition) that required two remote modules |
| Older OS (2025 and older)/November 2023/VFX__trash_fireball_1_month_and_1_week_progression.rbxl | plugin-virus markers neutralised: 3 hidden Scripts (Fix, LoadCharacter, Welding) running _G.AC = getfenv() |

## Left out

| File | Why |
|---|---|
| 190 OS (Oct 2024-Mar 2026)/Jingliu.rbxl | ripped from a live game with an exploit SaveInstance tool + decompiler (not open source) |
| 190 OS (Oct 2024-Mar 2026)/Tap.rbxm | ripped from a live game with an exploit SaveInstance tool + decompiler (not open source) |
| 190 OS (Oct 2024-Mar 2026)/iso_textures.rbxl | ripped from a live game with an exploit SaveInstance tool + decompiler (not open source) |
| 2026 OS Mar-April/STARCORE MAIN.rbxl | ripped from a live game with an exploit SaveInstance tool + decompiler (not open source) |
| Older OS (2025 and older)/November 2023/gojoDomainExpansion.mp3 | audio clip that looks taken from a commercial anime (copyrighted) |
| Older OS (2025 and older)/Oct 2024 - Jan 2025/asfile.rbxm | ripped from a live game with an exploit SaveInstance tool + decompiler (not open source) |

## Ships the VFX Forge runtime (VFX-DL: Roblox games only, keep the licence, never in plugins/tools)

| File |
|---|
| 2026 OS Jan-April (part 2)/SlammerHammerOS.rbxm |
| 2026 OS Mar-April/ArtemisArrowRainOS (2).rbxl |
| 2026 OS Mar-April/Plasma.rbxl |
| 2026 OS Mar-April/Wukong.rbxl |
| 2026 OS Mar-April/kickbarrage.rbxl |
| 2026 OS Mar-April/menumovement.rbxl |

## Authored with VFX Forge attributes (need the Forge emit module or a compatible player to animate)

| File | Instances |
|---|---|
| 190 OS (Oct 2024-Mar 2026)/Chara Giveaway.rbxm | 530 |
| 190 OS (Oct 2024-Mar 2026)/ChildEmporerVFX.rbxm | 115 |
| 190 OS (Oct 2024-Mar 2026)/Day1OS.rbxm | 3 |
| 190 OS (Oct 2024-Mar 2026)/Sancho Set.rbxl | 32 |
| 190 OS (Oct 2024-Mar 2026)/Stylized Fireball Explosion.rbxl | 163 |
| 190 OS (Oct 2024-Mar 2026)/SunOS.rbxm | 9 |
| 190 OS (Oct 2024-Mar 2026)/Vergil.rbxm | 643 |
| 190 OS (Oct 2024-Mar 2026)/blood slash.rbxm | 26 |
| 190 OS (Oct 2024-Mar 2026)/christmaswowwowow.rbxl | 227 |
| 190 OS (Oct 2024-Mar 2026)/os (1).rbxm | 78 |
| 190 OS (Oct 2024-Mar 2026)/takebeams.rbxl | 110 |
| 2026 OS Jan-April (part 2)/Charge Up.rbxm | 30 |
| 2026 OS Jan-April (part 2)/Don't need it.rbxm | 134 |
| 2026 OS Jan-April (part 2)/Fire explosion.rbxm | 70 |
| 2026 OS Jan-April (part 2)/IceExplosion.rbxm | 12 |
| 2026 OS Jan-April (part 2)/Projectile Move.rbxm | 30 |
| 2026 OS Jan-April (part 2)/Sukuna Aura.rbxm | 51 |
| 2026 OS Jan-April (part 2)/VFXchara.rbxm | 73 |
| 2026 OS Jan-April (part 2)/WukongVFXOpenSource.rbxm | 350 |
| 2026 OS Jan-April (part 2)/YujiThings.rbxm | 103 |
| 2026 OS Jan-April (part 2)/ZoltraakSpellVFX.rbxm | 66 |
| 2026 OS Jan-April (part 2)/ahhellnahbhhh.rbxm | 76 |
| 2026 OS Jan-April (part 2)/charavfxhere.rbxm | 112 |
| 2026 OS Jan-April (part 2)/coolosgoldblue.rbxm | 6 |
| 2026 OS Jan-April (part 2)/flame2.rbxm | 6 |
| 2026 OS Jan-April (part 2)/flameos.rbxm | 1 |
| 2026 OS Jan-April (part 2)/gender divergent fist!!.rbxm | 23 |
| 2026 OS Jan-April (part 2)/hakariOSby mmy.rbxm | 26 |
| 2026 OS Jan-April (part 2)/jane juliet lets larp.rbxm | 192 |
| 2026 OS Jan-April (part 2)/kick barrage.rbxm | 82 |
| 2026 OS Jan-April (part 2)/purple.rbxm | 7 |
| 2026 OS Jan-April (part 2)/smite.rbxm | 1 |
| 2026 OS Mar-April/Collab (1).rbxl | 85 |
| 2026 OS Mar-April/Light sacred jewel.rbxl | 514 |
| 2026 OS Mar-April/Purple.rbxl | 140 |
| 2026 OS Mar-April/SacredSwords.rbxl | 46 |
| 2026 OS Mar-April/WukongSpinRushVFXos.rbxl | 179 |
| 2026 OS Mar-April/polething.rbxl | 45 |
| 2026 OS Mar-April/zeninmassacre.rbxl | 80 |

## Kept, with a note

| File | Note |
|---|---|
| 2026 OS Jan-April (part 2)/BloodifyPlugin.rbxmx | a Studio plugin (plugins get full Studio access; it only loadstrings its own settings script) |
| 2026 OS Jan-April (part 2)/PacketPlus.rbxm | PackageLink with AutoUpdate on (Studio may pull newer versions published by the package owner) |
| Older OS (2025 and older)/November 2023/some back normal combat stuff.rbxl | contains HD Admin: its loader runs require(3239236979) (the official HD Admin module, remote code that updates itself) |

## Duplicates left out

| File | Same as |
|---|---|
| 190 OS (Oct 2024-Mar 2026)/Azl Dialog (1).rbxm | 2026 OS Jan-April (part 2)/Azl Dialog.rbxm |
| 190 OS (Oct 2024-Mar 2026)/Forest of Seasons by Sinister unfinished (1).rbxl | 2026 OS Mar-April/Forest of Seasons by Sinister unfinished.rbxl |
| 190 OS (Oct 2024-Mar 2026)/MapBy7amm (1) (1).rbxl | 2026 OS Mar-April/MapBy7amm (1).rbxl |
| 190 OS (Oct 2024-Mar 2026)/Mountains lol (1).rbxl | 2026 OS Mar-April/Mountains lol.rbxl |
| 190 OS (Oct 2024-Mar 2026)/RedSpear (1).rbxm | 190 OS (Oct 2024-Mar 2026)/RedSpear.rbxm |
| 190 OS (Oct 2024-Mar 2026)/Sukuna Aura (1).rbxm | 2026 OS Jan-April (part 2)/Sukuna Aura.rbxm |
| 190 OS (Oct 2024-Mar 2026)/ice hot (1).rbxm | 2026 OS Jan-April (part 2)/ice hot.rbxm |
| 190 OS (Oct 2024-Mar 2026)/jjk thing rework (1).rbxm | 2026 OS Jan-April (part 2)/jjk thing rework.rbxm |
| 190 OS (Oct 2024-Mar 2026)/reversalredOS (1).rbxl | 190 OS (Oct 2024-Mar 2026)/reversalredOS.rbxl |
| 2026 OS Jan-April (part 2)/BloodPools-Update2 (1).rbxm | 2026 OS Jan-April (part 2)/BloodPools-Update2.rbxm |
| 2026 OS Jan-April (part 2)/HyperText v2.0.6 (1).rbxm | 2026 OS Jan-April (part 2)/HyperText v2.0.6.rbxm |
| Older OS (2025 and older)/November 2023/Domain-OpenSource.rbxl | 190 OS (Oct 2024-Mar 2026)/Domain-OpenSource.rbxl |
| Older OS (2025 and older)/November 2023/Holographic_Spawn.rbxm | 190 OS (Oct 2024-Mar 2026)/Holographic_Spawn.rbxm |
| Older OS (2025 and older)/Oct 2024 - Jan 2025/Star or Constellation Trail Effect.rbxm | 190 OS (Oct 2024-Mar 2026)/Star or Constellation Trail Effect.rbxm |
| Older OS (2025 and older)/Oct 2024 - Jan 2025/ice hot.rbxm | 2026 OS Jan-April (part 2)/ice hot.rbxm |
| Older OS (2025 and older)/important (cool) rbx (Nov 2023)/COOL AF DRAGON.rbxl | Older OS (2025 and older)/November 2023/OS-Dragon-Test.rbxl |
