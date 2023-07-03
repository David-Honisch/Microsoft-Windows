@echo off
set input=LC2Java.Starter.v.1.0
set output=LC2Java.Starter.v.1.0.zip
move LC2Java.Starter.v.1.0.zip LC2Java.Starter.v.1.0_old.zip
call powershell.exe "Add-Type -A 'System.IO.Compression.FileSystem'; [IO.Compression.ZipFile]::CreateFromDirectory('%input%', '%output%');"
REM zip -9 -m -o %output% %input%