@echo off
call %batdir%\setconfig.bat
%cecho% {green on black}^<h2^>Java %JV%^</h2^>{#}{\n}
REM set DOCKER_BUILDKIT=0
REM set COMPOSE_DOCKER_CLI_BUILD=0
REM call docker build -t iis-site .
call docker run -d -p 8000:80 --name my-running-site lc2iis
timeout 10