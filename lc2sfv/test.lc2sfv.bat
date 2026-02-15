@echo off
setlocal enabledelayedexpansion
REM Set the directory where the files will be created
set "output_dir=.\"
REM Create the output directory if it doesn't exist
if not exist "%output_dir%" mkdir "%output_dir%"
REM Get the current date and time
for /f "tokens=2 delims==" %%I in ('wmic os get localdatetime /value') do set datetime=%%I
set year=!datetime:~0,4!
set month=!datetime:~4,2!
set day=!datetime:~6,2!
set hour=!datetime:~8,2!
set minute=!datetime:~10,2!
set second=!datetime:~12,2!
set millisecond=!datetime:~14,3!
REM Format the date and time
set timestamp=%year%%month%%day%%hour%%minute%%second%%millisecond%
REM Create a file with the current timestamp
set "filename=%output_dir%\file_%timestamp%.txt"
set outFile=lc2crcdirs.csv
REM dir /ad>appdirs.csv
set exeFile=%~dp0lc2sfv.exe
REM dir /b /s *.exe>%outFile%
for /f "usebackq tokens=1-5 delims=;" %%a in ("%outFile%") do (
	REM echo call %exeFile% %%~na%%~xa %%a %%~na%%~xa.lnk
	echo call writefile.bat %%a
	call writefile.bat %%a
	REM copy checksum.sfv 
)