set input=apache-ant 
set output=apache-ant.zip  
move apache-ant.zip apache-ant_old.zip  
call powershell.exe "Add-Type -A 'System.IO.Compression.FileSystem'; [IO.Compression.ZipFile]::CreateFromDirectory('apache-ant', 'apache-ant.zip');" 
