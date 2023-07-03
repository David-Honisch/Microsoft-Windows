set input=LetsEncryptBoulder 
set output=LetsEncryptBoulder.zip  
move LetsEncryptBoulder.zip LetsEncryptBoulder_old.zip  
call powershell.exe "Add-Type -A 'System.IO.Compression.FileSystem'; [IO.Compression.ZipFile]::CreateFromDirectory('LetsEncryptBoulder', 'LetsEncryptBoulder.zip');" 
