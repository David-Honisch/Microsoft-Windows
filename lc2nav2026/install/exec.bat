@echo off
REM cls
SET "LT=^<"
SET "RT=^>"
SET "LINE=%LT%hr%RT%"
REM echo %LT%div class='container-fluid cm-container-white' %RT%
call %1 %2 %3 %4 %5 %6 %7 %8 %9
@echo off
REM echo %LT%/div%RT%
@echo off
timeout 0 > NUL
@echo on