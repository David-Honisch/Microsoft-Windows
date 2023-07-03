set input=LC2WebTorrent 
set output=LC2WebTorrent.zip  
move LC2WebTorrent.zip LC2WebTorrent_old.zip  
call powershell.exe "Add-Type -A 'System.IO.Compression.FileSystem'; [IO.Compression.ZipFile]::CreateFromDirectory('LC2WebTorrent', 'LC2WebTorrent.zip');" 
