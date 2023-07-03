@echo off
SET "LT=^<"
SET "RT=^>"
cls
set "resdir=%cd%\resources\"
set "getlink=%resdir%cmd\link.bat"
set "sexec=%resdir%app\sqlite\sqlite3.exe"
set "dbfile=%cd%\release-builds\resources\lc.db"
set "table=plugins"
set "outFile=%resdir%plugins\core\%1"
set openjs=%LT% script%RT%
set closejs=%LT%/script%RT%
set version=v.0.1.123b
echo %LT%h1%RT%%3 Plugin %version% %LT%/h1%RT%
type %cd%\resources\plugins\core.html
echo %LT%hr%RT%
echo %LT%h4%RT% %3 %LT%/h4%RT%
echo %LT%hr%RT%
for /f "usebackq tokens=1 delims=;" %%a in ("%outFile%") do (
	echo %LT%a
	echo onclick="new HttpRequest().execCMD('exec.bat %%~na%%~xa', 'core_cnt')" 
	echo %RT%
	echo %%~na%%~xa
	echo %LT%/a%RT% %LT%/br%RT%
)
echo %LT%hr%RT%
echo %LT%div id="core_cnt"%RT%
echo %LT%h6%RT%Data sucessfully loaded. %LT%/h6%RT%
echo %LT%/div%RT%
echo %LT%hr%RT%

type %updateshtml%
@echo off
type %cd%\resources\html\clearbutton.html
@echo off
echo %LT%a
echo href="resources/plugins/core.show.bat"
echo %RT%
echo Reload
echo %LT%/a%RT% %LT%/br%RT%
REM type %cd%\resources\html\execbutton.html Refresh
echo %LT%/div%RT%
echo %LT%div class='container-fluid cm-container-white' %RT%
DONE

timeout 0 > NUL
@echo on