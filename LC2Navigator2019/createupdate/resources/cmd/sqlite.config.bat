@echo off
Set "mime=xml"
Set "exportdir=export\"
Set "importdir=plugins\"
Set "PRG=%cd%\resources\app\sqlite\sqlite3.exe"
REM call %cd%\resources\cmd\sqlite.config.bat
Set "db=lc"
Set "dbfile=lc.db"
set "table=datalob"
set hr=%time:~0,2%
@echo on