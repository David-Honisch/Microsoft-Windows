set input=LC2IPFS 
set output=LC2IPFS.zip  
move LC2IPFS.zip LC2IPFS_old.zip  
call powershell.exe "Add-Type -A 'System.IO.Compression.FileSystem'; [IO.Compression.ZipFile]::CreateFromDirectory('LC2IPFS', 'LC2IPFS.zip');" 
