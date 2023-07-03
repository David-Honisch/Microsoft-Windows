set input=LC2DEBanksUpdater 
set output=LC2DEBanksUpdater.zip  
move LC2DEBanksUpdater.zip LC2DEBanksUpdater_old.zip  
call powershell.exe "Add-Type -A 'System.IO.Compression.FileSystem'; [IO.Compression.ZipFile]::CreateFromDirectory('LC2DEBanksUpdater', 'LC2DEBanksUpdater.zip');" 
