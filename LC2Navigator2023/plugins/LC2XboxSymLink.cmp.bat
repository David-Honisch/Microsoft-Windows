set input=LC2XboxSymLink 
set output=LC2XboxSymLink.zip  
move LC2XboxSymLink.zip LC2XboxSymLink_old.zip  
call powershell.exe "Add-Type -A 'System.IO.Compression.FileSystem'; [IO.Compression.ZipFile]::CreateFromDirectory('LC2XboxSymLink', 'LC2XboxSymLink.zip');" 
