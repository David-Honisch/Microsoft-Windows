@echo off
SET "LT=^<"
SET "RT=^>"
REM cls
REM set plugin=default
REM set title=default Plugin
set version=v.0.1.121a
set "resdir=%~dp0\resources\"
set "getlink=%resdir%cmd\link.bat"
set "sexec=%resdir%app\sqlite\sqlite3.exe"
set "dbfile=%resdir%lc.db"
set "table=plugins"
set "outFile=%1"
set openjs=%LT% script%RT%
set closejs=%LT%/script%RT%