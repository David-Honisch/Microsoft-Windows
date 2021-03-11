@echo off
set "db=%cd%\release-builds\lc2search-win32-ia32\resources\lc.db"
REM set "exec=%cd%\resources\app\sqlite\SQLite3.exe"
echo start %db%
start %db%
timeout 3
@echo on