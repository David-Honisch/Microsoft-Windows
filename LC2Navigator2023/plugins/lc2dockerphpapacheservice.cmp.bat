set input=lc2dockerphpapacheservice 
set output=lc2dockerphpapacheservice.zip  
move lc2dockerphpapacheservice.zip lc2dockerphpapacheservice_old.zip  
call powershell.exe "Add-Type -A 'System.IO.Compression.FileSystem'; [IO.Compression.ZipFile]::CreateFromDirectory('lc2dockerphpapacheservice', 'lc2dockerphpapacheservice.zip');" 
