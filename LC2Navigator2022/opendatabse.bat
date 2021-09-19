@echo off
cls
SET "LT=^<"
SET "RT=^>"
SET "LINE=%LT%hr%RT%"
set "sexec=%cd%\sqlite3.exe"
set "dbfile=%cd%\release-builds\lc2search-win32-ia32\resources\lc.db"
set "table=importscripts"
echo %LINE%
call %cd%\resources\htmlelem.bat h1 IMPORT
@echo off
type %cd%\resources\clearbutton.html
REM call %sexec% %dbfile% "INSERT INTO %table% (first_name,name,url) values ('_Clear','echo.','echo.');"
del "release-builds\lc2search-win32-ia32\resources\lc.db"
@echo off
echo %LT%h1%RT%IMPORT DONE%LT%/h1%RT%

echo %LINE%
echo quit
echo exit
echo Bye
@echo on