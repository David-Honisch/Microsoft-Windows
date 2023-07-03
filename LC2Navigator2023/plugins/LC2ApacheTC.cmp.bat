set input=LC2ApacheTC 
set output=LC2ApacheTC.zip  
move LC2ApacheTC.zip LC2ApacheTC_old.zip  
call powershell.exe "Add-Type -A 'System.IO.Compression.FileSystem'; [IO.Compression.ZipFile]::CreateFromDirectory('LC2ApacheTC', 'LC2ApacheTC.zip');" 
