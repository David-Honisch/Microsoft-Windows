@echo off
set fileName=_validatefiles.csv
set vfileName=_v_validatedfiles.csv
set delfileName=_delvalidatedfiles.csv
REM dir /b > %fileName%
REM for /f "usebackq tokens=1-4 delims=|" %%a in ("%fileName%") do (
	REM LC2CRC32CLI.exe %%a > %~dp0sfv\%%~na%%~xa-crc.sfv
	REM move %~dp0sfv\%%~na%%~xa-crc.sfv .\sfv\
REM )
dir /b plugins\*.zip > %fileName%
for /f "usebackq tokens=1-4 delims=|" %%a in ("%fileName%") do (
	LC2CRC32CLI.exe plugins\%%a > %~dp0%%~na%%~xa-crc.sfv
	LC2CRC32CLI.exe plugins\%%a > %~dp0sfv\%%~na%%~xa-crc.sfv
	REM move %~dp0sfv\%%~na%%~xa-crc.sfv .\sfv\
)
REM dir /b /s *.sfv > %delfileName%
REM for /f "usebackq tokens=1-4 delims=|" %%a in ("%delfileName%") do (
	REM move %%a .\sfv\
REM )
REM dir /b *.valid.* >%vfileName%
REM for /f "usebackq tokens=1-4 delims=|" %%a in ("%vfileName%") do (
	REM LC2CRC32CLI.exe %%a > .\sfv\%%~na.csv.csv
REM )
REM move *.sfv .\sfv\
REM copy .\sfv\ .\plugins\
echo done.