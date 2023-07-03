@echo off
SET "LT=^<"
SET "RT=^>"
cls
set "resdir=%cd%\resources\"
REM set "getlink=%resdir%cmd\getllink.bat"
set "getlink=%resdir%cmd\link.bat"
set "sexec=%resdir%app\sqlite\sqlite3.exe"
set "dbfile=%cd%\release-builds\resources\lc.db"
set "table=plugins"
set "outFile=%1"
set openjs=%LT% script%RT%
set closejs=%LT%/script%RT%
set title=Core Plugin
set version=v.0.1.12a
REM echo %LT%div class='container-fluid cm-container-white' %RT%
REM echo %LT%h1%RT%%title% %version%%LT%/h1%RT%
REM type %cd%\resources\plugins\core\html\core.html
@echo off
REM echo %LT%h4%RT% %title% %version% %LT%/h4%RT%
REM echo %LT%hr%RT%
REM echo call %cd%\resources\cmd\loadmenusimple "%outFile%"
call %cd%\resources\cmd\loadmenusimple "%outFile%"
@echo off
REM echo %LT%hr%RT%
echo %LT%div id="core_cnt"%RT%
echo %LT%h6%RT%Data sucessfully loaded. %LT%/h6%RT%
echo %LT%/div%RT%
echo %LT%hr%RT%

type %updateshtml%
@echo off
type %cd%\resources\html\clearbutton.html
@echo off
echo %LT%a
echo href="resources/plugins/core/core.show.bat"
echo %RT%
echo Reload
echo %LT%/a%RT% %LT%/br%RT%
REM type %cd%\resources\html\execbutton.html Refresh
echo %LT%/div%RT%
echo %LT%div class='container-fluid cm-container-white' %RT%
DONE
REM echo %LT%/div%RT%
@REM echo %LT%script src="%cd%/resources/plugins/assets/js/atari/atari.memory.js" %LT%script%RT%
timeout 0 > NUL
@echo on