@echo off
cls
call qdb.bat "select * from jobs"
call qdb.bat <"out.sql"
call qdb.bat "select * from jobs"