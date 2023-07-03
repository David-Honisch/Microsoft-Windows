@echo off
set input=lc2mysqldocker
set output=lc2mysqldocker.zip
move %output% %input%_old.zip
call powershell.exe "Add-Type -A 'System.IO.Compression.FileSystem'; [IO.Compression.ZipFile]::CreateFromDirectory('%input%', '%output%');"
REM zip -9 -m -o %output% %input%