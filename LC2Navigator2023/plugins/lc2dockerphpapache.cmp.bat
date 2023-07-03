set input=lc2dockerphpapache 
set output=lc2dockerphpapache.zip  
move lc2dockerphpapache.zip lc2dockerphpapache_old.zip  
call powershell.exe "Add-Type -A 'System.IO.Compression.FileSystem'; [IO.Compression.ZipFile]::CreateFromDirectory('lc2dockerphpapache', 'lc2dockerphpapache.zip');" 
