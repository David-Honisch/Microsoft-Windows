@echo off
cls
.\LC2Logo.exe
echo %time%
timeout 1 > NUL
setLocal EnableDelayedExpansion
Set "exportdir=export"
Set "csvdir="
set "csvdirfilename=export.csv"
Set "TOCSV=bin\2csv.bat"
Set "MSGBOX=bin\msgbox.bat"
Set "CSVTOSQLITE=bin\csv2sqlite.bat"
Set "LINKCSV=bin\linkcsv.bat"
Set "CREATECSV=bin\createcsv.bat"
Set "PRG=LC2SQLiteGUI.exe"
set "sexec=.\sqlite3.exe"
set "dbfile=lc.db"
set "dbtempfile=templc.db"
set "table=url"
set "temptable=tempurls"
set "importsql=.\\LC2SQLiteGUI.sql"
set "tempimportsql=.\\LC2SQLiteGUI.util.sql"
rem set "dropsql=.\\bin\\droptables.sql"
SET "QUERY=select rowid, name from %temptable% limit 1000000;"
set hr=%time:~0,2%
REM setLocal EnableDelayedExpansion
cls
echo Reading all files
REM dir /s /b > ./import/all.csv
REM call .\bin\createcsv.bat
echo -------------------------------------------
rem setlocal enabledelayedexpansion
echo -------------------------------------------
echo reset... %csvdir%\%csvdirfilename%
echo -------------------------------------------
REM type nul> %csvdir%\%csvdirfilename%
REM dir c:\*.* /s /b > %csvdir%\%csvdirfilename%
echo -------------------------------------------
echo running...
REM for %%i in (C D E F G H I J K L M N O P Q R S T U V W X Y Z) DO ( 
	REM @if exist %%i: ( @echo %%i )
	REM @if exist %%i: ( dir /b /s %%i:\*.* >> %csvdir%\%csvdirfilename% )
REM )
echo -------------------------------------------
@echo off
echo Delete old database
rem del lc.db
echo CREATE DATABASE %sexec% %dbfile%
rem call %sexec% %dbfile%
rem pause
rem echo CALL %sexec%
rem call %sexec% .read table.sql
rem call %sexec% %dbtempfile% ".read %tempimportsql%"
echo call %sexec% %dbfile% ".read %importsql%"
call %sexec% %dbfile% ".read %importsql%"
REM for /R ./import %%a in (*.csv) do (
REM echo %sexec% %dbfile% ".import '%%a' %temptable%"
REM %sexec% %dbtempfile% ".import '%%a' %temptable%"
REM )
REM rem call %sexec% %dbfile% -csv "%QUERY%" > .\export\export.csv
REM call %sexec% %dbfile% "%QUERY%" > .\export\export.csv
REM echo %sexec% %dbfile% ".import '.\export\export.csv' %table%"
REM %sexec% %dbfile% ".import '.\export\export.csv' %table%"
REM echo DROP TEMP TABLE
rem call %sexec% lc.db ".read %dropsql%"
start %PRG%
rem pause
@echo on