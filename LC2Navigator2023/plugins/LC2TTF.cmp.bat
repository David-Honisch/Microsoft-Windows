set input=LC2TTF 
set output=LC2TTF.zip  
move LC2TTF.zip LC2TTF_old.zip  
call powershell.exe "Add-Type -A 'System.IO.Compression.FileSystem'; [IO.Compression.ZipFile]::CreateFromDirectory('LC2TTF', 'LC2TTF.zip');" 
