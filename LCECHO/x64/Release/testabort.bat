@echo off
Set "cecho=%cd%\cecho_x64.exe"
SET ISVALID=false
if %errorlevel% neq 0 (
echo ERROR !!!
%cecho% {red on grey}====^>ERROR^<===={#}{\n}
echo Please click to abort. Started from GUI check config and try again.
pause
exit /b %errorlevel%
) else (
	REM echo 'SUCCESS'
	%cecho% {02}SUCCESS{#}{\n}
	SET ISVALID=true
)
@echo on