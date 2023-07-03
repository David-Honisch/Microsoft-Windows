set input=apache-maven 
set output=apache-maven.zip  
move apache-maven.zip apache-maven_old.zip  
call powershell.exe "Add-Type -A 'System.IO.Compression.FileSystem'; [IO.Compression.ZipFile]::CreateFromDirectory('apache-maven', 'apache-maven.zip');" 
