@echo off
set input=_createplugin.csv
REM set output=org.letztechance.domain.web.GrabUrls.zip
for /f "usebackq tokens=1-3 delims=;" %%a in ("%input%") do (	
	mkdir %%a\resources\plugins\%%a
	mkdir %%a\resources\plugins\%%a\import
	mkdir %%a\resources\plugins\%%a\menu
	mkdir %%a\resources\plugins\%%a\resources
	mkdir %%a\resources\sql
	
	echo creating sql script
	call resources\default.sql.bat "%cd%\%%a\resources\sql\%%a.zip.sql" %%a	
	
	call resources\schema.sql.bat "%cd%\%%a\resources\plugins\%%a\schema.sql" %%a	

	echo creating default config script	
	copy resources\config.bat "%cd%\%%a\resources\plugins\%%a\config.bat"
	call resources\defaultconfig.file.bat "%cd%\%%a\resources\plugins\%%a\config.bat" %%a
	echo copy resources\menu.csv "%cd%\%%a\resources\plugins\%%a\menu.csv"
	
	call resources\menu.bat "%cd%\%%a\resources\plugins\%%a\" %%a
	@echo off
	
	

	copy resources\import\import.csv "%cd%\%%a\resources\plugins\%%a\import\import.csv"
	copy resources\install.html "%cd%\%%a\resources\plugins\%%a\install.html"
	copy resources\install.js "%cd%\%%a\resources\plugins\%%a\install.js"
	copy resources\config.js "%cd%\%%a\resources\plugins\%%a\config.js"
	
	echo creating default script	
	REM call resources\default.file.bat "%cd%\%%a\resources\plugins\%%a\%%a.bat" %%a	
	copy resources\default.file.bat.txt "%cd%\%%a\resources\plugins\%%a\%%a.bat"
	copy resources\index.bat "%cd%\%%a\resources\plugins\%%a\index.bat"
	
	copy resources\resources\index.bat "%cd%\%%a\resources\plugins\%%a\resources\index.bat"
	
	REM copy core.cmp.bat "%cd%\%%a.cmp.bat"
	echo set input=%%a > "%cd%\%%a.cmp.bat"
	echo set output=%%a.zip  >> "%cd%\%%a.cmp.bat"
	echo move %%a.zip %%a_old.zip  >> "%cd%\%%a.cmp.bat"
	echo call powershell.exe "Add-Type -A 'System.IO.Compression.FileSystem'; [IO.Compression.ZipFile]::CreateFromDirectory('%%a', '%%a.zip');" >> "%cd%\%%a.cmp.bat"
	
	
)

timeout 3