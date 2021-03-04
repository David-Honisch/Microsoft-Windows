@echo off
cls
call config.bat
REM set host=https://www.letztechance.org
setLocal EnableDelayedExpansion
set CURRENT_DIR=%cd%
REM echo %cd%\lib
set "CLASSPATH=."
 for /R %cd%\ %%a in (*.jar) do (
   set "CLASSPATH=!CLASSPATH!;%%a"
 )
REM echo !CLASSPATH!
REM echo CALLING...
java -jar %jarfile% -url "%host%%indexapi%" -user %user% -password %pwd% - port:443
@echo off
REM echo call java done

timeout 10
@echo on