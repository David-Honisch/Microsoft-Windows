@echo off
set input=LC2Matplotlib
set output=LC2Matplotlib.zip
move LC2Matplotlib.zip LC2Matplotlib_old.zip
call powershell.exe "Add-Type -A 'System.IO.Compression.FileSystem'; [IO.Compression.ZipFile]::CreateFromDirectory('%input%', '%output%');"
REM zip -9 -m -o %output% %input%