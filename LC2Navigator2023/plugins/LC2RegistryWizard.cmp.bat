@echo off
set input=LC2RegistryWizard
set output=LC2RegistryWizard.zip
move LC2RegistryWizard.zip LC2RegistryWizard_old.zip
call powershell.exe "Add-Type -A 'System.IO.Compression.FileSystem'; [IO.Compression.ZipFile]::CreateFromDirectory('%input%', '%output%');"
REM zip -9 -m -o %output% %input%