set input=LC2SAPUI 
set output=LC2SAPUI.zip  
move LC2SAPUI.zip LC2SAPUI_old.zip  
call powershell.exe "Add-Type -A 'System.IO.Compression.FileSystem'; [IO.Compression.ZipFile]::CreateFromDirectory('LC2SAPUI', 'LC2SAPUI.zip');" 
