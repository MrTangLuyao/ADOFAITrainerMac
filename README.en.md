<!-- Language switch -->
[简体中文](README.md) | **English**

<div align="center">

<img src="docs/assets/hero.png" alt="ADOFAI Trainer — an in-game GUI trainer for A Dance of Fire and Ice with autoplay, hide-HUD, speed, widened judgement, no-fail and unlock-all, opened with F3" width="100%">

<sub> <a href="docs/assets/promo.mp4">Watch the 30-second promo</a></sub>

# ADOFAI Trainer · macOS / Linux native · 冰与火之舞 修改器

**Press F3. Get a flawless run. It's the game's own autoplay, just exposed.**

The **macOS-native fork** (with Linux support) of the in-game GUI trainer for *A Dance of Fire and Ice*. Frame-perfect autoplay, HUD-free recording, speed control, no-fail, widened judgement, and level unlock — **by toggling the game's own switches, with no memory hacking**.

> This fork is the **macOS port** of [Cohenjikan/ADOFAITrainer](https://github.com/Cohenjikan/ADOFAITrainer) (the Windows / BepInEx build).
> Unity's macOS player loads Mono via `dlopen`/`dlsym`, so BepInEx / Doorstop **cannot inject** on macOS.
> Instead, this fork uses **no BepInEx**: it statically weaves the loader into the game's own startup method **`ADOStartup.Startup`** with Mono.Cecil, running natively (Apple Silicon arm64, **no Rosetta**). Menu hotkey is **F3**.

[![license](https://img.shields.io/github/license/MrTangLuyao/ADOFAITrainerMac?color=4ecdc4)](LICENSE)
[![platform](https://img.shields.io/badge/macOS%20%7C%20Linux-native-000000?logo=apple)](#one-line-install--uninstall-macos--linux)
[![noBepInEx](https://img.shields.io/badge/no-BepInEx%20%2F%20Rosetta-7048e8)](#how-it-works--build-from-source)
[![game](https://img.shields.io/badge/ADOFAI-Steam%20977950-1b2838?logo=steam)](https://store.steampowered.com/app/977950/)
[![price](https://img.shields.io/badge/free%20%26%20open%20source-FREE-2ea44f)](https://github.com/MrTangLuyao/ADOFAITrainerMac)

[Install](#one-line-install--uninstall-macos--linux) · [Features](#features) · [Usage](#usage) · [Trade-offs](#trade-offs--gotchas-read-this) · [Build](#how-it-works--build-from-source) · [简体中文](README.md)

</div>

> [!NOTE]
> **Single-player only** (e.g. for recording flawless-clear videos). Please don't use it for online leaderboards or competitive play. Not affiliated with 7th Beat Games.

> [!IMPORTANT]
> **This tool is completely free and open-source — reselling is forbidden.** The title bar, the top of the menu, and the load log all carry the project URL as a watermark, and a built-in integrity check **disables the trainer if that watermark / URL is removed or altered** (even the one Harmony patch is skipped). If you paid for this, you were scammed — get it for free at [this repository](https://github.com/MrTangLuyao/ADOFAITrainerMac).

---

## One-line install / uninstall (macOS + Linux)

Open **Terminal** and paste one line. The script auto-installs the .NET SDK (if missing) → fetches the source → builds → backs up the game file → weaves the loader. **Quit the game before installing.**

**Install / update**
```bash
curl -fsSL https://raw.githubusercontent.com/MrTangLuyao/ADOFAITrainerMac/refs/heads/main/install.sh | bash
```

**Uninstall / restore the original**
```bash
curl -fsSL https://raw.githubusercontent.com/MrTangLuyao/ADOFAITrainerMac/refs/heads/main/uninstall.sh | bash
```

Then **launch the game normally via Steam** and press **F3** anywhere to toggle the menu.

- **Custom game path**: `curl -fsSL .../install.sh | MANAGED="/path/.../Managed" bash`
- **Idempotent**: a game update or Steam "Verify integrity of game files" restores the game DLL and disables the patch — just re-run the install command (takes seconds).
- The script auto-discovers the game across common Steam libraries (including custom ones in `libraryfolders.vdf`), on both macOS and Linux.

<details><summary>Manual install / uninstall from source</summary>

```bash
git clone https://github.com/MrTangLuyao/ADOFAITrainerMac.git
cd ADOFAITrainerMac
./install.sh      # install (auto .NET SDK → build → weave)
./uninstall.sh    # uninstall, restore original
```
</details>

### Verify it loaded
```bash
# macOS
grep ADOFAITrainerMac "$HOME/Library/Logs/7th Beat Games/A Dance of Fire and Ice/Player.log"
# Linux
grep ADOFAITrainerMac "$HOME/.config/unity3d/7th Beat Games/A Dance of Fire and Ice/Player.log"
# expect: ... v1.4.0-mac loaded · ... · Menu key = F3 · patches ok=1 fail=0
```
While the menu is closed, non-level screens (title / level-select…) show a small top-left window: "✓ trainer loaded · press F3 to toggle"; it hides inside a level.

---

## Why this exists

The hardest part of recording a flawless *A Dance of Fire and Ice* run is **timing** — the game is "tap on the beat," and a zero-mistake full clear is nearly impossible by hand.

Rather than grinding or scripting a macro, this trainer reuses the engine's **built-in autoplay**: it fires on the chart's float beat times with no input lag, so it's frame-perfect and looks identical to a human run. This macOS fork additionally **hides the top-left "Autoplay" label** (see below) for cleaner recordings.

It's fundamentally different from a typical memory trainer:

| | Typical memory trainer | This trainer |
|---|---|---|
| Mechanism | Scans / rewrites memory offsets | Only toggles the game's **own** flags (`RDC` / `GCS` / `scrController` / `Persistence`) |
| After a game update | Breaks when offsets move | Calls the game's own logic — **usually unaffected** |
| Custom patches | Many hooks | **Exactly one Harmony patch** (widen judgement); everything else is a plain field set |
| Injection | External injector / DLL hijack | **Mono.Cecil static weave** into the game's own startup method, no BepInEx |

> Same approach and matching UI as the sister project, the [Rhythm Doctor Trainer for macOS](https://github.com/MrTangLuyao/RhythmDoctorTrainerMac) — both games are by 7th Beat Games and share a highly common engine/codebase.

---

## Features

Press **F3** for the overlay; three tabs: **Normal** / **Developer** / **About**.

### Normal

#### Autoplay — frame-perfect auto-play (the "Autoplay" label is hidden)
The engine auto-plays each tile perfectly; visually identical to a human run. Toggle any time inside a level.
> How: sets `RDC.auto` only while in a level — the engine's own autoplay flag.
> **Fork addition**: while Autoplay is on it also sets `RDC.noAutoHud = true`, so the game's own `scrShowIfDebug` hides the top-left "Autoplay" status text (the engine's purpose-built flag for exactly this — it touches only that label, not the rest of the HUD). Restored when off.

<img src="docs/assets/feature-1.png" alt="Normal tab: Autoplay and Hide-HUD toggles with descriptions" width="70%">

#### Hide HUD (clean recording)
Removes the on-screen HUD for clean OBS captures; together with Autoplay this reproduces the game's own "dev recording mode."
> How: sets `RDC.noHud`; the dev recording mode is exactly `RDC.auto = true; RDC.noHud = true`.

#### Speed 0.5×–3× (pitch included)
Slow-practice or speed up. Continuous slider plus `0.75×` / `1×` / `1.5×` / `2×` presets.
> How: arms `GCS.speedTrialMode` + `GCS.nextSpeedRun` (read at level Start); "Apply speed & restart" calls `scrController.instance.Restart(true)`.

<img src="docs/assets/feature-2.png" alt="Speed section: toggle, slider, 0.75x/1x/1.5x/2x presets, apply-and-restart button" width="70%">

#### No-Fail
The game's built-in "no judgement" practice mode — never fail or get interrupted; takes effect immediately in a level.
> How: sets `GCS.useNoFail` and also pushes `scrController.instance.noFail` onto the current level.

#### Widen judgement (perfect window included)
The project's **only Harmony patch**. Hit Perfect easily by hand — multiplier `1.0–5.0`, widening Counted / Perfect / Pure together.
> How: `JudgeWindowPatch` postfixes `scrMisc.GetAdjustedAngleBoundaryInDeg`, multiplying the result by `max(1.0, judgeMult)`. With Autoplay on you're already perfect; this is for manual practice.

<img src="docs/assets/feature-3.png" alt="Convenience/gameplay section: No-Fail toggle and widen-judgement multiplier slider" width="70%">

### Developer

| Feature | Notes |
|---|---|
| **Unlock all levels** (temporary, not saved) + **Go to level select** | Together = level jump; turn off to revert, no save pollution (`RDC.forceUnlockAllLevels`) |
| **Permanently unlock all** | Writes the game's own `Persistence.unlockAllLevels` and saves; **reversible, deletes no existing progress** |
| **Skip cutscenes** / **Show FPS** / **Static planet colors** | Steadier recording (`RDC.skipCutscenes` / `GCS.showFPS` / `GCS.staticPlanetColors`) |
| **Open save folder** | Opens `Persistence.DataPath` in Finder / your file manager (`Application.OpenURL`, cross-platform) |

> Screenshots are of the menu (features identical); the macOS / Linux fork uses **F3** and a UI refactored to match the Rhythm Doctor macOS trainer.

---

## Usage

1. Launch via **Steam** normally and press **F3** anywhere to toggle the menu.
2. **Record a flawless run**: enable **Autoplay** (and optionally "Hide HUD") on the Normal tab → enter a level → record with OBS. The top-left "Autoplay" label is already hidden.
3. **Record a locked level**: on the Developer tab enable "Unlock all levels" → "Go to level select" and enter it directly.
4. **Speed**: drag the slider (or use presets), then click **"Apply speed & restart"** to take effect (the engine can't change speed mid-song); "Reset speed & restart" reverts.
5. **Play by hand**: just turn Autoplay off; want Perfect by hand, enable "Widen judgement."

---

## Trade-offs & gotchas (read this)

- **Speed doesn't preserve pitch**: the engine scales `song.pitch` directly (no time-stretch), so faster/slower also raises/lowers pitch. Known trade-off.
- **Speed only applies at level start / restart**: the engine can't change speed mid-song; always click "Apply speed & restart."
- **"Speed trial" auto-adds +0.1**: winning a level bumps speed by 0.1, so **re-set it before recording a fixed speed**.
- **Game updates / Steam verify revert the patch**: just re-run the install command (idempotent, seconds).
- **The integrity / anti-resale check is not DRM**: it's a string-constant comparison in the same DLL — it deters casual reselling but **is bypassable by recompiling**.
- **Strictly single-player / offline**: don't use online, on leaderboards, or in competitive play; modifying the game may violate its EULA — **use at your own risk**.

---

## How it works / build from source

The game is **Mono**-backed, so `Assembly-CSharp.dll` is rewritable IL. This fork uses a **Mono.Cecil static weave**: it inserts one `ADOFAITrainerMac.Loader.Init()` call at the start of the game's own `ADOStartup.Startup` (ADOFAI's boot routine, the analog of Rhythm Doctor's `RDStartup.Setup`). The trainer comes up automatically at boot — no injector, fully native.

- Trainer logic: `mac/ADOFAITrainerMac/` (ported from the Windows `src/`, BepInEx shell stripped, now a plain MonoBehaviour) → `ADOFAITrainerMac.dll`
- Runtime patch lib: `0Harmony.dll` (pardeike Lib.Harmony 2.4.2, self-contained; native Apple Silicon arm64 since 2.4)
- Weaver: `mac/Patcher/` (Mono.Cecil; idempotent — always re-derives from a pristine `*.adofaitrainer-backup`, never double-injects)

Requires the .NET SDK (`install.sh` auto-installs to `~/.dotnet`) and a copy of the game (to reference `Assembly-CSharp.dll` / `RDTools.dll` etc.). This repo ships **no game assets**. `./install.sh` wraps the whole build; details in [`mac/README.md`](mac/README.md).

> **Windows users**: this fork is macOS / Linux only. On Windows use the upstream BepInEx build [Cohenjikan/ADOFAITrainer](https://github.com/Cohenjikan/ADOFAITrainer) (this repo's `src/` / `dist/` / `tools/` are the upstream Windows source & artifacts, kept for reference).

---

## Compatibility

| Item | Value |
|---|---|
| Game | A Dance of Fire and Ice (Steam, appid 977950) |
| Engine | Unity 6 (6000.3.x) / Mono / universal binary (x64 + arm64) |
| Injection | Mono.Cecil static weave into `ADOStartup.Startup` (**no** BepInEx / Doorstop / Rosetta) |
| Runtime patch | Lib.Harmony 2.4.2 |
| Platforms | macOS (tested) · Linux (best-effort, see below) |

### Linux (best-effort, not verified on real hardware)
The weave is platform-independent managed code, so it holds on Linux too; `install.sh` / `uninstall.sh` have a `uname` branch for Linux (`A Dance of Fire and Ice_Data/Managed` path, `~/.config/unity3d/...` log, multi-library Steam search, auto-detected native executable name). But the author has no Linux machine and **hasn't confirmed whether ADOFAI ships a native Linux build**; if you run the Windows build via **Proton**, the layout / process name / log path differ and this won't apply (see [`mac/README.md`](mac/README.md)).

---

## Disclaimer

- **Unofficial**: a fan-made, unofficial third-party tool, **not affiliated with** or endorsed by the developer [7th Beat Games](https://7thbeat.com/). *A Dance of Fire and Ice* and its name, trademarks, art and music belong to 7th Beat Games.
- **No game content**: this repo contains **only the author's own code**; it neither contains nor distributes any of the game's source, DLLs, audio, images or other assets. At runtime it only calls the game's **existing** public functions, with no memory scanning. Installing rewrites your local `Assembly-CSharp.dll` (auto-backed-up, one-click restorable).
- **Single-player only**: for offline single-player fun, practice and recording. Do **not** use online, on leaderboards, in competitive play, or anywhere it affects others' fairness.
- **Obey the EULA**: modifying the game may violate its EULA / ToS. Whether to use it is your call and your risk (account penalties, save corruption, etc.).
- **As-is**: provided "as is" with no warranty.
- **Free**: free and open source ([MIT](LICENSE)); **reselling is forbidden**. If you paid for it, you were scammed — get it free at this repo.
- **Rights-holder concerns**: if a rights holder objects, open a GitHub Issue and the author will cooperate to take it down or adjust.

---

## Credits

- Original author / upstream: [Cohenjikan/ADOFAITrainer](https://github.com/Cohenjikan/ADOFAITrainer) (Windows / BepInEx build).
- Runtime patch lib [Lib.Harmony](https://github.com/pardeike/Harmony); weaving lib [Mono.Cecil](https://github.com/jbevain/cecil).
- Sister project: [Rhythm Doctor Trainer · macOS](https://github.com/MrTangLuyao/RhythmDoctorTrainerMac) (same approach).

Licensed under [MIT](LICENSE).
