@echo off
set input=LC2HTTPAnalysis
set output=LC2HTTPAnalysis.zip
move LC2HTTPAnalysis.zip LC2HTTPAnalysis_old.zip
call powershell.exe "Add-Type -A 'System.IO.Compression.FileSystem'; [IO.Compression.ZipFile]::CreateFromDirectory('%input%', '%output%');"
REM zip -9 -m -o %output% %input%