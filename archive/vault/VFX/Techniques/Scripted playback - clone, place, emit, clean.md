---
title: Scripted playback - clone, place, emit, clean
tags: [vfx, scripting, timing, composition, runtime, technique]
type: technique
updated: 2026-11-18
source: https://www.youtube.com/watch?v=XXCGWREKpo0 (MoldySugar, 02:07-06:12); https://www.youtube.com/watch?v=MtAul-n9JmU (niitroxen, 19:13-34:06, 45:30-48:45); https://www.youtube.com/watch?v=GtqFcyFgIXQ (veraktt, 23:44)
---
# Scripted playback - clone, place, emit, clean

> TL;DR
> - Every tutorial uses the same skeleton: prefab in storage -> Clone -> set CFrame from the caster's root (or a marker) -> parent to a dedicated FX folder -> Emit / Enable -> destroy on a timer.
> - Counts live on the emitters as an `EmitCount` attribute (written by emit plugins); the script never hard-codes counts. A fallback (`or 50`) hides missing attributes - avoid it.
> - Each effect is split into an EMIT group (one-shot bursts) and an ENABLE group (lingering flames, aura, lights) fired on the same frame; the enable group is switched off after a hold and its particles die out naturally.
> - Layer groups are chosen by structure, not by name lists: hierarchy depth (direct children vs inside an attachment), separate prefabs, or attributes like `Ground` that switch a layer off for a variant before the emit pass.
> - Cleanup is `task.delay(t, Destroy)` with t longer than the longest particle lifetime; lights, beams and trails are toggled together with the particles they belong to.

## The skeleton (all three creators)
1. Prefab = a Part (or attachment root) holding all layers; stored in ReplicatedStorage or inside the effect's own ModuleScript.
2. Clone, `CFrame = HumanoidRootPart.CFrame * CFrame.new(0, 0, -5)` (in front) or a marker part's CFrame. niitroxen prefers HumanoidRootPart over `GetPivot()` because pivots can be offset.
3. Parent to `workspace.FX`. The folder keeps the workspace clean AND is excluded from every raycast/shapecast, so effects never block hits (veraktt).
4. Emit pass over `GetDescendants()`: ParticleEmitter -> `Emit(GetAttribute("EmitCount"))`.
5. `task.delay(1, function() clone:Destroy() end)` - non-blocking; `task.wait` would stall the rest of the move.

```lua
for _, e in fx:GetDescendants() do
  if e:IsA("ParticleEmitter") and e.Enabled then e:Emit(e:GetAttribute("EmitCount")) end
end
```

## Composition through structure
- Burst + linger (MoldySugar 05:27, 06:12): emit prefab and enable prefab on the same frame, `task.wait(2)`, enable prefab off. Reads as "an explosion with a lingering effect". The enable helper also switches Beam, Trail and PointLight, so the glow lives exactly as long as the flames.
- Depth as group (niitroxen 45:30): persistent layers (Fire, Smoke) are direct children of the part, burst layers (CircleAura 2, Spark 4, SpikeWave 12, Circular 1) sit inside an `Explosion` attachment. `GetChildren()` toggles only the linger group; `GetDescendants()` emits everything.
- Variant tags (veraktt 23:44): before the emit pass, layers with attribute `Ground` are disabled when the hit has no real surface; the emit pass then fires only layers still Enabled. Enabled doubles as "this layer is part of this variant".
- One module per effect returning `function(Character)`, prefab inside the module (niitroxen): callers swap effects by swapping one require.

## Sequences seen
- Burst on arrival: tween the body forward (0.5 s, Cubic for punch), `Completed:Wait()`, then emit (niitroxen 38:26-39:31).
- Fade the body after the burst: tween Transparency 1 + Size up 1.5x over 1 s, destroy on its own timer (niitroxen 47:30).
- Impact beat stack: emit + sound + camera shake + rocks + colour flash all on the same frame (MoldySugar 05:27-09:19).

## For vfxmith
- Our spec timeline already plays layers; adopt the GROUP idea: every layer belongs to `burst` or `linger`, linger has an explicit off time, and the runtime waits max(Lifetime) before destroying.
- Support variant tags (ground / air / wall) so one impact spec serves several surfaces.
- Related: [[Syncing effects to a character animation]], [[Endings and residue]], [[Short lingering outros]], [[Projectile VFX - head, flight and surface impact]].
