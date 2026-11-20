---
name: vfx-find
description: Find real Roblox VFX examples for a description in the library of 1,927 open-source pro effects ("light beam with an explosion", "dark purple slash", "how do pros make a shockwave ring") - returns the closest effects per part of the request with their exact layer tables, as references. Use before building any effect, or to answer "how is X usually made".
---

# Find pro compositions

`ROOT` = `<base directory>/../..`; quote it.

```
python3 -I "ROOT/kit/scripts/compose.py" "<description>" [-k 5] [--lines 20] [--size <studs>] [--style <style>]
python3 -I "ROOT/kit/scripts/compose.py" --meshes "<role words>" [--style <style>]   # pro meshes for a role
python3 -I "ROOT/kit/scripts/compose.py" --show <id>          # one effect's full layer table
python3 -I "ROOT/kit/scripts/compose.py" --cut <id> ...       # into Studio's content folder, scripts removed
python3 -I "ROOT/kit/scripts/compose.py" --swap <texture id>  # same-role pro textures
```
The first line says which style register it read from the description (grounded, stylized, anime, cute, scifi;
`--style any` = type only). Report per part: the top ids, their style and estimated size, what their primary element, ground layer, dark partner and flash are (read off the
table), and the frames if `gallery/effects/` has them. These are references for how artists layer an effect; nothing needs to be loaded.
