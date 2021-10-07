@echo off
set fileName=validatedfiles.csv
set vfileName=validatedfiles.csv
dir /b > %fileName%
for /f "usebackq tokens=1-4 delims=|" %%a in ("%fileName%") do (
	LC2CRC32CLI.exe %%a > .\sfv\%%~na.sfv
)
dir /b *.valid.* >%vfileName%
for /f "usebackq tokens=1-4 delims=|" %%a in ("%vfileName%") do (
	LC2CRC32CLI.exe %%a > .\sfv\%%~na.csv.csv
)
move *.sfv .\sfv\
echo done.