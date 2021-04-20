@echo off
set "input=D:\src\unity\bin\lcunityclient"
set output=cinstall.zip
move %output% %output%_old.zip
set input=lc2irc
set output=%input%.zip
move %input%.zip %input%_old.zip
call powershell.exe "Add-Type -A 'System.IO.Compression.FileSystem'; [IO.Compression.ZipFile]::CreateFromDirectory('%input%', '%output%');"
REM zip -9 -m -o %output% %input%