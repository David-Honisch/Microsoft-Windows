@echo off
set "input=D:\src\unity\bin\lcunityserver"
set output=serverinstall.zip
move %output% %output%_old.zip
call powershell.exe "Add-Type -A 'System.IO.Compression.FileSystem'; [IO.Compression.ZipFile]::CreateFromDirectory('%input%', '%output%');"
REM zip -9 -m -o %output% %input%