set input=LC2OpenXLA 
set output=LC2OpenXLA.zip  
move LC2OpenXLA.zip LC2OpenXLA_old.zip  
call powershell.exe "Add-Type -A 'System.IO.Compression.FileSystem'; [IO.Compression.ZipFile]::CreateFromDirectory('LC2OpenXLA', 'LC2OpenXLA.zip');" 
