@echo off
cls
REM .\bin\LC2Logo.exe
echo %time%
call %cd%\resources\cmd\sqlite.config.bat
@echo off
set "cimportdir=%1"
@echo off
setLocal EnableDelayedExpansion
REM if %cimportdir% ==[] (
if %cimportdir% == "" (
	echo not found	
) else (
	echo found.	
	set "importdir=%cimportdir%"
)
echo Reading: %cimportdir% done.
dir /b /s %importdir%\*.* > %exportdir%\export.csv
REM %PRG% %dbfile%  ".read sql.sql"
%PRG% %dbfile% "CREATE TABLE IF NOT EXISTS %table%(name TEXT, type TEXT, img BLOB);"
for /R %exportdir% %%a in (*.csv) do (
for /f "usebackq tokens=1-1 delims=," %%b in (%%a) do (
echo %PRG% %dbfile% "INSERT INTO %table%(name,type,img) VALUES('%%~nb','%mime%',readfile('%%b'));"
call %PRG% %dbfile% "INSERT INTO %table%(name,type,img) VALUES('%%~nb','%%~xb',readfile('%%b'));"
	)
)
call %PRG% %dbfile% "SELECT 'COUNT:'||count(*) FROM  %table% limit 1;"
REM pause
@echo on