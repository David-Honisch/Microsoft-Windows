@echo off
set input=all
set inputlist=%input%.csv
set target=%input%\resources\sql\all.zip.sql
set output=all.zip
move all.zip all_old.zip
type nul>%target%
echo CREATING
echo SELECT 'Plugins count ',count(*) from plugins; >> %target%
for /f "usebackq tokens=1-3 delims=;" %%a in ("%inputlist%") do (
	echo CREATING %%a
	echo SELECT 'Importing %%b Plugin SCRIPT'; >> %target%	
	call unqoute "INSERT OR REPLACE INTO plugins(person_id,first_name,name,url)values('%%a','%%b Download','%%b Download','exec .\\resources\\cmd\\getupdates.bat /plugins/%%b %%b');" >> %target%
	echo SELECT 'Importing %%b Plugin SCRIPT DONE'; >> %target%	
)
echo SELECT 'Plugins count ',count(*) from plugins; >> %target%
echo SELECT 'Running SQL plugins import DONE'; >> %target%
call powershell.exe "Add-Type -A 'System.IO.Compression.FileSystem'; [IO.Compression.ZipFile]::CreateFromDirectory('%input%', '%output%');"