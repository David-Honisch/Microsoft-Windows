set nppp=D:\tools\Notepad++\notepad++.exe
set input=all
set srcdir=..\pluginssrc\
set input=%input%
set output=%input%.zip
move %input%.zip %input%_old.zip
call %nppp% "..\pluginssrc\all\resources\sql\all.zip.sql"
call powershell.exe "Add-Type -A 'System.IO.Compression.FileSystem'; [IO.Compression.ZipFile]::CreateFromDirectory('%srcdir%%input%', '%input%.zip');"
