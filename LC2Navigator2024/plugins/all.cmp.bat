@echo off
cls
call "%cd%\resources\cmd\config.bat"
@echo off
set input=all
set inputlist=%input%.csv
set target=%input%\resources\sql\all.zip.sql
set output=all.zip
REM --------------------------------------------------------
set LINE=-------------------------------------------------
set table=plugins
set ttable=pluginstemp
set "sexec=%cd%\resources\app\sqlite\SQLite3.exe"
move all.zip all_old.zip
REM call "%sexec%" "%dbfile%" "'.tables'"
REM echo call %sexec% %dbfile% ".read .\\all.schema.sql
echo reading schema:
call %sexec% %dbfile% ".read .\\all.schema.sql
REM call %sexec% %dbfile% ".dump plugins" >%target%
notepad %target%
REM type %target% | findstr INSERT > %target%.insert.csv

REM @echo on
REM @echo off


REM type nul>%target%
REM echo CREATING
REM echo SELECT 'Plugins count ',count(*) from plugins; >> %target%
REM for /f "usebackq tokens=1-3 delims=;" %%a in ("%inputlist%") do (
	REM echo CREATING %%a
	REM echo SELECT 'Importing %%b Plugin SCRIPT'; >> %target%	
	REM call unqoute "INSERT OR REPLACE INTO plugins(person_id,first_name,name,url)values('%%a','%%b Download','%%b Download','exec .\\resources\\cmd\\getupdates.bat /plugins/%%c %%c');" >> %target%
	REM call unqoute "INSERT OR REPLACE INTO plugins(person_id,first_name,name,url)values('%%a','%%b Download','%%b Download','%%c');" >> %target%
	REM echo SELECT 'Importing %%b Plugin SCRIPT DONE'; >> %target%	
REM )
REM type %target%	
REM echo SELECT 'Plugins count ',count(*) from plugins; >> %target%
REM echo SELECT 'Running SQL plugins import DONE'; >> %target%
call powershell.exe "Add-Type -A 'System.IO.Compression.FileSystem'; [IO.Compression.ZipFile]::CreateFromDirectory('%input%', '%output%');"
@echo off
timeout 3