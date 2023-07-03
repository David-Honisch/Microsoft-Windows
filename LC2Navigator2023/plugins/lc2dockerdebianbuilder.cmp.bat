set input=lc2dockerdebianbuilder 
set output=lc2dockerdebianbuilder.zip  
move lc2dockerdebianbuilder.zip lc2dockerdebianbuilder_old.zip  
call powershell.exe "Add-Type -A 'System.IO.Compression.FileSystem'; [IO.Compression.ZipFile]::CreateFromDirectory('lc2dockerdebianbuilder', 'lc2dockerdebianbuilder.zip');" 
