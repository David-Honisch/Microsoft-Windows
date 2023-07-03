@echo off
cls
call "%cd%\resources\cmd\config.bat"
@echo off
set out=getlibx.xml

REM --------------------------------------------------------
type nul>%out%
set LINE=-------------------------------------------------
REM for /f "usebackq tokens=1-3 delims=;" %%a in (libs\*.jar) do (
for %%a in (libs\*.jar) do (
	echo CREATING %%a
	echo ^<get src="https://raw.githubusercontent.com/David-Honisch/Microsoft-Windows/master/LC2Navigator2022/plugins/libs/%%~na.jar" dest="${basedir}/../libs/" verbose="false" usetimestamp="true"/^>>>%out%
)
REM call powershell.exe "Add-Type -A 'System.IO.Compression.FileSystem'; [IO.Compression.ZipFile]::CreateFromDirectory('%input%', '%output%');"
@echo off
timeout 3