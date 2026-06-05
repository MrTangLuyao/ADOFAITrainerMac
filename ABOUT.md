# About · 关于

## 这是什么 What

**冰与火之舞修改器 (ADOFAI Trainer)** 是一个为单机节奏游戏《A Dance of Fire and Ice》制作的游戏内修改器（trainer）。它以一个 BepInEx 插件的形式运行，在游戏里叠加一个图形菜单（按 `Insert` 呼出），把游戏里原本隐藏的能力暴露成可一键开关的选项。

A small in-game trainer for the single-player rhythm game *A Dance of Fire and Ice*, shipped as a BepInEx plugin that draws an IMGUI overlay (toggled with `Insert`).

## 为什么 Why

最初的目标只是**录制完美通关视频**：游戏核心是「按节拍点击」，手速对点很难做到全程满分。与其练手速或写键盘宏，不如直接借用游戏引擎**自带的 autoplay**——它按谱面的浮点拍点触发，没有输入延迟，天然帧级满分，画面和真人手打完全一致。后来顺手把扫描游戏文件时发现的其它隐藏能力（变速、解锁、放宽判定等）也一并做进了菜单。

It started as a way to record flawless playthroughs without grinding timing skill, by reusing the engine's built-in autoplay instead of a keyboard macro. Other hidden capabilities found while reverse-engineering the game were then folded into the same menu.

## 工作原理 How it works

修改器**不做内存偏移扫描**，而是直接调用游戏自身已存在的开关和函数（通过 BepInEx + HarmonyX）。例如：

- **Autoplay** = 把 `RDC.auto` 设为 `true`——这正是游戏自带「录制模式」（`GCS.d_recording`）所用的同一个原生标志（同时执行 `RDC.auto = true; RDC.noHud = true`），主游戏里**没有 autoplay 水印**。
- **变速** = 设置 `GCS.speedTrialMode` + `GCS.nextSpeedRun`，引擎在关卡开始时据此同时缩放 BPM 与音源音高。
- **永久解锁** = 写入 `Persistence.unlockAllLevels`（游戏自身的设置项），它会驱动 `RDC.forceUnlockAllLevels`。
- **放宽判定** = 唯一的 Harmony 补丁：后缀 `scrMisc.GetAdjustedAngleBoundaryInDeg`，按倍数放大 Counted/Perfect/Pure 三个命中窗口。

因为只是「调用游戏自己的逻辑」，所以比内存修改稳定得多，游戏小更新通常也不易失效。本工具与「节奏医生修改器」同源同法——两款游戏同为 7th Beat Games 出品、引擎与代码高度同源。

The trainer pokes the game's own native flags/methods via BepInEx + HarmonyX (no memory-offset/AOB scanning), which is far more stable across game updates than a traditional external trainer. It shares its whole approach with the sibling *Rhythm Doctor Trainer* — both games are by 7th Beat Games and share a code base.

## 作者 Author

Cohenjikan · 以 MIT 许可证开源。与 7th Beat Games 无关联。
