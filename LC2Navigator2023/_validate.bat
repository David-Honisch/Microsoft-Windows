@echo off
set fileName=_validatefiles.csv
set vfileName=_v_validatedfiles.csv
set delfileName=_delvalidatedfiles.csv
dir /b > %fileName%
REM for /f "usebackq tokens=1-4 delims=|" %%a in ("%fileName%") do (
	REM LC2CRC32CLI.exe %%a > %~dp0sfv\%%~na%%~xa-crc.sfv
	REM move %~dp0sfv\%%~na%%~xa-crc.sfv .\sfv\
REM )
dir /b plugins\*.zip > %fileName%
for /f "usebackq tokens=1-4 delims=|" %%a in ("%fileName%") do (
	LC2CRC32CLI.exe plugins\%%a > %~dp0sfv\%%~na%%~xa-crc.sfv
	REM move %~dp0sfv\%%~na%%~xa-crc.sfv .\sfv\
)
dir /b /s *.sfv > %delfileName%
for /f "usebackq tokens=1-4 delims=|" %%a in ("%delfileName%") do (
	move %%a .\sfv\
)
REM dir /b *.valid.* >%vfileName%
REM for /f "usebackq tokens=1-4 delims=|" %%a in ("%vfileName%") do (
	REM LC2CRC32CLI.exe %%a > .\sfv\%%~na.csv.csv
REM )
move *.sfv .\sfv\
copy .\sfv\ .\plugins\
echo done.