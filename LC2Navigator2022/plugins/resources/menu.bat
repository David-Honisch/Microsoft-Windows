@echo off
set menuFile=%1menu.csv
set pluginName=%2
echo %menuFile% !!!!!!!!!!!
type nul>%menuFile%
echo Reload;menu.csv;execCMD('exec .\\resources\\plugins\\%pluginName%\\index.bat .\\resources\\plugins\\%pluginName%\\menu.csv', 'out');Reload this view>>%menuFile%
echo Install requirements;menu.csv;getOpenDialog('#dialog','.\\resources\\plugins\\%pluginName%\\install.htm','Install',{ minWidth: 250,  minHeight: 150, width: 400});%pluginName% Install - Please click here to get all required stuff>>%menuFile%
echo %pluginName% Table;menu.csv;window.location='list.html?db=%pluginName%';Show %pluginName% Table>>%menuFile%
echo Show %pluginName% UI;menu.csv;getExtFile('file://'+__dirname+'\\..\\..\\..\\resources\\plugins\\%pluginName%\\%pluginName%.html');%pluginName% Main View>>%menuFile%
echo Show %pluginName% UI v.2.0;menu.csv;getExtFile('.\\resources\\plugins\\%pluginName%\\%pluginName%.html');%pluginName% Main View>>%menuFile%
echo %pluginName% Menu v.1.0;menu.csv;execCMD('exec.bat .\\resources\\plugins\\%pluginName%\\index.bat .\\resources\\plugins\\%pluginName%\\menu.csv', 'app_cnt');%pluginName% Main Menu>>%menuFile%
echo %pluginName% Core Show Process and Kill;menu.csv;execCMD('exec.bat .\\resources\\plugins\\%pluginName%\\resources\\index.bat .\\resources\\plugins\\%pluginName%\\menu\\menu.core.csv', 'app_cnt');%pluginName% Main Menu>>%menuFile%
echo %pluginName% Extended Test  v.1.0;menu.csv;execCMD('exec.bat .\\resources\\plugins\\%pluginName%\\index.bat .\\resources\\plugins\\%pluginName%\\menu\\menu.ext.csv', 'app_cnt');%pluginName% Main Menu>>%menuFile%



REM echo Reload;menu.csv;execCMD('exec .\\resources\\plugins\\%pluginName%\\index.bat .\\resources\\plugins\\%pluginName%\\menu.csv', 'cnt');Reload this view >>%menuFile%
REM echo Install requirements;menu.csv;getExtFile('file://'+__dirname+'\\..\\..\\..\\resources\\plugins\\%pluginName%\\install.html',400,600);%pluginName% Install - Please click here to get all required stuff >>%menuFile%
REM echo Show UI;menu.csv;getExtFile('file://'+__dirname+'\\..\\..\\..\\resources\\plugins\\%pluginName%\\%pluginName%.html');%pluginName% Main View>>%menuFile%
REM echo URLS %pluginName% Menu v.1.0;menu.csv;execCMD('exec.bat .\\resources\\plugins\\%pluginName%\\%pluginName%.bat .\\resources\\plugins\\%pluginName%\\menu.csv', 'core_cnt');%pluginName% Main Menu>>%menuFile%
REM for /f "usebackq tokens=1-4 delims=|" %pluginName% in ("%~dp0menu.csv") do (
	REM LC2CRC32CLI.exe %pluginName% > .\sfv\%%~na.sfv
	REM echo %%a;%%b;%%c
	REM echo %%a;%%b;%%c >>%menuFile%
	
REM )

REM Reload;menu.csv;execCMD('exec .\\resources\\plugins\\graburls\\graburls.bat .\\resources\\plugins\\graburls\\menu.csv', 'cnt');Reload this view
REM Install requirements;menu.csv;getExtFile('file://'+__dirname+'\\..\\..\\..\\resources\\plugins\\graburls\\install.html',400,600);Graburls Install - Please click here to get all required stuff
REM Show UI;menu.csv;getExtFile('file://'+__dirname+'\\..\\..\\..\\resources\\plugins\\graburls\\graburls.html');Graburls Main View
REM URLS Graburls Menu v.1.0;menu.csv;execCMD('exec.bat .\\resources\\plugins\\graburls\\graburls.bat .\\resources\\plugins\\graburls\\menu.csv', 'core_cnt');Graburls Main Menu
echo %menuFile% !!!!!!!!!!! done