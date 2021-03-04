@echo off
set input=all
set inputlist=%input%.csv
set target=%input%\resources\sql\all.zip.sql
set output=all.zip
move all.zip all_old.zip
type nul>%target%
echo CREATING
REM echo SELECT 'Count of plugins:'||count(*)||'' from plugins; >> %target%
for /f "usebackq tokens=1-3 delims=;" %%a in ("%inputlist%") do (
	echo CREATING %%a
	echo SELECT 'Importing %%a Plugin SCRIPT'; >> %target%
	set "sql=INSERT OR REPLACE INTO plugins(first_name,name,url)values('%%a Download','%%a Download','exec .\\resources\\cmd\\getupdates.bat /plugins/%%a %%a');"
	set sql
	call unqoute "%sql%" >> %target%
	echo SELECT 'Importing %%a Plugin SCRIPT DONE'; >> %target%	
)
REM call unqoute "SELECT 'Count of all imported plugins:'||count(*)||'' from plugins;" >> %target%
echo SELECT 'Plugins count ',count(*) from plugins; >> %target%
echo SELECT 'Running SQL plugins import DONE'; >> %target%
call powershell.exe "Add-Type -A 'System.IO.Compression.FileSystem'; [IO.Compression.ZipFile]::CreateFromDirectory('%input%', '%output%');"
REM zip -9 -m -o %output% %input%