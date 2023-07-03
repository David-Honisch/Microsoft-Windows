set input=LC2DockerOracle 
set output=LC2DockerOracle.zip  
move LC2DockerOracle.zip LC2DockerOracle_old.zip  
call powershell.exe "Add-Type -A 'System.IO.Compression.FileSystem'; [IO.Compression.ZipFile]::CreateFromDirectory('LC2DockerOracle', 'LC2DockerOracle.zip');" 
