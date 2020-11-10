@echo off
set input=%1
set output=%2
powershell.exe "Add-Type -A 'System.IO.Compression.FileSystem'; [IO.Compression.ZipFile]::ExtractToDirectory('%input%', '%output%');"
REM expand %output% %input%