<!-- Language switch -->
**简体中文** | [English](README.en.md)

# 冰与火之舞 修改器 · ADOFAI Trainer

一个《冰与火之舞》(A Dance of Fire and Ice) 的**游戏内图形修改器**，基于 BepInEx。按 **Insert** 呼出菜单，集成 Autoplay（全程满分自动演奏）、隐藏 HUD 录制、游戏变速、放宽判定、无敌、解锁全部关卡等。

> 注意：**仅供单机自娱与录制使用**（例如制作完美通关视频）。请勿用于排行榜等在线场景。与 7th Beat Games 无任何关联。
>
> 免费声明：本工具**完全免费开源，严禁倒卖**。标题栏、菜单顶部与加载日志均带有本项目地址水印，并内置完整性校验——**删除或篡改该水印 / 项目地址会使修改器直接禁用**。如果你是付费拿到的，说明被人倒卖了，请到下方地址免费获取。

## 功能

**普通 / Normal**
- **Autoplay** —— 引擎按谱面帧级满分自动演奏，画面与真人手打无异，**主游戏无水印**；可在关卡内随时开关
- **隐藏 HUD（干净录制）** —— 配合 Autoplay 即为游戏自带的录制模式（`auto` + `noHud`）
- **游戏变速 0.5×–3×** —— 慢放练习 / 加速（含音高；在关卡开始/重开时生效，引擎不支持中途变速。游戏「速度试炼」机制会在赢一关后自动 +0.1，录定速请重设）
- **放宽判定** —— Harmony 放大命中角度窗口（Counted/Perfect/Pure 一起），手打也能轻松全 Perfect
- **无敌 No-Fail** —— 游戏自带的「无判定」练习模式，不会失败 / 被打断

**开发者 / Developer**
- **解锁全部关卡**（临时，不写存档）+ **前往选关** —— 二者配合 = 关卡直达
- **永久解锁全部关卡**（写入游戏自身的 `unlockAllLevels` 设置，可随时取消，不删任何已有进度）
- **跳过过场动画**、**显示 FPS**、**固定星球颜色**（录制更稳）
- **打开存档目录**

## 安装

适用于 **Steam 正式版**（Unity 6 / x64 / Mono）。需要先安装 BepInEx 5。

