set input=LC2EncrypDecrypt 
set output=LC2EncrypDecrypt.zip  
move LC2EncrypDecrypt.zip LC2EncrypDecrypt_old.zip  
call powershell.exe "Add-Type -A 'System.IO.Compression.FileSystem'; [IO.Compression.ZipFile]::CreateFromDirectory('LC2EncrypDecrypt', 'LC2EncrypDecrypt.zip');" 
