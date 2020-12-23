@echo off
set input=install\install
set output=install.zip
C:\tools\nsis\makensisw.exe LCUnityServer.nsi
REM zip -9 -m -o %output% %input%