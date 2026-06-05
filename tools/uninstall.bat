@echo off
setlocal
set "GAME=D:\steam\steamapps\common\A Dance of Fire and Ice"

del /q "%GAME%\BepInEx\plugins\ADOFAITrainer.dll" 2>nul
echo Removed ADOFAITrainer.dll.
echo (To fully disable BepInEx as well, delete "%GAME%\winhttp.dll".)
pause
