set input=LC2CVEGrabber 
set output=LC2CVEGrabber.zip  
move LC2CVEGrabber.zip LC2CVEGrabber_old.zip  
call powershell.exe "Add-Type -A 'System.IO.Compression.FileSystem'; [IO.Compression.ZipFile]::CreateFromDirectory('LC2CVEGrabber', 'LC2CVEGrabber.zip');" 
