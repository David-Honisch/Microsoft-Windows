@echo off
set input=LC2DockerSonarCube
set output=LC2DockerSonarCube.zip
move LC2DockerSonarCube.zip LC2DockerSonarCube_old.zip
call powershell.exe "Add-Type -A 'System.IO.Compression.FileSystem'; [IO.Compression.ZipFile]::CreateFromDirectory('%input%', '%output%');"
REM zip -9 -m -o %output% %input%