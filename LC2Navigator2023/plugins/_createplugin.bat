@echo off
cls
set input=_createplugin.csv
REM set output=org.letztechance.domain.web.GrabUrls.zip
for /f "usebackq tokens=1-3 delims=;" %%a in ("%input%") do (	
	mkdir "%%a\resources\plugins\%%a"
	mkdir "%%a\resources\plugins\%%a\csv"
	mkdir "%%a\resources\plugins\%%a\import"
	mkdir "%%a\resources\plugins\%%a\menu"
	mkdir "%%a\resources\plugins\%%a\resources"
	mkdir "%%a\resources\sql"
	
	echo creating sql script
	call resources\default.sql.bat "%cd%\%%a\resources\sql\%%a.zip.sql" %%a	
	
	call resources\schema.sql.bat "%cd%\%%a\resources\plugins\%%a\schema.sql" %%a	

	echo creating default config script	
	copy resources\config.bat "%cd%\%%a\resources\plugins\%%a\config.bat"
	call resources\defaultconfig.file.bat "%cd%\%%a\resources\plugins\%%a\config.bat" %%a
	echo copy resources\menu.csv "%cd%\%%a\resources\plugins\%%a\import\menu.csv"
	
	call resources\menu.bat "%cd%\%%a\resources\plugins\%%a\" %%a
	@echo off
	
	

	copy resources\import\import.csv "%cd%\%%a\resources\plugins\%%a\import\import.csv"
	REM echo Reload;menu.csv;execCMD('exec .\\\\resources\\\\plugins\\\\%%a\\\\index.bat .\\\\resources\\\\plugins\\\\%%a\\\\menu.csv', 'out');Reload %%a > "%cd%\%%a\resources\plugins\%%a\import\import.csv"
	REM echo Install requirements;menu.csv;getOpenDialog('#dialog','.\\resources\\plugins\\%%a\\install.html','Install',{ minWidth: 250,  minHeight: 150, width: 400});%%a Install - Please click here to get all required stuff of %%a>> "%cd%\%%a\resources\plugins\%%a\import\import.csv"
	REM echo Install & Launch;menu.csv;evalCMD('.\\resources\\plugins\\%%a\\launch.bat', 'app_cnt');%%a Install - Please click here to get all required stuff of %%a>> "%cd%\%%a\resources\plugins\%%a\import\import.csv"
	REM echo START;docker-compose_up.bat;execCMD('start .\\resources\\plugins\\%%a\\startapp.bat', 'app_cnt');%%a up>> "%cd%\%%a\resources\plugins\%%a\import\import.csv"
	REM echo STOP;docker-compose_down.bat;execCMD('start .\\resources\\plugins\\%%a\\stop.bat', 'app_cnt');%%a  down>> "%cd%\%%a\resources\plugins\%%a\import\import.csv"
	REM echo TEST;docker-compose_up.bat;execCMD('.\\resources\\plugins\\%%a\\test.bat', 'test_cnt');%%a  up>> "%cd%\%%a\resources\plugins\%%a\import\import.csv"
	REM echo more;more.csv;execCMD('exec .\\resources\\plugins\\%%a\\index.bat .\\resources\\plugins\\%%a\\more.csv', 'app_cnt');More %%a commands>> "%cd%\%%a\resources\plugins\%%a\import\import.csv"
	
	copy resources\install.html "%cd%\%%a\resources\plugins\%%a\install.html"
	copy resources\install.js "%cd%\%%a\resources\plugins\%%a\install.js"
	copy resources\config.js "%cd%\%%a\resources\plugins\%%a\config.js"
	
	echo creating default script	
	REM call resources\default.file.bat "%cd%\%%a\resources\plugins\%%a\%%a.bat" %%a	
	REM copy resources\default.file.bat.txt "%cd%\%%a\resources\plugins\%%a\%%a.bat"
	copy resources\index.bat "%cd%\%%a\resources\plugins\%%a\index.bat"
	
	copy resources\resources\index.bat "%cd%\%%a\resources\plugins\%%a\resources\index.bat"
	
	echo call powershell.exe "Add-Type -A 'System.IO.Compression.FileSystem'; [IO.Compression.ZipFile]::CreateFromDirectory('%%a', 'resources\resources.zip');"
	
	REM copy core.cmp.bat "%cd%\%%a.cmp.bat"
	echo set input=%%a > "%cd%\%%a.cmp.bat"
	echo set output=%%a.zip  >> "%cd%\%%a.cmp.bat"
	echo move %%a.zip %%a_old.zip  >> "%cd%\%%a.cmp.bat"
	echo call powershell.exe "Add-Type -A 'System.IO.Compression.FileSystem'; [IO.Compression.ZipFile]::CreateFromDirectory('%%a', '%%a.zip');" >> "%cd%\%%a.cmp.bat"
	
	
)

timeout 3