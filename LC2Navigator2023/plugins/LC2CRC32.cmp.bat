set input=LC2CRC32 
set output=LC2CRC32.zip  
move LC2CRC32.zip LC2CRC32_old.zip  
call powershell.exe "Add-Type -A 'System.IO.Compression.FileSystem'; [IO.Compression.ZipFile]::CreateFromDirectory('LC2CRC32', 'LC2CRC32.zip');" 
