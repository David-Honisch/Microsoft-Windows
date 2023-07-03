set input=LC2PHP2Exe 
set output=LC2PHP2Exe.zip  
move LC2PHP2Exe.zip LC2PHP2Exe_old.zip  
call powershell.exe "Add-Type -A 'System.IO.Compression.FileSystem'; [IO.Compression.ZipFile]::CreateFromDirectory('LC2PHP2Exe', 'LC2PHP2Exe.zip');" 
