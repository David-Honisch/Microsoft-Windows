@echo off
set input=LC2Grafana
set output=LC2Grafana.zip
move LC2Grafana.zip LC2Grafana_old.zip
call powershell.exe "Add-Type -A 'System.IO.Compression.FileSystem'; [IO.Compression.ZipFile]::CreateFromDirectory('%input%', '%output%');"
REM zip -9 -m -o %output% %input%