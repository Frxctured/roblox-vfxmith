# Third-party content

This repository has two kinds of content:

| Part | Whose | Terms |
|---|---|---|
| `skills/`, `agents/`, `commands/`, `kit/`, `knowledge/`, `library/` (cards = our layout of the creators' values), `catalog/`, the docs | made for this project | MIT (`LICENSE`) |
| The open-source pack (release download) | the creators of each file | as shared by them (see below) |
| `gallery/` images | screenshots of the pack's effects (effects/), thumbnails of public Roblox images (textures/) | the effects and images belong to their creators; shown for study and reference |

## The open-source pack
The pack is a collection of open-source Roblox VFX, models and places that their creators shared publicly (mostly on
Roblox VFX Discord servers and the Creator Store), gathered into one archive. Nothing in it was made by this project
except the cleanup described in `SECURITY.md` and `PACK.md`. Where a file names its creator, the credit is listed in
`README.md`. If you made something in it and want it credited differently or removed, open an issue.

Files that were clearly **not** shared by their owners were left out: 5 files saved from live games with an exploit
"SaveInstance" tool and a decompiler (their scripts carry the tool's banner), and one audio clip that appears to be taken
from a commercial anime. See `PACK.md`.

## VFX Forge (zilibobi)
Six pack files ship the **VFX Forge emit module** (`EmitModule`), licensed under the **VFX Forge Developer License
(VFX-DL) 1.0** (full text in `LICENSES/VFX-DL.txt` and inside each copy of the module). In short:
- you may use it in Roblox games (also commercially) and share it with other developers, keeping the licence;
- you may **not** load it in a Studio plugin, editor extension, command-line tool or test harness;
- derivatives must use the same licence.

These files are marked "ships VFX Forge runtime" in `PACK.md`. Another 41 files only *use* VFX Forge's attribute format
(effects authored with the plugin); they need the emit module, or a compatible player, to animate, and they carry no
Forge code. This project does **not** contain or load any VFX Forge code: `VFXLibPlayer.luau` replays the attribute
format with its own implementation, written from the behaviour described in
`knowledge/os-conventions.md`.

## Libraries inside pack files
Some pack files include community libraries with their own licences (e.g. HD Admin, TopbarPlus, HyperText, Chrono,
PacketPlus, Rich-Subtitles, an Octree module, CamShake modules). Check each library's own terms before shipping it.

## Roblox asset ids
Effects, the findings and the texture vocabulary reference Roblox asset ids (textures, meshes, sounds) uploaded by
other people. Referencing an id is how Roblox effects work, but the image or mesh behind it belongs to its uploader,
and Roblox may require permission for an asset to load in your experience. Using them in a published game is your
decision; for anything commercial, prefer your own uploads or assets whose creator allows it.

## VoidRend example
`kit/examples/VoidRend/` is our own recreation of a reference video shared by a VFX artist on Discord
("Styl_VoidRend_v2"). The reference video and the comparison images/videos that contain its frames are **not**
included; our spec, generators, meshes, textures, renders and review log are.
