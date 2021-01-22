@echo off
setLocal EnableDelayedExpansion
REM call %~dp0config.bat
call %cd%\resources\plugins\lcwebclient_final\config.bat
@echo off
echo %LT%div class='container-fluid cm-container-white' %RT%
echo %LT%h1%RT%%title% %version%%LT%/h1%RT%
REM echo type %cd%\resources\plugins\%plugin%\%plugin%.html
type %cd%\resources\plugins\%plugin%\%plugin%.html
@echo off
echo %LT%h4%RT% %title% %version% %LT%/h4%RT%

REM echo %LT%h4%RT% MENU: %importFile% %LT%/h4%RT%

echo %LT%hr%RT%
for /f "usebackq tokens=1-3 delims=;" %%a in ("%importFile%") do (	
	echo %LT%a
	echo onclick="new HttpRequest().execCMD('exec.bat .\\resources\\plugins\\%plugin%\\%%~na%%~xa %2 %%b', 'core_cnt')" 
	echo %RT%
	echo %%b
	echo %LT%/a%RT%-%%c%LT%/br%RT%
)
echo %LT%hr%RT%
echo %LT%div id="core_cnt"%RT%
echo %LT%h6%RT%Data sucessfully loaded. %LT%/h6%RT%
REM @echo on
REM @echo off
REM cls
REM set host=https://www.letztechance.org
REM setLocal EnableDelayedExpansion
REM set CURRENT_DIR=%cd%
REM echo %cd%\lib
set "CLASSPATH=."
 for /R %cd%\ %%a in (*.jar) do (
   set "CLASSPATH=!CLASSPATH!;%%a"
 )
REM echo !CLASSPATH!
REM echo CALLING...
REM echo %LT%textarea%RT%
REM call java -jar %jarfile% -url "%host%%indexapi%" -user %user% -password %pwd% - port:443
REM %LT%/textarea%RT%
REM @echo off
REM timeout 10
REM @echo on
echo %LT%/div%RT%
echo %LT%hr%RT%
REM type %updateshtml%
REM @echo off
type %cd%\resources\html\clearbutton.html
@echo off
echo %LT%a
echo href="resources/plugins/%plugin%/lcwebclient_final.bat"
echo %RT%
echo Reload
echo %LT%/a%RT% %LT%/br%RT%
REM type %cd%\resources\html\execbutton.html Refresh
echo %LT%/div%RT%
echo %LT%div class='container-fluid cm-container-white' %RT%
DONE
echo %LT%/div%RT%
REM echo %LT%script src="%cd%/resources/plugins/assets/js/atari/atari.rawinflate.js" %LT%script%RT%
timeout 0 > NUL