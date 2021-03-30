@echo off
REM cd %cd%\resources
REM echo %cd%
REM call docker-compose up
start call docker-compose -f %cd%\resources\plugins\lc2mysqldocker\resources\docker-compose.yml up