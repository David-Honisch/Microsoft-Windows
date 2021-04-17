@echo off
set "input=D:\src\unity\bin\lcunityclient"
set output=cinstall.zip
REM move %output% %output%_old.zip
REM call powershell.exe "Add-Type -A 'System.IO.Compression.FileSystem'; [IO.Compression.ZipFile]::CreateFromDirectory('%input%', '%output%');"
REM zip -9 -m -o %output% %input%
git lfs install
git lfs track "*.psd"
git add .gitattributes