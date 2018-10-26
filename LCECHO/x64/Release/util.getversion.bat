@echo off
Set "cecho=%cd%\projects\HLECHO\x64\Release\cecho_x64.exe"
Set "batdir=.\resources\bat"
call %batdir%\setconfig.bat
sqlcmd -S %dbserver% -U %dbuser% -P %dbpwd% -Q "SELECT @@VERSION"
@echo on