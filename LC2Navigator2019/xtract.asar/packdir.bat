@echo off
REM call npm install asar
REM asar pack dist app.asar --unpack-dir "{x1,x2}"
asar pack dist app.min.asar
REM asar e app.asar _dist