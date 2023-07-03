set input=LC2Microsoft.Toolkit 
set output=LC2Microsoft.Toolkit.zip  
move LC2Microsoft.Toolkit.zip LC2Microsoft.Toolkit_old.zip  
call powershell.exe "Add-Type -A 'System.IO.Compression.FileSystem'; [IO.Compression.ZipFile]::CreateFromDirectory('LC2Microsoft.Toolkit', 'LC2Microsoft.Toolkit.zip');" 
