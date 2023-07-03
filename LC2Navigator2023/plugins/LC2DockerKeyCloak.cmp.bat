set input=LC2DockerKeyCloak 
set output=LC2DockerKeyCloak.zip  
move LC2DockerKeyCloak.zip LC2DockerKeyCloak_old.zip  
call powershell.exe "Add-Type -A 'System.IO.Compression.FileSystem'; [IO.Compression.ZipFile]::CreateFromDirectory('LC2DockerKeyCloak', 'LC2DockerKeyCloak.zip');" 
