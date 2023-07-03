@echo off
set input=LC2AzureAD
set output=LC2AzureAD.zip
move %output% %input%_old.zip
call powershell.exe "Add-Type -A 'System.IO.Compression.FileSystem'; [IO.Compression.ZipFile]::CreateFromDirectory('%input%', '%output%');"
REM zip -9 -m -o %output% %input%