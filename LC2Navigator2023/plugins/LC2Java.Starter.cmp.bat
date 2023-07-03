@echo off
set input=LC2Java.Starter
set output=LC2Java.Starter.zip
move %input%.zip %input%_old.zip
call powershell.exe "Add-Type -A 'System.IO.Compression.FileSystem'; [IO.Compression.ZipFile]::CreateFromDirectory('%input%', '%output%');"
REM zip -9 -m -o %output% %input%