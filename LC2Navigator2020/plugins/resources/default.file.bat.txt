@echo off
SET "LT=^<"
SET "RT=^>"
cls
call %~dp0config.bat
@echo off
set "outFile=%1"
echo %LT%h1%RT%%title% %version%%LT%/h1%RT%
echo %LT%h2%RT%Installed Modules%LT%/h2%RT%
@echo off
echo %LT%h4%RT% %title% %version% %LT%/h4%RT%
echo %LT%hr%RT%
call %cd%\resources\cmd\loadmenu "%outFile%"
echo %LT%hr%RT%
echo %LT%div id="core_cnt"%RT%
echo %LT%h6%RT%Data sucessfully loaded. %LT%/h6%RT%
echo %LT%/div%RT%
echo %LT%hr%RT%
type %updateshtml%
@echo off
type %cd%\resources\html\clearbutton.html
@echo off
timeout 0 > NUL 
@echo on 