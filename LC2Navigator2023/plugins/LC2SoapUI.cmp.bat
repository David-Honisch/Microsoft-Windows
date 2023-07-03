set input=LC2SoapUI 
set output=LC2SoapUI.zip  
move LC2SoapUI.zip LC2SoapUI_old.zip  
call powershell.exe "Add-Type -A 'System.IO.Compression.FileSystem'; [IO.Compression.ZipFile]::CreateFromDirectory('LC2SoapUI', 'LC2SoapUI.zip');" 
