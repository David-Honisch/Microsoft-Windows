@echo off
set input=LC2ApacheDS
set output=LC2ApacheDS.zip
move LC2ApacheDS.zip LC2ApacheDS_old.zip
call powershell.exe "Add-Type -A 'System.IO.Compression.FileSystem'; [IO.Compression.ZipFile]::CreateFromDirectory('%input%', '%output%');"
REM zip -9 -m -o %output% %input%