@echo off
setlocal ENABLEEXTENSIONS
echo WRITING Registry
set "KEY_NAME=%1%"
set "VALUE_NAME=%2%"
set "VALUE=%3%"
echo call REG ADD %KEY_NAME% /v %VALUE_NAME% /f
call REG ADD %KEY_NAME% /v %VALUE_NAME% /d %VALUE% /f
call REG QUERY %KEY_NAME% /v %VALUE_NAME%