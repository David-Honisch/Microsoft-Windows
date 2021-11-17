@echo off
set fileName=files.csv
set vfileName=validatedfiles.csv
dir /b > %fileName%
for /f "usebackq tokens=1-4 delims=|" %%a in ("%fileName%") do (
	LC2CRC32CLI.exe %%a > %~dp0sfv\%%~na.%%~xa-crc.sfv
)
REM dir /b *.valid.* >%vfileName%
REM for /f "usebackq tokens=1-4 delims=|" %%a in ("%vfileName%") do (
	REM LC2CRC32CLI.exe %%a > .\sfv\%%~na.csv.csv
REM )
move *.sfv .\sfv\
echo done.