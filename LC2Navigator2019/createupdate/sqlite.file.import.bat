@echo off
cls
REM .\bin\LC2Logo.exe
echo %time%
call %cd%\resources\cmd\sqlite.config.bat
@echo off
echo Deleting: %dbfile%
del %dbfile%
call .\resources\cmd\sqlite.fileimport.bat plugins
@echo off
echo SHOW BINARY
call %PRG% %dbfile% "SELECT name||type FROM  %table%;" > .\sql\exportfiles.csv
@echo off
echo SHOW BINARY
call %PRG% %dbfile% "SELECT name FROM  %table% WHERE name='LC2Logo' limit 100;"
echo WRITE BINARY
for /f "usebackq tokens=1-1 delims=," %%b in (.\sql\exportfiles.csv) do (
REM echo %PRG% %dbfile% "INSERT INTO %table%(name,type,img) VALUES('%%~nb','%mime%',readfile('%%b'));"
REM call %PRG% %dbfile% "INSERT INTO %table%(name,type,img) VALUES('%%~nb','%%~xb',readfile('%%b'));"
	call %PRG% %dbfile% "SELECT writefile('%cd%\sql\%%~nb%%~xb',img) FROM  %table% WHERE name='%%~nb';"
)


echo EXPORT BINARY
call %PRG% %dbfile%  ".dump" > %cd%\sql\dbexport.sql
call %PRG% %dbfile% "SELECT name FROM  %table% WHERE name='LC2Logo' limit 100;" > .\sql\out.sql
REM call %PRG% %dbfile%  ./sql/export.sql
call %PRG% %dbfile%  ".read export.sql"
@echo off
echo EXPORT BINARY DONE
@echo on