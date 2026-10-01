# The Witcher 3 - Sprint and Gallop Toggles

Tested on the next-gen (4.0x) Steam version under Proton on Linux.

## 1. On-foot sprint toggle (no mod)

The game has a built-in `SprintToggle` action. In `input.settings`, find and replace:

```
IK_LShift=(Action=Sprint)
```

with:

```
IK_LShift=(Action=SprintToggle)
```

`input.settings` path under Proton:

```
~/.local/share/Steam/steamapps/compatdata/292030/pfx/drive_c/users/steamuser/Documents/The Witcher 3/input.settings
```

## 2. Horse gallop toggle (`modGallopToggle.zip`)

There's no `GallopToggle` action. The `[Horse]` bindings are:

```
IK_LShift=(Action=Canter)
IK_LShift=(Action=Gallop,State=Duration,IdleTime=0.3)
```

Holding Shift for gallop is enforced in the horse script, so editing `input.settings` can't change it. A script mod is needed.

### Behaviour

- Tap Shift: canter (vanilla)
- Double-tap Shift: gallop, which **stays on** after you let go
- Single tap while galloping: drop back to canter

### Install

Extract `modGallopToggle.zip` into the game's `Mods` folder (create the folder if it doesn't exist):

```
~/.local/share/Steam/steamapps/common/The Witcher 3/Mods/modGallopToggle/content/scripts/game/vehicles/horse/states/exploration.ws
```

The game compiles scripts on launch. To uninstall, delete the folder. No `input.settings` changes are needed.

### How it works

The mod is a copy of the game's own `content/content0/scripts/game/vehicles/horse/states/exploration.ws` with three small edits in `OnSpeedPress` / `OnSpeedHold`.

Note that the script names are swapped compared to the UI: `GALLOP_SPEED = 3` is what the game calls canter, and `CANTER_SPEED = 4` is the real gallop.

1. **Releasing Shift keeps the gallop lock.** Vanilla calls `ToggleSpeedLock('OnGallop', false)` on release, which lets the speed drop back down. The mod only unlocks when `destSpeed < CANTER_SPEED`. This is done in both the `Canter` and `Gallop` handlers.
2. **A single tap while galloping drops back to canter.** It sets `destSpeed = GALLOP_SPEED` and unlocks. This check has to come *before* the vanilla `if(CanCanter() && (!IsSpeedLocked() || ...))` guard. Otherwise the lock that keeps the gallop going also blocks the tap, and you can't turn the gallop off. That was the bug in the first attempt.
3. Stamina is unaffected. `useSimpleStaminaManagement` defaults to `true`, so the existing speed-decay code respects the lock.

Every edit is marked with a `// modGallopToggle:` comment. To see the changes:

```
diff "<game>/content/content0/scripts/game/vehicles/horse/states/exploration.ws" "<game>/Mods/modGallopToggle/content/scripts/game/vehicles/horse/states/exploration.ws"
```

The original file has mixed CRLF/LF line endings. Edit it byte-for-byte so you don't produce a diff that touches every line.

### Why not Rolls-Roach

[Rolls-Roach - Toggle Horse Gallop-Canter](https://www.nexusmods.com/witcher3/mods/5513) does the same thing, but it replaces the whole `exploration.ws` with a 1.32 version. On next-gen that will probably fail to compile or remove newer fixes. This mod starts from the next-gen file instead.

### After game updates

If a patch changes `exploration.ws`, delete the mod folder and redo the edits on a fresh copy of the new file. If you add other script mods that touch `exploration.ws`, merge them with Script Merger.
