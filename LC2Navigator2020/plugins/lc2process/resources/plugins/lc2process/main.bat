@echo off
SET "LT=^<"
SET "RT=^>"
cls
call %~dp0config.bat
@echo off
set procs=%temp%~lc2proc.log
REM echo %LT%div class='container-fluid cm-container-white' %RT%
echo %LT%h1%RT%%title% %version%%LT%/h1%RT%
REM echo %LT%h2%RT%Installed Modules%LT%/h2%RT%

REM echo %LT%input
REM echo type="button" value="Install modules" onclick="new HttpRequest().getExtFile('file://'+__dirname+'\\..\\..\\..\\resources\\plugins\\%plugin%\\install.html',400,600);" 
REM echo /%RT%

REM echo %LT%h2%RT%Show Plugin%LT%/h2%RT%

REM echo %LT%input
REM echo type="button" value="Show %title% %version%" onclick="new HttpRequest().getExtFile('file://'+__dirname+'\\..\\..\\..\\resources\\plugins\\%plugin%\\%plugin%.html');" 
REM echo /%RT%
REM type %cd%\resources\plugins\excelimport.html
@echo off
echo %LT%h4%RT% %title% %version% %LT%/h4%RT%
echo %LT%hr%RT%
tasklist > %procs%
echo %procs% created.
echo %LT%ul%RT%
for /f "usebackq tokens=1-3 delims= " %%a in ("%procs%") do (	
	echo %LT%li%RT%
	echo %LT%a
	echo onclick="new HttpRequest().execCMD('taskkill /F /PID %%b', 'core_cnt')" 
	echo %RT%
	echo %%a
	echo %LT%/a%RT% %%b %%c %LT%/br%RT%
	echo %LT%/li%RT%
)
echo %LT%/ul%RT%
echo %LT%hr%RT%
echo %LT%div id="core_cnt"%RT%
echo %LT%h6%RT%Data sucessfully loaded. %LT%/h6%RT%
echo %LT%/div%RT%
echo %LT%hr%RT%

type %updateshtml%
@echo off
type %cd%\resources\html\clearbutton.html
@echo off
REM echo %LT%a
REM echo href="resources/plugins/excelimport/excelimport.bat"
REM echo %RT%
REM echo Reload
REM echo %LT%/a%RT% %LT%/br%RT%
REM type %cd%\resources\html\execbutton.html Refresh
REM echo %LT%/div%RT%
REM echo %LT%div class='container-fluid cm-container-white' %RT%
DONE
REM echo %LT%/div%RT%
timeout 0 > NUL
@echo on