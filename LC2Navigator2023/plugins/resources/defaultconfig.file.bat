@echo off
set "target=%1"
set "name=%2"
echo OUT:%target%
echo SET "LT=^<"> %target%
echo SET "RT=^>">> %target%
echo set plugin=%name%>> %target%
echo set plugin=LC2Oracle23C>> %target%
echo set table=%plugin%>> %target%
echo set plugintable=%plugin%_data>> %target%
echo set plugindatatable=%plugin%_procdata>> %target%
echo set "table=%plugin%">> %target%
echo set title=%plugin% Plugin>> %target%
echo set version=v.0.1.22>> %target%
echo set "defaultFile=%~dp0csv\default.csv">> %target%
echo set "tabFile=%~dp0csv\tabs.csv">> %target%
echo set "dropdownFile=%~dp0csv\dropdown.csv">> %target%
echo set "helpFile=%~dp0csv\help.csv">> %target%
echo REM set "helpFile=%~dp0..\..\csv\help.csv">> %target%
echo set "importFile=%~dp0csv\%plugin%.csv">> %target%
echo set "defaultFile=%~dp0..\..\csv\default.csv">> %target%
echo set "workFile=%~dp0csv\%plugin%work.csv">> %target%
echo set "dataFile=%~dp0csv\%plugin%data.csv">> %target%
echo set "selectFile=%~dp0csv\select.csv">> %target%
echo set "gresdir=%~dp0..\..\..\..\resources\">> %target%
echo set "resdir=%~dp0\resources\">> %target%
echo set "getlink=%gresdir%cmd\link.bat">> %target%
echo set "sexec=%gresdir%app\sqlite\sqlite3.exe">> %target%
echo set "dbfile=%resdir%..\..\..\%plugin%.db">> %target%
echo set "outFile=%1">> %target%
echo set openjs=%LT% script%RT%>> %target%
echo set closejs=%LT%/script%RT%>> %target%
echo ::global startup>> %target%
echo set gstartup=C:\ProgramData\Microsoft\Windows\Start Menu\Programs\StartUp>> %target%
echo ::current user startup>> %target%
echo set startup=%USERPROFILE%\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup>> %target%