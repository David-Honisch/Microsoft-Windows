@echo off
set output=.\~output.license.log.json
cls
REM echo calling
REM curl "http://localhost:7878/license?user_id=root&secret_key=rootpassword"
echo verbose
REM curl -o %output% "http://localhost:7878/license?user_id=root&secret_key=rootpassword"
curl --http1.1 http://localhost:7878/license?user_id=root&secret_key=rootpassword
REM type %output%
