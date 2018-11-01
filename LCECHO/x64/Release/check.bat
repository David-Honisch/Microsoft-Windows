@echo off
cls
Set "cecho=%cd%\cecho_x64.exe"
Set "batdir=%cd%"
call %batdir%\setconfig.bat
set "exportFile=%cd%\import\export.csv"
REM echo ^<h2^>Reading Java Version^</h2^>
%cecho% {blue on black}^<h2^>Reading Java Version^</h2^>{#}{\n}

Set "JV="
%cecho% {blue on black}Java Check{#}{\n}
For /F "Tokens=3" %%A In ('java -version 2^>^&1') Do If Not Defined JV Set "JV=%%~A"
%cecho% {blue on black}^<h4^>Searching^</h4^>{#}{\n}
If /I "%JV%"=="not" (Echo Java is not installed) Else (
%cecho% {blue on black}^<h1^>Java Version^</h1^>{#}{\n}
%cecho% {blue on black}^<h2^>%JV%^</h2^>{#}{\n}
echo detected.
)
REM echo ^<h2^>Reading SQL Server Version^</h2^>
%cecho% {blue on black}^<h2^>Reading SQL Server Version^</h2^>{#}{\n}
REM call %batdir%\util.htmlbreak.bat
rem call app\util.getversion.bat rem | findstr Microsoft
%cecho% {blue on black}^<h2^>Connecting SQL Server Version^</h2^>{#}{\n}
call %batdir%\util.getversion.bat
REM %batdir%\util.getversion.bat | findstr Microsoft
@echo off
call %batdir%\testabort.bat
@echo off
	if %ISVALID% == false (	
		echo retrying get version to see the connection error cause
		call %batdir%\util.getversion.bat
		@echo off
		echo ERROR. Terminating now...
		%cecho% {red on black}INITIALIZING SQLCMD IMPORT{#}{\n}
		exit
	)
@echo off
echo Check finished.
REM call %batdir%\util.htmlbreak.bat
REM call %batdir%\util.createhyperlinkext.bat "Open Log" "homecnt" "viewlog.bat"
@echo off
REM echo ^<h2^>Reading Export File^</h2^>
%cecho% {blue on black}^<h2^>Reading Export File^</h2^>{#}{\n}
echo Is %exportFile% existing ?
if exist %exportFile% (
	echo FOUND
)
%cecho% {green on black}^<h2^>Check done^</h2^>{#}{\n}
timeout 3 > NUL
