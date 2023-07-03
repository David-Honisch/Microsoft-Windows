set input=LC2IRCClient 
set output=LC2IRCClient.zip  
move LC2IRCClient.zip LC2IRCClient_old.zip  
call powershell.exe "Add-Type -A 'System.IO.Compression.FileSystem'; [IO.Compression.ZipFile]::CreateFromDirectory('LC2IRCClient', 'LC2IRCClient.zip');" 
