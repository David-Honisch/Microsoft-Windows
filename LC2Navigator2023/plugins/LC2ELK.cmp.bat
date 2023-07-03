@echo off
set input=LC2ELK
set output=LC2ELK.zip
move LC2ELK.zip LC2ELK_old.zip
call powershell.exe "Add-Type -A 'System.IO.Compression.FileSystem'; [IO.Compression.ZipFile]::CreateFromDirectory('%input%', '%output%');"
REM zip -9 -m -o %output% %input%