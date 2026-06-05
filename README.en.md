<!-- Language switch -->
[简体中文](README.md) | **English**

# ADOFAI Trainer · 冰与火之舞 修改器

An **in-game GUI trainer** for *A Dance of Fire and Ice*, built on BepInEx 5. Press **Insert** to open the overlay — autoplay (frame-perfect auto-play), HUD-free recording, game speed, widened judgement, no-fail, unlock-all, and more.

> Note: **Single-player only** (e.g. for recording flawless-clear videos). Please don't use it for online leaderboards. Not affiliated with 7th Beat Games.
>
> Free notice: this tool is **completely free and open-source — reselling is forbidden.** The title bar, the top of the menu, and the load log all carry the project URL as a watermark, and a built-in integrity check **disables the trainer if that watermark / URL is removed or altered.** If you paid for this, you were scammed — get it for free at the address below.

## Features

**Normal**
- **Autoplay** — the engine plays every tile perfectly from the chart; on-screen it looks identical to a real run (**no watermark in the main game**); toggle any time inside a level
- **Hide HUD (clean recording)** — together with Autoplay this is the game's own recording mode (`auto` + `noHud`)
- **Game speed 0.5x–3x** — slow-mo practice / speed-up (pitch included; applied on level start/restart — the engine can't change speed mid-song. The "speed trial" mechanic auto-bumps +0.1 after a win, so re-set for a fixed recording speed)
- **Widen judgement** — a Harmony patch scales the hit-angle window (Counted/Perfect/Pure together) so manual play scores Perfect easily
- **No-Fail** — the game's built-in practice mode; never fail / get interrupted

**Developer**
- **Unlock all levels** (temporary, no save write) + **Go to level select** — together = jump to any level
- **Permanent unlock all** (writes the game's own `unlockAllLevels` setting, reversible, deletes no existing progress)
- **Skip cutscenes**, **show FPS**, **static planet colors** (steadier for recording)
- **Open save folder**

## Install

For the **Steam release** (Unity 6 / x64 / Mono). BepInEx 5 is required first.

### Step 1: install BepInEx 5 (x64, Mono)
1. Download **`BepInEx_win_x64_5.4.23.x.zip`** from [BepInEx Releases](https://github.com/BepInEx/BepInEx/releases).
2. **Extract its contents into the game root** (next to `A Dance of Fire and Ice.exe`; you should then see `winhttp.dll`, `BepInEx/`, etc.).
   > Find the game folder: Steam → right-click *A Dance of Fire and Ice* → Manage → Browse local files.
3. **Launch the game once, then quit**, so BepInEx generates `BepInEx/plugins`, `BepInEx/config`, etc.

### Step 2: install the trainer
- **Option A (manual, recommended):** download [`dist/ADOFAITrainer.dll`](dist/ADOFAITrainer.dll) and drop it into `<game>\BepInEx\plugins\`.
- **Option B (script):** clone this repo → edit the `GAME=` path in [`tools/install.bat`](tools/install.bat) → run it; it copies `dist\ADOFAITrainer.dll` into `BepInEx\plugins`.

### Verify
After launching, open `<game>\BepInEx\LogOutput.log` and look for:
```
[Info : ADOFAI Trainer (冰与火之舞修改器)] ADOFAI Trainer ... v1.3.0 · 免费开源 FREE · github.com/Cohenjikan/ADOFAITrainer · loaded. Menu key = Insert.
```
Enter any level and press **Insert** to open the menu.

## Uninstall

- **Remove only the trainer:** delete `<game>\BepInEx\plugins\ADOFAITrainer.dll` (or run [`tools/uninstall.bat`](tools/uninstall.bat)).
- **Remove BepInEx too / restore vanilla:** delete `winhttp.dll` from the game root (fastest way to disable BepInEx), or delete `winhttp.dll` + the `BepInEx/` folder + `doorstop_config.ini`.
- You can also use Steam's "Verify integrity of game files" to restore everything.

> The config file is at `<game>\BepInEx\config\com.cohen.adofaitrainer.cfg` (you can rebind the menu key); delete it too when uninstalling.

## Usage

1. In any level, press **Insert** to open/close the menu.
2. To record a flawless run: enable **Autoplay** on the *Normal* tab (optionally **Hide HUD**) → enter a level → capture with OBS, etc.
3. To record a locked level: on the *Developer* tab enable **Unlock all levels** → **Go to level select** and enter it.
4. **Speed:** after moving the slider, click **Apply speed & restart level** (the engine can't change speed mid-song).
5. To play by hand again: turn Autoplay off; for easy manual Perfects, enable **Widen judgement**.

## Build from source

Requires the .NET SDK (targets `netstandard2.1`) and a copy of the game with BepInEx installed (for the reference DLLs, including `RDTools.dll`).

```bash
# Defaults to D:\steam\steamapps\common\A Dance of Fire and Ice; override with -p:GameDir=...
dotnet build src/ADOFAITrainer.csproj -c Release -p:GameDir="X:\path\to\A Dance of Fire and Ice"
```
Output: `src/bin/Release/ADOFAITrainer.dll`.

## Compatibility

| Item | Value |
|---|---|
| Game | A Dance of Fire and Ice (Steam release, appid 977950) |
| Engine | Unity 6 (6000.3.x) / x64 / Mono |
| Loader | BepInEx 5.4.23.x |
| Target framework | netstandard2.1 |

> A major game update may require adjustments; if it fails to load, first confirm your BepInEx version matches this guide.

## Credits & Disclaimer

- *A Dance of Fire and Ice* © [7th Beat Games](https://7thbeat.com/) — this project is **not affiliated** with them and contains/distributes none of the game's assets or code.
- Mod frameworks: [BepInEx](https://github.com/BepInEx/BepInEx) / [HarmonyX](https://github.com/BepInEx/HarmonyX).
- The trainer only calls the game's **already-existing** flags and methods (such as the native autoplay flag `RDC.auto`); no memory scanning. It is a single-player toy — **use at your own risk**.

Licensed under [MIT](LICENSE).
