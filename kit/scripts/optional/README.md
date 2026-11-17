# Optional capture helpers (not needed for any workflow)

The default self-check works on Windows, macOS and Linux with nothing but the Studio MCP: frozen stills through
`fx:Shots` + `fx:NextShot` + `screen_capture`, sheets with `kit/scripts/kit_sheet.py` (`knowledge/selfcheck.md`).

A live 60 fps recording shows a little more (flicker, particle paths between frames). If you can record the screen:
- **Any OS:** record the Studio viewport with any screen recorder (OBS, Xbox Game Bar, QuickTime, ...) while
  `fx:LiveRun({"player", "side", "front", "bird"})` plays; then
  `ffmpeg -i rec.mp4 -vf "fps=10,scale=480:-1,tile=8x6" -frames:v 1 overview.jpg` for an overview and
  `ffmpeg -ss <hit - 0.1> -t 0.4 -i rec.mp4 -vf "scale=480:-1,tile=8x3" -frames:v 1 hit.jpg` for every frame of a hit.
  `cut.sh` does both when you know the recording's start time.
- **Linux with the niri compositor** (the maintainer's setup; other compositors need their own commands):
  `rec.sh` (wf-recorder, focuses the window by id), `shot.py` (window screenshot through the clipboard) and
  `sched.py` (frozen sheet on a wall clock, no images in the agent's context). Each file's header has its usage.

Recording needs the Studio window visible and focused: only do it when the user is not typing elsewhere.
