@echo off
set input=LC2RotatingTorproxy
set output=LC2RotatingTorproxy.zip
move LC2RotatingTorproxy.zip LC2RotatingTorproxy_old.zip
call powershell.exe "Add-Type -A 'System.IO.Compression.FileSystem'; [IO.Compression.ZipFile]::CreateFromDirectory('%input%', '%output%');"
REM zip -9 -m -o %output% %input%