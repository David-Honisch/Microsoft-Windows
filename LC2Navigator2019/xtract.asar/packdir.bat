@echo off
REM call npm install asar
REM asar pack dist app.asar --unpack-dir "{x1,x2}"
call asar pack dist app.min.asar
copy app.min.asar ..\install\app.asar
REM asar e app.asar _dist