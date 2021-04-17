@echo off
set "target=%1"
echo OUT:%target%
type nul > %target%
@echo off >> %target%
SET "LT=^<" >> %target%
SET "RT=^>" >> %target%
cls >> %target%
call %~dp0config.bat >> %target%
@echo off >> %target%
set "outFile=%1" >> %target%
echo %LT%h1%RT%%title% %version%%LT%/h1%RT% >> %target%
echo %LT%h2%RT%Installed Modules%LT%/h2%RT% >> %target%
@echo off >> %target%
echo %LT%h4%RT% %title% %version% %LT%/h4%RT% >> %target%
echo %LT%hr%RT% >> %target%
call %cd%\resources\cmd\loadmenu "%outFile%" >> %target%
echo %LT%hr%RT% >> %target%
echo %LT%div id="core_cnt"%RT% >> %target%
echo %LT%h6%RT%Data sucessfully loaded. %LT%/h6%RT% >> %target%
echo %LT%/div%RT% >> %target%
echo %LT%hr%RT% >> %target%
type %updateshtml% >> %target%
@echo off >> %target%
type %cd%\resources\html\clearbutton.html >> %target%
@echo off >> %target%
timeout 0 > NUL  >> %target%
@echo on  >> %target%