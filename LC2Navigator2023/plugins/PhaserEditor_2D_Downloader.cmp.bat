set input=PhaserEditor_2D_Downloader 
set output=PhaserEditor_2D_Downloader.zip  
move PhaserEditor_2D_Downloader.zip PhaserEditor_2D_Downloader_old.zip  
call powershell.exe "Add-Type -A 'System.IO.Compression.FileSystem'; [IO.Compression.ZipFile]::CreateFromDirectory('PhaserEditor_2D_Downloader', 'PhaserEditor_2D_Downloader.zip');" 
