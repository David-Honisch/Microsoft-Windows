set input=lc2kubernetes 
set output=lc2kubernetes.zip  
move lc2kubernetes.zip lc2kubernetes_old.zip  
call powershell.exe "Add-Type -A 'System.IO.Compression.FileSystem'; [IO.Compression.ZipFile]::CreateFromDirectory('lc2kubernetes', 'lc2kubernetes.zip');" 
