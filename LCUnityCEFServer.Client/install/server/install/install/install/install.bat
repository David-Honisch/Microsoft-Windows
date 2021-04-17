	@echo off
cls
.\bin\LC2Logo.exe
echo %time%
rem timeout 1 > NUL
set _l=------------------------------------------------------------------
SET TITLE="Install"
setLocal EnableDelayedExpansion
set CLASSPATH="
for /R ./ %%a in (*.jar) do (
	echo %%a
    set CLASSPATH=!CLASSPATH!;%%a
)
set CLASSPATH=!CLASSPATH!"
echo !CLASSPATH!
echo %_l%	
echo %TITLE%
echo %_l%	
echo Checking %TITLE% foldes...
echo %_l%	
echo %_l%
echo %_l%	
echo finishing %TITLE% process..
echo %_l%
echo quit
echo exit
echo Bye
@echo on