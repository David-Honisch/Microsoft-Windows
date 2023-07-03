@echo off
set input=LC2DockerPHPMyAdmin
set output=LC2DockerPHPMyAdmin.zip
move LC2DockerPHPMyAdmin.zip LC2DockerPHPMyAdmin_old.zip
call powershell.exe "Add-Type -A 'System.IO.Compression.FileSystem'; [IO.Compression.ZipFile]::CreateFromDirectory('%input%', '%output%');"
REM zip -9 -m -o %output% %input%