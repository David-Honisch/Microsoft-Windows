set input=LC2Lampp 
set output=LC2Lampp.zip  
move LC2Lampp.zip LC2Lampp_old.zip  
call powershell.exe "Add-Type -A 'System.IO.Compression.FileSystem'; [IO.Compression.ZipFile]::CreateFromDirectory('LC2Lampp', 'LC2Lampp.zip');" 
