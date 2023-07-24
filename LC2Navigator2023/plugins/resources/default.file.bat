@echo off
SET "LT=^<"
SET "RT=^>"
cls
call %~dp0config.bat
@echo off
set "outFile=%1"

echo %LT%div class="row" %RT%
REM APP
echo %LT%div class="panel panel-default" %RT%
echo %LT%div class="panel-heading" %RT% APP %LT%/div%RT%
echo %LT%div class="panel-body" %RT%

echo %LT%h4%RT% %title% %version% %LT%/h4%RT%
call %~dp0register.bat
call %cd%\resources\cmd\registerplugin.bat
@echo off

echo %LT%hr%RT%
call %cd%\resources\cmd\loadmenu "%outFile%"
@echo off
REM echo %LT%hr%RT%
REM echo %LT%div id="appcnt"%RT%%LT%/div%RT%
echo %LT%div id="app_cnt"%RT%%LT%/div%RT%
echo %LT%div id="test_cnt"%RT%%LT%/p%RT% %LT%/div%RT%
echo %LT%div id="appcntprogress"%RT%%LT%/div%RT%

echo %LT%div id="mysqlcnt"%RT%
echo %LT%h6%RT%Data sucessfully loaded. %LT%/h6%RT%
echo %LT%/div%RT%

echo %LT%/div%RT%
echo %LT%/div%RT%
REM EOF APP

REM DL
echo %LT%div class="panel panel-default" %RT%
echo %LT%div class="panel-heading" %RT% DOWNLOAD %LT%/div%RT%
echo %LT%div class="panel-body" %RT%

REM echo %LT%p%RT% %version% active %LT%/p%RT%
echo %LT%div id="dlcnt"%RT%%LT%/div%RT%
echo %LT%div id="modcnt"%RT%%LT%/div%RT%

echo %LT%/div%RT%
echo %LT%/div%RT%
REM EOF DL

REM DL
echo %LT%div class="panel panel-default" %RT%
echo %LT%div class="panel-heading" %RT% EXTRACT %LT%/div%RT%
echo %LT%div class="panel-body" %RT%
echo %LT%div id="mvn_cnt"%RT%
echo %LT%/div%RT%
echo %LT%div id="unzipcnt"%RT%
echo %LT%/div%RT%

echo %LT%/div%RT%
echo %LT%/div%RT%
REM EOF DL

REM SQL
echo %LT%div class="panel panel-default" %RT%
echo %LT%div class="panel-heading" %RT% SQL %LT%/div%RT%
echo %LT%div class="panel-body" %RT%

echo %LT%div id="sql_cnt"%RT%
echo %LT%/div%RT%
echo %LT%div id="reg_cnt"%RT%
echo %LT%/div%RT%

echo %LT%/div%RT%
echo %LT%/div%RT%
REM EOF DL

echo %LT%/div%RT%
REM type %updateshtml%
REM @echo off
type %cd%\resources\html\clearbutton.html
@echo off
timeout 0 > NUL 
@echo on 