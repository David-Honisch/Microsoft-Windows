set input=lc2mongodb 
set output=lc2mongodb.zip  
move lc2mongodb.zip lc2mongodb_old.zip  
call powershell.exe "Add-Type -A 'System.IO.Compression.FileSystem'; [IO.Compression.ZipFile]::CreateFromDirectory('lc2mongodb', 'lc2mongodb.zip');" 
