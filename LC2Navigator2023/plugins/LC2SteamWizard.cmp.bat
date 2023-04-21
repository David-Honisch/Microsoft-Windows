set input=LC2SteamWizard 
set output=LC2SteamWizard.zip  
move LC2SteamWizard.zip LC2SteamWizard_old.zip  
call powershell.exe "Add-Type -A 'System.IO.Compression.FileSystem'; [IO.Compression.ZipFile]::CreateFromDirectory('LC2SteamWizard', 'LC2SteamWizard.zip');" 
