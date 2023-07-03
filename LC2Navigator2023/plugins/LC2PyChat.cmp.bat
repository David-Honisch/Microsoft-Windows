set input=LC2PyChat 
set output=LC2PyChat.zip  
move LC2PyChat.zip LC2PyChat_old.zip  
call powershell.exe "Add-Type -A 'System.IO.Compression.FileSystem'; [IO.Compression.ZipFile]::CreateFromDirectory('LC2PyChat', 'LC2PyChat.zip');" 
