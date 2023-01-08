set input=LC2Intro 
set output=LC2Intro.zip  
move LC2Intro.zip LC2Intro_old.zip  
call powershell.exe "Add-Type -A 'System.IO.Compression.FileSystem'; [IO.Compression.ZipFile]::CreateFromDirectory('LC2Intro', 'LC2Intro.zip');" 
