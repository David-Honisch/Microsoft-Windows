@echo off
set input=graburls
set output=graburls.zip
move graburls.zip graburls_old.zip
call powershell.exe "Add-Type -A 'System.IO.Compression.FileSystem'; [IO.Compression.ZipFile]::CreateFromDirectory('%input%', '%output%');"
REM zip -9 -m -o %output% %input%