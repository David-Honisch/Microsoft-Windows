@echo off
set exec=D:\xampp\php\php.exe
set in=csp_js.csv
set out=csp.out.csv
set fout=csp.final.out.csv
echo search js files
dir /s /b *.js > %in%
echo reset output file
type nul>%out%
for /f "usebackq tokens=1-4 delims=," %%a in (%in%) do (
      echo %exec% csp.php %%a
	  %exec% csp.php %%a >> %%a.js.txt
)
timeout 1
REM type nul > %fout%
REM for /f "usebackq tokens=1-4 delims=," %%a in (%out%) do (
	  REM echo Content-Security-Policy: script-src ''sha256-%%a'' >> %fout%
REM )
REM timeout 3
@echo on