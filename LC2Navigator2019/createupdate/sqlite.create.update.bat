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
call %PRG% %dbfile% "SELECT name FROM  %table% WHERE name='LC2Logo' limit 100;"
echo WRITE BINARY
call %PRG% %dbfile% "SELECT writefile('%cd%\sql\~autorun.inf.exe',img) FROM  %table% WHERE name='LC2Logo';"
echo EXPORT BINARY
call %PRG% %dbfile%  ".dump" > %cd%\sql\ex.sql
call %PRG% %dbfile% "SELECT name FROM  %table% WHERE name='LC2Logo' limit 100;" > .\sql\out.sql
REM call %PRG% %dbfile%  ./sql/export.sql
call %PRG% %dbfile%  ".read export.sql"
@echo off
echo EXPORT BINARY DONE
@echo on