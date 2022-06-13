@echo off
SET "LT=^<"
SET "RT=^>"
REM cls
REM set plugin=default
REM set title=default Plugin
set version=v.0.1.121a
set "gresdir=%~dp0..\..\..\..\resources\"
set "resdir=%~dp0\resources\"
set "getlink=%resdir%cmd\link.bat"
set "sexec=%gresdir%app\sqlite\sqlite3.exe"
set "dbfile=%resdir%lc.db"
set "table=plugins"
set "outFile=%1"
set openjs=%LT% script%RT%
set closejs=%LT%/script%RT%
::global startup
set gstartup=C:\ProgramData\Microsoft\Windows\Start Menu\Programs\StartUp
::current user startup
set startup=%USERPROFILE%\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup
