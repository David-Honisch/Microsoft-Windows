@echo off
set input=install\install
set output=install.zip
C:\tools\nsis\makensisw.exe LC2Navigator2023.nsi
C:\tools\nsis\makensisw.exe LC2Navigator2023install.nsi
REM zip -9 -m -o %output% %input%