@echo off
Set "batdir=%cd%"
Set "cecho=%cd%\cecho_x64.exe"
rem Author:David Honisch
rem ============= PLEASE CONFIGURE THE ENVIRONMENT =============
%cecho% {01}======= SET CONFIG ============{#}{\n}
@echo off
%cecho% {01}======= CHECK IF PROPERTIES REGISTERED ============{#}{\n}
REM echo ======= CHECK IF PROPERTIES REGISTERED ============
call %batdir%\getregvalue.bat "HKEY_CURRENT_USER\SOFTWARE\LETZTECHANCE.ORG\LC2CECHO\app" "user"
IF %result% == "" (
REM echo NO REGISTRATION FOUND. REGISTERING default properties.
%cecho% {01}======= NO REGISTRATION FOUND. REGISTERING default properties. ============{#}{\n}
call %batdir%\register.config.bat
echo get register application
) ELSE (
	%cecho% {02}======= REGISTRATION FOUND ==========={#}{\n}
)
call %batdir%\getregvalue.bat "HKEY_CURRENT_USER\SOFTWARE\LETZTECHANCE.ORG\LC2CECHO\app" "user"
REM echo User found: %result%
%cecho% User found:{02}%result%{#}{\n}
rem pause
set "LINE====================================================="
set "dbuser=%result%"
call %batdir%\getregvalue.bat "HKEY_CURRENT_USER\SOFTWARE\LETZTECHANCE.ORG\LC2CECHO\app" "password"
set "dbpwd=%result%"
set "db=import"
call %batdir%\getregvalue.bat "HKEY_CURRENT_USER\SOFTWARE\LETZTECHANCE.ORG\LC2CECHO\app" "dbfinal"
REM echo Database found: %result%
%cecho% Database found:{02}%result%{#}{\n}
set "dbfinal=%result%"
rem pause
call %batdir%\getregvalue.bat "HKEY_CURRENT_USER\SOFTWARE\LETZTECHANCE.ORG\LC2CECHO\app" "server"
REM echo Server found: %result%
%cecho% Server found:{02}%result%{#}{\n}
set "databaseserver=%result%"
call %batdir%\getregvalue.bat "HKEY_CURRENT_USER\SOFTWARE\LETZTECHANCE.ORG\LC2CECHO\app" "instance"
REM echo Instance found: %result%
%cecho% Instance found:{02}%result%{#}{\n}
set "databaseinstance=%result%"
call %batdir%\getregvalue.bat "HKEY_CURRENT_USER\SOFTWARE\LETZTECHANCE.ORG\LC2CECHO\app" "port"
REM echo Port found: %result%
%cecho% Port found:{02}%result%{#}{\n}
set "sqlport=%result%"
set "dbserver=%databaseserver%\%databaseinstance%"
set "backupdb=c:\x\x.bak"
set "restoredb=c:\x\x2.bak"
set "sqlconfigv1=%cd%\x.sql"
set "sqlconfigv2=%cd%\x2.sql"
set "jsonConfig=%cd%\config\xMain.json"
rem ============= EOF CONFIGURE THE ENVIRONMENT =============
