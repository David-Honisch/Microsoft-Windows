@echo off
REM Batch file to execute PowerShell script to convert JSON to XML
REM Set the path to the PowerShell script
set SCRIPT_PATH=lc2xml2json.ps1
REM Run the PowerShell script
powershell -NoProfile -ExecutionPolicy Bypass -File "%SCRIPT_PATH%"
REM Pause to keep the window open (optional)