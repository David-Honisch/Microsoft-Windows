set input=lc2ircs 
set output=lc2ircs.zip  
move lc2ircs.zip lc2ircs_old.zip  
call powershell.exe "Add-Type -A 'System.IO.Compression.FileSystem'; [IO.Compression.ZipFile]::CreateFromDirectory('lc2ircs', 'lc2ircs.zip');" 
