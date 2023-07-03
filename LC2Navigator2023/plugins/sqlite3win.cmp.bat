@echo off
set input=sqlite3win
set output=sqlite3win.zip
move sqlite3win.zip sqlite3win_old.zip
call powershell.exe "Add-Type -A 'System.IO.Compression.FileSystem'; [IO.Compression.ZipFile]::CreateFromDirectory('%input%', '%output%');"
REM zip -9 -m -o %output% %input%