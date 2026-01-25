@echo off
SET "LT=^<"
SET "RT=^>"
cls
call %~dp0config.bat
@echo off
set "sexec=%cd%\resources\app\sqlite\sqlite3.exe"
set "dbfile=%cd%\resources\lc.db"
set "ptitle=lc2navigator2024.exe"
set "inFile=%1"
set "outFile=%cd%\resources\plugins\%plugin%\menus.csv"
echo %LT%h4%RT% %title% %version% %LT%/h4%RT%
call %~dp0register.bat
@echo off
call %cd%\resources\cmd\registerplugin.bat
@echo off
echo %LT%br%RT%

echo %LT%br%RT%Create Autostart Link:%LT%br%RT%
%~dp0LC2ShortCutCLI.exe "%ptitle%" "%cd%\lc2navigator2024.exe" ".\\"
@echo off
%~dp0LC2ShortCutCLI.exe "%ptitle%" "%cd%\lc2navigator2024.exe" "%startup%" ".\\"
@echo off
echo %LT%br%RT%Create Autostart Link done.%LT%br%RT%

type %cd%\resources\html\clearbutton.html
@echo off
timeout 0 > NUL 
@echo on 