@echo off
REM call docker build -t mattes/rotating-proxy:latest .
call docker build -t david/lc2rotatingtorproxy:latest .
@echo off
timeout 3