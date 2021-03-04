@echo off
set input=all
set inputlist=%input%.csv
set target=%input%\resources\sql\all.zip.sql
set output=all.zip
move all.zip all_old.zip
type nul > %target%
echo "SELECT '<p>Count of plugins:'||count(*)||'</p>' from plugins;" >> %target%
for /f "usebackq tokens=1-3 delims=;" %%a in ("%inputlist%") do (
	echo "SELECT '^<h3^>Importing %%a Plugin SCRIPT^</h3>';" >> %target%
	echo "INSERT OR REPLACE INTO plugins (first_name,name,url) values ('%%a Download','%%a Download','exec .\\resources\\cmd\\getupdates.bat /plugins/%%a %%a');" >> %target%
	echo "SELECT '^<h3^>Importing %%a Plugin SCRIPT DONE^</h3^>';" >> %target%	
)
echo "SELECT '<p>Count of all imported plugins:'||count(*)||'</p>' from plugins;" >> %target%
echo "SELECT '<h3>Running SQL plugins import DONE</h3>';" >> %target%
call powershell.exe "Add-Type -A 'System.IO.Compression.FileSystem'; [IO.Compression.ZipFile]::CreateFromDirectory('%input%', '%output%');"
REM zip -9 -m -o %output% %input%