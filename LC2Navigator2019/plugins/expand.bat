@echo off
set input=%1
set output=%2
REM powershell.exe "Add-Type -A 'System.IO.Compression.FileSystem'; [IO.Compression.ZipFile]::ExtractToDirectory('%input%', '%output%');"
expand %output% %input%