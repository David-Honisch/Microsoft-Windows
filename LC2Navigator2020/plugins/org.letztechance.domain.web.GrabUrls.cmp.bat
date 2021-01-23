@echo off
set input=org.letztechance.domain.web.GrabUrls
set output=org.letztechance.domain.web.GrabUrls.zip
move org.letztechance.domain.web.GrabUrls.zip org.letztechance.domain.web.GrabUrls_old.zip
call powershell.exe "Add-Type -A 'System.IO.Compression.FileSystem'; [IO.Compression.ZipFile]::CreateFromDirectory('%input%', '%output%');"
REM zip -9 -m -o %output% %input%