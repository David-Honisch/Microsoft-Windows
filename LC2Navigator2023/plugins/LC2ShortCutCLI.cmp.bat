set input=LC2ShortCutCLI 
set output=LC2ShortCutCLI.zip  
move LC2ShortCutCLI.zip LC2ShortCutCLI_old.zip  
call powershell.exe "Add-Type -A 'System.IO.Compression.FileSystem'; [IO.Compression.ZipFile]::CreateFromDirectory('LC2ShortCutCLI', 'LC2ShortCutCLI.zip');" 
