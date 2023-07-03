set input=LC2Oracle23C 
set output=LC2Oracle23C.zip  
move LC2Oracle23C.zip LC2Oracle23C_old.zip  
call powershell.exe "Add-Type -A 'System.IO.Compression.FileSystem'; [IO.Compression.ZipFile]::CreateFromDirectory('LC2Oracle23C', 'LC2Oracle23C.zip');" 
