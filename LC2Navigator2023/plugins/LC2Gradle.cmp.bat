set input=LC2Gradle 
set output=LC2Gradle.zip  
move LC2Gradle.zip LC2Gradle_old.zip  
call powershell.exe "Add-Type -A 'System.IO.Compression.FileSystem'; [IO.Compression.ZipFile]::CreateFromDirectory('LC2Gradle', 'LC2Gradle.zip');" 