### 第一步：装 BepInEx 5（x64, Mono）
1. 到 [BepInEx Releases](https://github.com/BepInEx/BepInEx/releases) 下载 **`BepInEx_win_x64_5.4.23.x.zip`**。
2. 把压缩包内容**解压到游戏根目录**（即与 `A Dance of Fire and Ice.exe` 同一层；解压后该目录会多出 `winhttp.dll`、`BepInEx/` 等）。
   > 游戏目录怎么找：Steam → 右键《A Dance of Fire and Ice》→ 管理 → 浏览本地文件。
3. **启动一次游戏再退出**，让 BepInEx 生成 `BepInEx/plugins`、`BepInEx/config` 等文件夹。

### 第二步：装本修改器
- **方法 A（手动，推荐）**：下载 [`dist/ADOFAITrainer.dll`](dist/ADOFAITrainer.dll)，放进 `游戏目录\BepInEx\plugins\`。
- **方法 B（脚本）**：下载本仓库 → 编辑 [`tools/install.bat`](tools/install.bat) 里的 `GAME=` 路径 → 双击运行，它会把 `dist\ADOFAITrainer.dll` 拷到 `BepInEx\plugins`。

### 验证
启动游戏后，打开 `游戏目录\BepInEx\LogOutput.log`，看到这行即成功：
```
[Info : ADOFAI Trainer (冰与火之舞修改器)] ADOFAI Trainer ... v1.3.0 · 免费开源 FREE · github.com/Cohenjikan/ADOFAITrainer · loaded. Menu key = Insert.
```
进入任意关卡，按 **Insert** 即可呼出菜单。

## 卸载

- **只移除修改器**：删除 `游戏目录\BepInEx\plugins\ADOFAITrainer.dll`（或运行 [`tools/uninstall.bat`](tools/uninstall.bat)）。
- **连 BepInEx 一起移除 / 恢复原版**：删除游戏根目录的 `winhttp.dll`（最快的"禁用 BepInEx"方式），或删除 `winhttp.dll` + `BepInEx/` 文件夹 + `doorstop_config.ini`。
- 也可以在 Steam 里「验证游戏文件完整性」一键还原。

> 配置文件在 `游戏目录\BepInEx\config\com.cohen.adofaitrainer.cfg`（可改菜单热键），卸载后可一并删除。

## 使用

1. 进入任意关卡，按 **Insert** 开/关菜单。
2. 录制完美通关：在「普通」页打开 **Autoplay**（可再开「隐藏 HUD」）→ 进关卡 → 用 OBS 等录屏。
3. 想录被锁住的关卡：在「开发者」页开「解锁全部关卡」→「前往选关」直接进入。
4. **变速**：拖动滑块后点「应用变速并重开本关」生效（引擎不支持中途变速）。
5. 想自己手打：把 Autoplay 关掉即可；想手打也满分就开「放宽判定」。

## 从源码构建

需要 .NET SDK（构建 `netstandard2.1`）、已安装 BepInEx 的游戏副本（用于引用 DLL，包含 `RDTools.dll`）。

```bash
# 默认读取 D:\steam\steamapps\common\A Dance of Fire and Ice；其它路径用 -p:GameDir=... 覆盖
dotnet build src/ADOFAITrainer.csproj -c Release -p:GameDir="你的\A Dance of Fire and Ice"
```
产物在 `src/bin/Release/ADOFAITrainer.dll`。

## 兼容性

| 项 | 值 |
|---|---|
| 游戏 | A Dance of Fire and Ice（Steam 正式版，appid 977950） |
| 引擎 | Unity 6（6000.3.x）/ x64 / Mono |
| 加载器 | BepInEx 5.4.23.x |
| 目标框架 | netstandard2.1 |

> 游戏大版本更新后可能需要适配；若加载失败，先确认 BepInEx 版本与本说明一致。

## 免责声明

- **非官方**：本项目是粉丝制作的非官方第三方工具，与游戏开发商 [7th Beat Games](https://7thbeat.com/) **无任何关联**，亦未获其授权或认可。《A Dance of Fire and Ice》及其名称、商标、美术与音乐等素材的一切权利归 7th Beat Games 所有。
- **不含游戏内容**：本仓库**仅包含作者自行编写的插件代码**，不含也不分发游戏的任何源代码、DLL、音频、图像或其它素材；运行时只通过 BepInEx / HarmonyX 调用游戏**自身已存在**的公开函数，不做内存扫描。
- **仅限单机**：本工具仅供**离线单机**的自娱、练习与录制。请**勿**用于在线、排行榜、对战或任何会影响其他玩家公平性的场景。
- **遵守 EULA**：修改游戏可能违反其最终用户许可协议（EULA）/ 服务条款。是否使用由你自行决定，并须自行遵守相关条款；由此产生的一切后果（如账号处罚、存档损坏等）均由使用者自行承担。
- **风险自负**：本工具按「现状」提供，不附带任何明示或暗示的担保；作者不对使用本工具造成的任何直接或间接损失负责。
- **完全免费**：本工具免费、开源（[MIT](LICENSE)），**严禁倒卖**；若你是付费获得的，说明被人倒卖了，请到本仓库免费获取。
- **版权方异议**：如相关版权方认为本项目有不当之处，可通过 GitHub Issue 联系，作者将配合下架或调整。

## 致谢

- 模组框架 [BepInEx](https://github.com/BepInEx/BepInEx) / [HarmonyX](https://github.com/BepInEx/HarmonyX)。
- 与姊妹项目「节奏医生修改器」同源同法（同为 7th Beat Games 出品）。

本项目代码以 [MIT](LICENSE) 许可证开源。
