@echo off
set "fileName=%cd%\test.me.bat"
set enc=-encrypt
set dec=-decrypt
echo encrypting
LC2FileEnDeCypter.exe %fileName% %enc%
@echo off
type %fileName%
pause
LC2FileEnDeCypter.exe %fileName% %dec%
@echo off
type %fileName%
timeout 3