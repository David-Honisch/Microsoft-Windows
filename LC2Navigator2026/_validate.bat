@echo off
set fileName=_validatefiles.csv
set vfileName=_v_validatedfiles.csv
set delfileName=_delvalidatedfiles.csv
echo VALIDATING...
call %~dp0LC2CRC32CLI.exe %~dp0LC2Navigator2026install.exe > %~dp0LC2Navigator2026_install.exe-crc.sfv
echo VALIDATING  app
dir /b app\*.zip > %fileName%
for /f "usebackq tokens=1-4 delims=|" %%a in ("%fileName%") do (
	%~dp0LC2CRC32CLI.exe app\%%a > %~dp0app\%%~na%%~xa-crc.sfv
)
dir /b release-builds\lc2search-win32-x64\*.zip > %fileName%
for /f "usebackq tokens=1-4 delims=|" %%a in ("%fileName%") do (
	%~dp0LC2CRC32CLI.exe release-builds\lc2search-win32-x64\%%a > %~dp0release-builds\lc2search-win32-x64\%%~na%%~xa-crc.sfv
)

dir /b plugins\*.zip > %fileName%
for /f "usebackq tokens=1-4 delims=|" %%a in ("%fileName%") do (
	%~dp0LC2CRC32CLI.exe plugins\%%a > %~dp0plugins\%%~na%%~xa-crc.sfv
)
dir /b plugins\tools\*.zip > %fileName%
for /f "usebackq tokens=1-4 delims=|" %%a in ("%fileName%") do (
	%~dp0LC2CRC32CLI.exe plugins\tools\%%a > %~dp0plugins\tools\%%~na%%~xa-crc.sfv
)
dir /b plugins\container\*.zip > %fileName%
for /f "usebackq tokens=1-4 delims=|" %%a in ("%fileName%") do (
	%~dp0LC2CRC32CLI.exe plugins\container\%%a > %~dp0plugins\container\%%~na%%~xa-crc.sfv
)
dir /b plugins\db\*.zip > %fileName%
for /f "usebackq tokens=1-4 delims=|" %%a in ("%fileName%") do (
	%~dp0LC2CRC32CLI.exe plugins\db\%%a > %~dp0plugins\db\%%~na%%~xa-crc.sfv
)
REM dir /b plugins\data\*.zip > %fileName%
REM for /f "usebackq tokens=1-4 delims=|" %%a in ("%fileName%") do (
	REM LC2CRC32CLI.exe plugins\data\%%a > %~dp0plugins\data\%%~na%%~xa-crc.sfv
REM )
REM dir /b plugins\media\*.zip > %fileName%
REM for /f "usebackq tokens=1-4 delims=|" %%a in ("%fileName%") do (
	REM LC2CRC32CLI.exe plugins\media\%%a > %~dp0plugins\media\%%~na%%~xa-crc.sfv
REM )
REM dir /b plugins\container\*.zip > %fileName%
REM for /f "usebackq tokens=1-4 delims=|" %%a in ("%fileName%") do (
	REM LC2CRC32CLI.exe plugins\container\%%a > %~dp0plugins\container\%%~na%%~xa-crc.sfv
REM )
REM dir /b plugins\lang\*.zip > %fileName%
REM for /f "usebackq tokens=1-4 delims=|" %%a in ("%fileName%") do (
	REM LC2CRC32CLI.exe plugins\lang\%%a > %~dp0plugins\lang\%%~na%%~xa-crc.sfv
REM )
REM dir /b plugins\tools\*.zip > %fileName%
REM for /f "usebackq tokens=1-4 delims=|" %%a in ("%fileName%") do (
	REM LC2CRC32CLI.exe plugins\tools\%%a > %~dp0plugins\tools\%%~na%%~xa-crc.sfv
REM )
REM dir /b plugins\web\*.zip > %fileName%
REM for /f "usebackq tokens=1-4 delims=|" %%a in ("%fileName%") do (
	REM LC2CRC32CLI.exe plugins\web\%%a > %~dp0plugins\web\%%~na%%~xa-crc.sfv
REM )
REM dir /b plugins\java\*.zip > %fileName%
REM for /f "usebackq tokens=1-4 delims=|" %%a in ("%fileName%") do (
	REM LC2CRC32CLI.exe plugins\java\%%a > %~dp0plugins\java\%%~na%%~xa-crc.sfv
REM )
REM dir /b plugins\db\mongodb\*.zip > %fileName%
REM for /f "usebackq tokens=1-4 delims=|" %%a in ("%fileName%") do (
	REM LC2CRC32CLI.exe plugins\db\mongodb\%%a > %~dp0plugins\db\mongodb\%%~na%%~xa-crc.sfv
REM )
echo done.