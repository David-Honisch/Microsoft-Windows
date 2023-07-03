set input=LC2JSVideoPlayer 
set output=LC2JSVideoPlayer.zip  
move LC2JSVideoPlayer.zip LC2JSVideoPlayer_old.zip  
call powershell.exe "Add-Type -A 'System.IO.Compression.FileSystem'; [IO.Compression.ZipFile]::CreateFromDirectory('LC2JSVideoPlayer', 'LC2JSVideoPlayer.zip');" 
