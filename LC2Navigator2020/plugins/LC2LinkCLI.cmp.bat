@echo off
<<<<<<< HEAD:LCUnityCEFServer.Client/install/createServerinstall.bat
set "input=D:\src\unity\bin\lcunityserver"
set output=serverinstall.zip
=======
set input=lc2linkcli
set output=lc2linkcli.zip
>>>>>>> db44eafad704b6a285baa67588ec98b4231d0b40:LC2Navigator2020/plugins/LC2LinkCLI.cmp.bat
move %output% %output%_old.zip
call powershell.exe "Add-Type -A 'System.IO.Compression.FileSystem'; [IO.Compression.ZipFile]::CreateFromDirectory('%input%', '%output%');"
REM zip -9 -m -o %output% %input%