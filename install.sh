#!/bin/bash
# 本仓库（mac fork）已并入上游 Cohenjikan/ADOFAITrainer，由上游统一维护 macOS / Windows。
# 旧的一键安装命令仍然有效：本脚本自动转跳到上游官方安装脚本，把你安装 / 升级到最新版。
echo "==> 冰与火之舞修改器已并入上游仓库 Cohenjikan/ADOFAITrainer，正在转用官方一键安装（最新版）…"
curl -fsSL https://raw.githubusercontent.com/Cohenjikan/ADOFAITrainer/refs/heads/main/install.sh | bash
