@echo off
set input=LC2DockerJenkins
set output=LC2DockerJenkins.zip
move LC2DockerJenkins.zip LC2DockerJenkins_old.zip
call powershell.exe "Add-Type -A 'System.IO.Compression.FileSystem'; [IO.Compression.ZipFile]::CreateFromDirectory('%input%', '%output%');"
REM zip -9 -m -o %output% %input%