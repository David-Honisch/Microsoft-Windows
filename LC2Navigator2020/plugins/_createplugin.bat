@echo off
set input=_createplugin.csv
REM set output=org.letztechance.domain.web.GrabUrls.zip
for /f "usebackq tokens=1-3 delims=;" %%a in ("%input%") do (	
	mkdir %%a\resources\plugins\%%a
	mkdir %%a\resources\sql
	echo creating sql script
	call resources\default.sql.bat "%cd%\%%a\resources\sql\%%a.zip.sql" %%a
	echo creating sql script done
)

timeout 3