---
title: Build effects in the caster's space
tags: [vfx, rule, camera, orientation, character]
type: rule
updated: 2026-11-18
source: owner feedback (memory feedback_vfx-camera-independent)
---
# Build effects in the caster's space

> TL;DR
> - Build effects in the caster's frame, never tilted toward the test camera.
> - Check every effect from a top-down view as well as the showcase camera.
> - An effect that only reads from one camera angle is broken in a game.

## Why
Players see effects from any angle; tuning to the capture camera hides problems.
