set input=LC2Carousel 
set output=LC2Carousel.zip  
move LC2Carousel.zip LC2Carousel_old.zip  
call powershell.exe "Add-Type -A 'System.IO.Compression.FileSystem'; [IO.Compression.ZipFile]::CreateFromDirectory('LC2Carousel', 'LC2Carousel.zip');" 
