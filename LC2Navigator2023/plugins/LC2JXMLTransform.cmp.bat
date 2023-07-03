set input=LC2JXMLTransform 
set output=LC2JXMLTransform.zip  
move LC2JXMLTransform.zip LC2JXMLTransform_old.zip  
call powershell.exe "Add-Type -A 'System.IO.Compression.FileSystem'; [IO.Compression.ZipFile]::CreateFromDirectory('LC2JXMLTransform', 'LC2JXMLTransform.zip');" 
