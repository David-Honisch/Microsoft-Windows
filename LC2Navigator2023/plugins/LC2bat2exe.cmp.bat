set input=LC2bat2exe 
set output=LC2bat2exe.zip  
move LC2bat2exe.zip LC2bat2exe_old.zip  
call powershell.exe "Add-Type -A 'System.IO.Compression.FileSystem'; [IO.Compression.ZipFile]::CreateFromDirectory('LC2bat2exe', 'LC2bat2exe.zip');" 
