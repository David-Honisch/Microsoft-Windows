@echo off
SET "LT=^<"
SET "RT=^>"
call %~dp0config.bat
@echo off
set "outFile=%1"
echo %LT%div class="plugincnt" %RT%
echo %LT%pre%RT%
echo %LT%code%RT%
echo call %~dp0LC2ShortCutCLI.exe
call %~dp0LC2ShortCutCLI.exe
@echo off
echo %LT%/code%RT%
echo %LT%/pre%RT%
echo %LT%/div%RT%