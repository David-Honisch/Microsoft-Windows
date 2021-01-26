@echo off
SET "LT=^<"
SET "RT=^>"
REM cls
set plugin=lc2process
set title=LC2process Plugin
set version=v.0.1.121a
set "resdir=%~dp0\resources\"
REM set "getlink=%resdir%cmd\getllink.bat"
set "getlink=%resdir%cmd\link.bat"
set "sexec=%resdir%app\sqlite\sqlite3.exe"
set "dbfile=%resdir%lc.db"
set "table=plugins"
set "outFile=%1"
set openjs=%LT% script%RT%
set closejs=%LT%/script%RT%
timeout 0 > NUL
@echo on