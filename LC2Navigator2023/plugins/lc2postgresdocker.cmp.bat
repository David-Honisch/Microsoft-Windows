set input=lc2postgresdocker
set output=lc2postgresdocker.zip
move lc2postgresdocker.zip lc2postgresdocker_old.zip  
call powershell.exe "Add-Type -A 'System.IO.Compression.FileSystem'; [IO.Compression.ZipFile]::CreateFromDirectory('%input%', '%input%.zip');" 
