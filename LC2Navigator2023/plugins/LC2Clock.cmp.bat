set input=LC2Clock 
set output=LC2Clock.zip  
move LC2Clock.zip LC2Clock_old.zip  
call powershell.exe "Add-Type -A 'System.IO.Compression.FileSystem'; [IO.Compression.ZipFile]::CreateFromDirectory('LC2Clock', 'LC2Clock.zip');" 
