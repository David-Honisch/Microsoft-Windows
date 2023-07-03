set input=LC2OpenAI 
set output=LC2OpenAI.zip  
move LC2OpenAI.zip LC2OpenAI_old.zip  
call powershell.exe "Add-Type -A 'System.IO.Compression.FileSystem'; [IO.Compression.ZipFile]::CreateFromDirectory('LC2OpenAI', 'LC2OpenAI.zip');" 
