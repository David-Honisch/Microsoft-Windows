set input=lc2sqlservercmd 
set output=lc2sqlservercmd.zip  
move lc2sqlservercmd.zip lc2sqlservercmd_old.zip  
call powershell.exe "Add-Type -A 'System.IO.Compression.FileSystem'; [IO.Compression.ZipFile]::CreateFromDirectory('lc2sqlservercmd', 'lc2sqlservercmd.zip');" 
