@echo off
set input=excelimport
set output=excelimport.zip
move excelimport.zip excelimport_old.zip
call powershell.exe "Add-Type -A 'System.IO.Compression.FileSystem'; [IO.Compression.ZipFile]::CreateFromDirectory('%input%', '%output%');"
REM zip -9 -m -o %output% %input%