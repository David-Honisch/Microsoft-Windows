set input=LC2Rust 
set output=LC2Rust.zip  
move LC2Rust.zip LC2Rust_old.zip  
call powershell.exe "Add-Type -A 'System.IO.Compression.FileSystem'; [IO.Compression.ZipFile]::CreateFromDirectory('LC2Rust', 'LC2Rust.zip');" 
