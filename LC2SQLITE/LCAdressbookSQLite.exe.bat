@echo off
cls
set "tableName=tools"
set "csv=tools.csv"
set "dbfile=lc.db"
set "PRG=.\LC2SQLiteGUI.exe"
set "sexec=.\SQLite3.exe"
set "importsql=.\\LC2SQLiteGUI.sql"
set "tempimportsql=.\LC2SQLiteGUI.util.sql"
rem set "dropsql=.\\bin\\droptables.sql"
SET "QUERY=select rowid, name from %temptable% limit 1000000;"
set hr=%time:~0,2%
REM .\LC2Logo.exe
REM echo %time%
REM timeout 1 > NUL
echo Reading all files
dir /s /b *.bat > %csv%
dir /s /b *.exe >> %csv%
REM call .\bin\createcsv.bat
echo -------------------------------------------
call %sexec% %dbfile% ".read %importsql%"
echo -------------------------------------------
call import %csv% %tableName%
@echo off
echo -------------------------------------------
set "tableName=people"
set "csv=batch.csv"
echo -------------------------------------------
call import %csv% %tableName%
@echo off
echo -------------------------------------------
echo All adresses imported
echo -------------------------------------------
echo done
REM for /R ./import %%a in (*.csv) do (
start %PRG%
rem pause
@echo on