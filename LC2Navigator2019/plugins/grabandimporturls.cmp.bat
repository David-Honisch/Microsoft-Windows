@echo off
set input=grabandimporturls
set output=grabandimporturls.zip
move grabandimporturls.zip grabandimporturls_old.zip
call powershell.exe "Add-Type -A 'System.IO.Compression.FileSystem'; [IO.Compression.ZipFile]::CreateFromDirectory('%input%', '%output%');"
REM zip -9 -m -o %output% %input%