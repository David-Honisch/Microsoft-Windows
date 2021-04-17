@echo off
set input=mysqldocker
set output=mysqldocker.zip
move %output% mysqldocker_old.zip
call powershell.exe "Add-Type -A 'System.IO.Compression.FileSystem'; [IO.Compression.ZipFile]::CreateFromDirectory('%input%', '%output%');"
REM zip -9 -m -o %output% %input%