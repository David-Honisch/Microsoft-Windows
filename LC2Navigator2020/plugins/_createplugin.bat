@echo off
set input=_createplugin.csv
REM set output=org.letztechance.domain.web.GrabUrls.zip
for /f "usebackq tokens=1-3 delims=;" %%a in ("%input%") do (	
	mkdir %%a\resources\plugins\%%a
	mkdir %%a\resources\plugins\%%a\install
	mkdir %%a\resources\plugins\%%a\menu
	mkdir %%a\resources\plugins\%%a\resources
	mkdir %%a\resources\sql
	
	echo creating sql script
	call resources\default.sql.bat "%cd%\%%a\resources\sql\%%a.zip.sql" %%a	

	echo creating default config script	
	copy resources\config.bat "%cd%\%%a\resources\plugins\%%a\config.bat"
	call resources\defaultconfig.file.bat "%cd%\%%a\resources\plugins\%%a\config.bat" %%a
	copy resources\menu.csv "%cd%\%%a\resources\plugins\%%a\menu.csv"
	copy resources\install\install.csv "%cd%\%%a\resources\plugins\%%a\install\install.csv"
	copy resources\install.html "%cd%\%%a\resources\plugins\%%a\install.html"
	copy resources\install.js "%cd%\%%a\resources\plugins\%%a\install.js"
	copy resources\config.js "%cd%\%%a\resources\plugins\%%a\config.js"
	
	echo creating default script	
	REM call resources\default.file.bat "%cd%\%%a\resources\plugins\%%a\%%a.bat" %%a	
	copy resources\default.file.bat.txt "%cd%\%%a\resources\plugins\%%a\%%a.bat"
	copy resources\default.file.bat.txt "%cd%\%%a\resources\plugins\%%a\index.bat"
	
	copy resources\resources\index.bat "%cd%\%%a\resources\plugins\%%a\resources\index.bat"
	
	copy core.cmp.bat "%cd%\%%a.cmp.bat"
	
)

timeout 3