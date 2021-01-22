@echo off
set input=_createplugin.csv
REM set output=org.letztechance.domain.web.GrabUrls.zip
for /f "usebackq tokens=1-3 delims=;" %%a in ("%input%") do (	
	mkdir %%a\resources\plugins\%%a
)