@echo off
cls
set "tableName=people"
set "dbfile=lc.db"
set "PRG=.\LC2SQLiteGUI.exe"
set "sexec=.\SQLite3.exe"
set "importsql=.\\import.sql"
set "csv=.\\export.csv"
rem set "dropsql=.\\bin\\droptables.sql"
SET "QUERY=select rowid, name from %temptable% limit 1000000;"
set hr=%time:~0,2%
.\LC2Logo.exe
echo Writing DATA files
echo -------------------------------------------
echo IMPORTING...
echo -------------------------------------------
type nul>%csv%
for /f "usebackq tokens=1-4 delims=," %%a in ("bat.csv") do (
	echo call %sexec% %dbfile% "INSERT OR REPLACE INTO %tableName% ('name') VALUES ('%%a')"
	call %sexec% %dbfile% "INSERT OR REPLACE INTO %tableName% ('name') VALUES ('%%a')"
)
REM call %sexec% %dbfile% ".read %importsql%"
echo -------------------------------------------
echo -------------------------------------------
echo IMPORT DONE...
echo -------------------------------------------
echo done
@echo on