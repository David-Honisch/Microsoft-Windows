set input=LC2FileExplorer 
set output=LC2FileExplorer.zip  
move LC2FileExplorer.zip LC2FileExplorer_old.zip  
call powershell.exe "Add-Type -A 'System.IO.Compression.FileSystem'; [IO.Compression.ZipFile]::CreateFromDirectory('LC2FileExplorer', 'LC2FileExplorer.zip');" 
