set input=LC2DBCLI 
set output=LC2DBCLI.zip  
move LC2DBCLI.zip LC2DBCLI_old.zip  
call powershell.exe "Add-Type -A 'System.IO.Compression.FileSystem'; [IO.Compression.ZipFile]::CreateFromDirectory('LC2DBCLI', 'LC2DBCLI.zip');" 
