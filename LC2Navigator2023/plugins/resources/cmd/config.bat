@echo off
set port=443
set host=http://localhost/cms
set user=administrator
set pwd=xxx
set "resdir=%cd%\resources\"
set "sexec=%resdir%app\sqlite\sqlite3.exe"
set "dbfile=%cd%\resources\lc.db"
set "table=plugins"
SET "QUERY=select * from %table% limit 1000000;"
SET "QUERY2=INSERT INTO %table% (name) values ('Test');"
set "RPATH=https://raw.githubusercontent.com/David-Honisch/Microsoft-Windows/master/LC2Navigator2022/"
set "UPDATEFILE=appplugin.zip"
set "SQLFILE=.\\resources\\sql\\updates.sql"
REM set "TSQLFILE=.\\resources\\sql\\%XUPDATEFILE%.sql"
set "showhtml=..\html\~show.html"
set "NODOWNLOAD=%cd%\.no_downloads.cfg"
set "NOEXTRACT=%cd%\.no_extract.cfg"
set "NOSQLIMPORT=%cd%\.NOSQLIMPORT.cfg"
set "getlink=%resdir%cmd\getllink.bat"
set "outFile=%temp%\~lcnavigator2020allplugins.csv"
SET "LT=^<"
SET "RT=^>"
SET "XV=%1"
SET "XT=%2"
SET "CROW=%LT%%XV%%RT%%XT%%LT%/%XV%%RT%"
::global startup
set gstartup=C:\ProgramData\Microsoft\Windows\Start Menu\Programs\StartUp
::current user startup
set startup=%USERPROFILE%\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup
@echo on