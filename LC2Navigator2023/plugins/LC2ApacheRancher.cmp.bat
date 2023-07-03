set input=LC2ApacheRancher 
set output=LC2ApacheRancher.zip  
move LC2ApacheRancher.zip LC2ApacheRancher_old.zip  
call powershell.exe "Add-Type -A 'System.IO.Compression.FileSystem'; [IO.Compression.ZipFile]::CreateFromDirectory('LC2ApacheRancher', 'LC2ApacheRancher.zip');" 
