set input=LC2WindowsSerialNo 
set output=LC2WindowsSerialNo.zip  
move LC2WindowsSerialNo.zip LC2WindowsSerialNo_old.zip  
call powershell.exe "Add-Type -A 'System.IO.Compression.FileSystem'; [IO.Compression.ZipFile]::CreateFromDirectory('LC2WindowsSerialNo', 'LC2WindowsSerialNo.zip');" 
