@echo off
REM cd %cd%\resources
REM echo %cd%
REM call docker-compose up
scriptrunner -appvscript docker-compose -f %cd%\resources\plugins\lc2mysqldocker\resources\docker-compose.yml up