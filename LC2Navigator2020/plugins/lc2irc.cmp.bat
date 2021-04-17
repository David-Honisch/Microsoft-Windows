@echo off
<<<<<<< HEAD:LCUnityCEFServer.Client/install/createClientinstall.bat
set "input=D:\src\unity\bin\lcunityclient"
set output=cinstall.zip
move %output% %output%_old.zip
=======
set input=lc2irc
set output=%input%.zip
move %input%.zip %input%_old.zip
>>>>>>> db44eafad704b6a285baa67588ec98b4231d0b40:LC2Navigator2020/plugins/lc2irc.cmp.bat
call powershell.exe "Add-Type -A 'System.IO.Compression.FileSystem'; [IO.Compression.ZipFile]::CreateFromDirectory('%input%', '%output%');"
REM zip -9 -m -o %output% %input%