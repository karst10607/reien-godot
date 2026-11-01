@echo off
setlocal
cd /d "%~dp0"

set "GODOT=.tools\Godot_v4.7.2-stable_win64.exe"
if not exist "%GODOT%" set "GODOT=%USERPROFILE%\Desktop\Godot_v4.7.2-stable_win64.exe"
if not exist "%GODOT%" set "GODOT=godot"

echo =======================================================
echo  土城長風新城 1:1 GIS 數位孿生與動態日照模擬 (Godot 4)
echo =======================================================
echo 正在啟動 Godot 引擎...
start "Tucheng Godot" "%GODOT%" --path "%CD%"
