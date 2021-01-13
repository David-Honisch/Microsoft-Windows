@echo off
set exec=..\php\php.exe
set in=csp_js.csv
set out=csp.out.csv
set fout=csp.final.out.csv
dir /s /b cms\assets\*.js > csp_js.csv
type nul > %out%
for /f "usebackq tokens=1-4 delims=," %%a in (%in%) do (
      echo %exec% csp.php %%a
	  %exec% csp.php %%a >> %out%
)
timeout 1
REM type nul > %fout%
REM for /f "usebackq tokens=1-4 delims=," %%a in (%out%) do (
	  REM echo Content-Security-Policy: script-src ''sha256-%%a'' >> %fout%
REM )
REM timeout 3
@echo on