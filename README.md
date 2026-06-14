<!-- Language switch -->
**简体中文** | [English](README.en.md)

<div align="center">

<img src="docs/assets/hero.png" alt="冰与火之舞修改器 ADOFAI Trainer — 按 F3 呼出的游戏内图形修改器，集成 Autoplay、隐藏 HUD、变速、放宽判定、无敌与解锁全部关卡" width="100%">

<sub> <a href="docs/assets/promo.mp4">观看 30 秒宣传片</a></sub>

# 冰与火之舞修改器 · macOS / Linux 原生版 · ADOFAI Trainer

**按下 F3，得到一次满分通关——这就是游戏自带的 Autoplay，只是被亮了出来。**

《冰与火之舞》(A Dance of Fire and Ice) 游戏内图形修改器的 **macOS 原生分支**（顺带支持 Linux）。集成帧级满分 Autoplay、无 HUD 干净录制、变速、无敌、放宽判定与解锁全部关卡——**只翻动游戏自己已有的开关，不做内存扫描**。

> 本分支是 [Cohenjikan/ADOFAITrainer](https://github.com/Cohenjikan/ADOFAITrainer)（Windows / BepInEx 版）的 **macOS 移植**。
> Unity 的 macOS 播放器用 `dlopen`/`dlsym` 动态加载 Mono，导致 BepInEx / Doorstop 在 macOS 上**无法注入**；
> 本分支因此**不用 BepInEx**，改为用 Mono.Cecil 把加载器**静态织入游戏自身的启动函数 `ADOStartup.Startup`**，原生运行（Apple Silicon arm64 直接可用，**无需 Rosetta**）。菜单热键为 **F3**。

[![license](https://img.shields.io/github/license/MrTangLuyao/ADOFAITrainerMac?color=4ecdc4)](LICENSE)
[![platform](https://img.shields.io/badge/macOS%20%7C%20Linux-原生-000000?logo=apple)](#一键安装--卸载macos--linux)
[![noBepInEx](https://img.shields.io/badge/无需-BepInEx%20%2F%20Rosetta-7048e8)](#原理)
[![game](https://img.shields.io/badge/ADOFAI-Steam%20977950-1b2838?logo=steam)](https://store.steampowered.com/app/977950/)
[![price](https://img.shields.io/badge/%E5%85%8D%E8%B4%B9%E5%BC%80%E6%BA%90-FREE-2ea44f)](https://github.com/MrTangLuyao/ADOFAITrainerMac)

[一键安装](#一键安装--卸载macos--linux) · [功能](#功能) · [使用](#使用) · [取舍与注意](#取舍与注意必读) · [从源码构建](#原理--从源码构建) · [English](README.en.md)

</div>

> [!NOTE]
> **仅供单机自娱与录制使用**（例如制作完美通关视频）。请勿用于排行榜、对战等任何在线场景。本项目与 7th Beat Games **无任何关联**。

> [!IMPORTANT]
> **本工具完全免费、开源，严禁倒卖。** 标题栏、菜单顶部与加载日志均带有本项目地址水印，并内置完整性校验——**删除或篡改该水印 / 项目地址会使修改器直接禁用**（连唯一的 Harmony 补丁也不会加载）。如果你是付费拿到的，说明被人倒卖了，请到 [本仓库](https://github.com/MrTangLuyao/ADOFAITrainerMac) 免费获取。

---

## 一键安装 / 卸载（macOS + Linux）

打开「**终端**」(Terminal)，把下面一行粘贴进去回车即可。脚本会自动：装 .NET SDK（若无）→ 拉取源码 → 编译 → 备份游戏文件 → 织入加载器。**安装前请先退出游戏。**

**安装 / 更新**
```bash
curl -fsSL https://raw.githubusercontent.com/MrTangLuyao/ADOFAITrainerMac/refs/heads/main/install.sh | bash
```

**卸载 / 还原原版**
```bash
curl -fsSL https://raw.githubusercontent.com/MrTangLuyao/ADOFAITrainerMac/refs/heads/main/uninstall.sh | bash
```

装好后**正常用 Steam 启动游戏**，进任意画面按 **F3** 开 / 关菜单。

- **自定义游戏路径**：`curl -fsSL .../install.sh | MANAGED="/path/.../Managed" bash`
- **幂等**：游戏更新或 Steam「验证文件完整性」会还原游戏 DLL、补丁随之失效 —— 重跑安装命令即可（几秒钟）。
- 脚本会自动在常见 Steam 库（含 `libraryfolders.vdf` 登记的自定义库）里查找游戏，macOS 与 Linux 通用。

<details><summary>从源码手动安装 / 卸载</summary>

```bash
git clone https://github.com/MrTangLuyao/ADOFAITrainerMac.git
cd ADOFAITrainerMac
./install.sh      # 安装（自动装 .NET SDK → 编译 → 织入）
./uninstall.sh    # 卸载，还原原版
```
</details>

### 验证是否加载
```bash
# macOS
grep ADOFAITrainerMac "$HOME/Library/Logs/7th Beat Games/A Dance of Fire and Ice/Player.log"
# Linux
grep ADOFAITrainerMac "$HOME/.config/unity3d/7th Beat Games/A Dance of Fire and Ice/Player.log"
# 期望： ... v1.4.0-mac loaded · ... · Menu key = F3 · patches ok=1 fail=0
```
菜单关闭时，非关卡画面（标题 / 选关…）左上角会显示一个小窗「✓ 修改器已加载 · 按 F3 打开 / 关闭」；进入关卡时自动隐藏。

---

## 为什么用它

录制《冰与火之舞》完美通关的最大障碍，是**手速对点**——游戏核心是「踩着节拍点击」，全程零失误几乎不可能靠手打做到。

与其练到手抽筋或写键盘宏，本修改器直接借用引擎**自带的 autoplay**：它按谱面浮点拍点触发，没有输入延迟，天然帧级满分，画面与真人手打完全一致。本 macOS 分支还**额外隐藏了左上角的「Autoplay」字样**（见下），录出来更干净。

它和市面上的「内存修改器」做法根本不同：

| | 普通内存修改器 | 本修改器 |
|---|---|---|
| 实现方式 | 扫描 / 改写内存偏移 | 只翻动游戏**自己已有**的标志（`RDC` / `GCS` / `scrController` / `Persistence`）|
| 游戏更新后 | 偏移一变就失效 | 调用的是游戏自身逻辑，**通常不受影响** |
| 自定义补丁数量 | 多处 hook | **全项目仅一个 Harmony 补丁**（放宽判定），其余全是普通字段赋值 |
| 注入方式 | 外部注入器 / DLL 劫持 | **Mono.Cecil 静态织入**游戏自身启动函数，无 BepInEx |

> 与作者的姊妹项目「[节奏医生修改器 Mac 版](https://github.com/MrTangLuyao/RhythmDoctorTrainerMac)」同源同法、界面一致——两款游戏同为 7th Beat Games 出品，引擎与代码高度同源。

---

## 功能

按 **F3** 呼出浮层菜单，三个分页：**普通** / **开发者** / **关于**。

### 普通玩家

#### Autoplay — 全程满分自动演奏（已隐藏「Autoplay」字样）
引擎按谱面帧级满分自动演奏，画面与真人手打无异。可在关卡内随时开关。
> 原理：仅在关卡内把 `RDC.auto` 设为开关状态——这正是引擎自带 autoplay 的原生标志。
> **本分支额外处理**：开启 Autoplay 时同步置 `RDC.noAutoHud = true`，让游戏自身的 `scrShowIfDebug` 隐藏左上角的「Autoplay」状态文字（这是引擎给该用途预留的标志，只关掉这一处、不动其余 HUD）；关闭即还原。

<img src="docs/assets/feature-1.png" alt="普通页：Autoplay 与隐藏 HUD 开关，下方为说明文字" width="70%">

#### 隐藏 HUD（干净录制）
去掉屏幕上的 HUD，OBS 录出来干干净净；配合 Autoplay 就复刻了游戏自带的「开发者录制模式」。
> 原理：设置 `RDC.noHud`；游戏的 dev 录制模式正是 `RDC.auto = true; RDC.noHud = true`。

#### 游戏变速 0.5×–3×（含音高）
慢放练习或加速。滑块连续可调，并有 `0.75×` / `1×` / `1.5×` / `2×` 快捷按钮。
> 原理：预置 `GCS.speedTrialMode` + `GCS.nextSpeedRun`（在关卡 Start 时读取），点「应用变速并重开本关」调用 `scrController.instance.Restart(true)` 生效。

<img src="docs/assets/feature-2.png" alt="变速分区：变速开关、滑块、0.75x/1x/1.5x/2x 快捷按钮，以及应用变速并重开本关按钮" width="70%">

#### 无敌 No-Fail
即游戏自带的「无判定」练习模式，永不失败、不被打断，关卡内开启立即生效。
> 原理：设置 `GCS.useNoFail`，并把 `scrController.instance.noFail` 一并推到当前关卡。

#### 放宽判定（含完美窗口）
本项目**唯一的 Harmony 补丁**。手打也能轻松全 Perfect——倍数 `1.0–5.0` 可调，连 Perfect/Pure 窗口一起放宽。
> 原理：`JudgeWindowPatch` 后缀 `scrMisc.GetAdjustedAngleBoundaryInDeg`，把返回值乘以 `max(1.0, judgeMult)`。开 Autoplay 时本就满分，此项专为手动练习。

<img src="docs/assets/feature-3.png" alt="便利/玩法分区：无敌 No-Fail 开关与放宽判定倍数滑块" width="70%">

### 开发者

| 功能 | 说明 |
|---|---|
| **解锁全部关卡**（临时，不写存档）+ **前往选关** | 二者配合 = 关卡直达；关闭即恢复，不污染存档（`RDC.forceUnlockAllLevels`）|
| **永久解锁全部关卡** | 写入游戏自身的 `Persistence.unlockAllLevels` 并保存，**可随时取消，不删任何已有进度** |
| **跳过过场动画** / **显示 FPS** / **固定星球颜色** | 录制更稳（`RDC.skipCutscenes` / `GCS.showFPS` / `GCS.staticPlanetColors`）|
| **打开存档目录** | 在 `Persistence.DataPath` 处打开访达 / 文件管理器（`Application.OpenURL`，跨平台）|

> 截图取自菜单（功能一致）；macOS / Linux 分支热键为 **F3**，并对界面做了与「节奏医生修改器 Mac 版」一致的重构。

---

## 使用

1. 正常通过 **Steam** 启动游戏，进任意画面按 **F3** 开 / 关菜单。
2. **录制完美通关**：在「普通」页打开 **Autoplay**（可再开「隐藏 HUD」）→ 进关卡 → 用 OBS 等录屏。左上角「Autoplay」字样已自动隐藏。
3. **录被锁住的关卡**：在「开发者」页开「解锁全部关卡」→「前往选关」直接进入。
4. **变速**：拖动滑块（或点快捷按钮）后，点 **「应用变速并重开本关」** 才生效（引擎不支持中途变速）；点「恢复原速并重开」可还原。
5. **想自己手打**：把 Autoplay 关掉即可；想手打也满分，就开「放宽判定」。

---

## 取舍与注意（必读）

- **变速不保留音高**：引擎用 `song.pitch` 直接缩放，没有时间拉伸，所以快 / 慢的同时音调也会升 / 降。这是已知取舍。
- **变速只在关卡开始 / 重开时生效**：引擎无法中途变速，改完务必点「应用变速并重开本关」。
- **「速度试炼」会自动 +0.1**：游戏机制会在赢一关后把速度自动加 0.1，**录定速前请重新设置**。
- **游戏更新 / Steam 校验会还原补丁**：重跑一次安装命令即可（幂等，几秒钟）。
- **完整性 / 防倒卖校验不是 DRM**：它只是同一 DLL 内的字符串常量比对，能劝退顺手倒卖，但**重新编译即可绕过**，并非真正的防破解。
- **严格单机 / 离线**：请勿用于在线、排行榜或对战；修改游戏可能违反其 EULA，**使用风险自负**。

---

## 原理 / 从源码构建

这游戏是 **Mono** 后端，`Assembly-CSharp.dll` 是可改写的 IL。本方案用 **Mono.Cecil 静态织入**：在游戏自身的启动函数 `ADOStartup.Startup` 开头插入一句 `ADOFAITrainerMac.Loader.Init()`（它是 ADOFAI 的引导例程，对应节奏医生的 `RDStartup.Setup`）。游戏一启动就自动把修改器带起来——零注入器、原生运行。

- 修改器逻辑：`mac/ADOFAITrainerMac/`（由 `src/` 的 Windows 源码移植，去掉 BepInEx 外壳，改为普通 MonoBehaviour）→ `ADOFAITrainerMac.dll`
- 运行时补丁库：`0Harmony.dll`（pardeike Lib.Harmony 2.4.2，自包含；2.4 起原生支持 Apple Silicon arm64）
- 织入器：`mac/Patcher/`（Mono.Cecil；幂等，总是从纯净备份 `*.adofaitrainer-backup` 重打，绝不重复注入）

需要 .NET SDK（`install.sh` 会自动装到 `~/.dotnet`）、以及一份游戏本体（用于引用 `Assembly-CSharp.dll` / `RDTools.dll` 等）。本仓库**不含任何游戏素材**。`./install.sh` 已封装全部构建步骤；技术细节见 [`mac/README.md`](mac/README.md)。

> **Windows 用户**：本分支专为 macOS / Linux。Windows 请用上游 BepInEx 版 [Cohenjikan/ADOFAITrainer](https://github.com/Cohenjikan/ADOFAITrainer)（本仓库 `src/` / `dist/` / `tools/` 即上游 Windows 源码与产物，保留作参考）。

---

## 兼容性

| 项 | 值 |
|---|---|
| 游戏 | A Dance of Fire and Ice（Steam 正式版，appid 977950）|
| 引擎 | Unity 6（6000.3.x）/ Mono / 通用二进制（x64 + arm64）|
| 注入 | Mono.Cecil 静态织入 `ADOStartup.Startup`（**不需** BepInEx / Doorstop / Rosetta）|
| 运行时补丁 | Lib.Harmony 2.4.2 |
| 平台 | macOS（已测）· Linux（顺带支持，见下）|

### Linux（顺带支持，未经真机验证）
织入方案是平台无关的托管代码，Linux 上同样成立；`install.sh` / `uninstall.sh` 已用 `uname` 做了 Linux 分支（`A Dance of Fire and Ice_Data/Managed` 路径、`~/.config/unity3d/...` 日志、Steam 多库查找、自动探测原生可执行名）。但作者无 Linux 真机，**未确认 ADOFAI 是否提供原生 Linux 版**；若你用 **Proton 跑 Windows 版**，目录布局 / 进程名 / 日志路径都不一样，本方案不适用（详见 [`mac/README.md`](mac/README.md)）。

---

## 免责声明

- **非官方**：本项目是粉丝制作的非官方第三方工具，与游戏开发商 [7th Beat Games](https://7thbeat.com/) **无任何关联**，亦未获其授权或认可。《A Dance of Fire and Ice》及其名称、商标、美术与音乐等素材的一切权利归 7th Beat Games 所有。
- **不含游戏内容**：本仓库**仅包含作者自行编写的代码**，不含也不分发游戏的任何源代码、DLL、音频、图像或其它素材；运行时只调用游戏**自身已存在**的公开函数，不做内存扫描。安装时改写的是本机游戏的 `Assembly-CSharp.dll`（已自动备份，可一键还原）。
- **仅限单机**：本工具仅供**离线单机**的自娱、练习与录制。请**勿**用于在线、排行榜、对战或任何会影响其他玩家公平性的场景。
- **遵守 EULA**：修改游戏可能违反其最终用户许可协议（EULA）/ 服务条款。是否使用由你自行决定，并自行承担一切后果（如账号处罚、存档损坏等）。
- **风险自负**：本工具按「现状」提供，不附带任何明示或暗示的担保。
- **完全免费**：本工具免费、开源（[MIT](LICENSE)），**严禁倒卖**；若你是付费获得的，说明被人倒卖了，请到本仓库免费获取。
- **版权方异议**：如相关版权方认为本项目有不当之处，可通过 GitHub Issue 联系，作者将配合下架或调整。

---

## 致谢

- 原作者 / 上游：[Cohenjikan/ADOFAITrainer](https://github.com/Cohenjikan/ADOFAITrainer)（Windows / BepInEx 版）。
- 运行时补丁库 [Lib.Harmony](https://github.com/pardeike/Harmony)；织入库 [Mono.Cecil](https://github.com/jbevain/cecil)。
- 姊妹项目：[节奏医生修改器 · macOS 版](https://github.com/MrTangLuyao/RhythmDoctorTrainerMac)（同源同法）。

本项目以 [MIT](LICENSE) 许可证开源。
