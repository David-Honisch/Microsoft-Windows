@echo off
REM call Get-ChildItem cert:\CurrentUser\My -codesigning
REM call Set-AuthenticodeSignature ‹Script.ps1› @(Get-ChildItem cert:\CurrentUser\My -codesigning)[0]
REM Set-ExecutionPolicy Unrestricted
set "syspath=c:\Windows\SysWOW64\WindowsPowerShell\v1.0"
REM %syspath%\PowerShell -NoProfile -ExecutionPolicy Bypass -Command "& {Start-Process PowerShell -ArgumentList '-NoProfile -ExecutionPolicy Bypass -File "".\getEventViewer.ps1""' -Verb RunAs}"
REM %syspath%\Powershell.exe -executionpolicy remotesigned -File  .\getEventViewer.ps1
%syspath%\PowerShell -NoProfile -ExecutionPolicy Bypass -Command "& '.\getEventViewer.ps1'"
pause