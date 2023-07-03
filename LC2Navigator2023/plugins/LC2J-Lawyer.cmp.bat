@echo off
set input=LC2J-Lawyer
set output=LC2J-Lawyer.zip
move %input%.zip %input%_old.zip
call powershell.exe "Add-Type -A 'System.IO.Compression.FileSystem'; [IO.Compression.ZipFile]::CreateFromDirectory('%input%', '%output%');"
REM zip -9 -m -o %output% %input%