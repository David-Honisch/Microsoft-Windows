@echo off
cls
REM call npm test
REM call npm run test:watch 
REM call npm run tauri build
REM copy "src-tauri\target\release\lc2news.exe" bin\lc2news.exe
REM cd bin\
del jobs.db
start lc2news.exe
cd %~dp0