@echo off
set input=LC2XMLFileBackup
set output=LC2XMLFileBackup.zip
move LC2XMLFileBackup.zip LC2XMLFileBackup_old.zip
call powershell.exe "Add-Type -A 'System.IO.Compression.FileSystem'; [IO.Compression.ZipFile]::CreateFromDirectory('%input%', '%output%');"
REM zip -9 -m -o %output% %input%