@echo off
REM # monitor
REM start http://127.0.0.1:4444/haproxy?stats
for /f "usebackq tokens=1-4 delims=," %%a in ("urls.csv") do (
    echo %%a
	call curl --proxy 127.0.0.1:5566 https://heise.de
	call curl --proxy 127.0.0.1:5566 https://api.my-ip.io/ip
	call curl --proxy 127.0.0.1:5566 https://youtube.de
	call curl --proxy 127.0.0.1:5566 https://youtube.com
)

REM start http://127.0.0.1:4444/haproxy?stats
