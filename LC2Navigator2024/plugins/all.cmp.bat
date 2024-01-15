set input=all
set output=all.zip  
move all.zip all_old.zip  
call powershell.exe "Add-Type -A 'System.IO.Compression.FileSystem'; [IO.Compression.ZipFile]::CreateFromDirectory('%input%', '%input%.zip');" 
