@echo off
set input=install\install
set output=install.zip
C:\tools\nsis\makensisw.exe LC2Navigator2020.nsi
REM zip -9 -m -o %output% %input%