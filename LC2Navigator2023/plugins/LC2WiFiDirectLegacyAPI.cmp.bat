set input=LC2WiFiDirectLegacyAPI 
set output=LC2WiFiDirectLegacyAPI.zip  
move LC2WiFiDirectLegacyAPI.zip LC2WiFiDirectLegacyAPI_old.zip  
call powershell.exe "Add-Type -A 'System.IO.Compression.FileSystem'; [IO.Compression.ZipFile]::CreateFromDirectory('LC2WiFiDirectLegacyAPI', 'LC2WiFiDirectLegacyAPI.zip');" 
