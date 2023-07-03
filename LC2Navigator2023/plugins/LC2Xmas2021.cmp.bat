set input=LC2Xmas2021 
set output=LC2Xmas2021.zip  
move LC2Xmas2021.zip LC2Xmas2021_old.zip  
call powershell.exe "Add-Type -A 'System.IO.Compression.FileSystem'; [IO.Compression.ZipFile]::CreateFromDirectory('LC2Xmas2021', 'LC2Xmas2021.zip');" 
