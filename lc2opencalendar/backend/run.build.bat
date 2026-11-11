@echo off
REM call go clean
REM go install github.com/tc-hib/go-winres@latest
call go-winres simply --icon icon.png
call go build
REM call node build-release.mjs
REM call docker build -t lc2opencalendar .
REM call docker run -d --name lc2opencalendar -p 8080:8080 -v lc2opencalendar-data:/data --restart unless-stopped lc2opencalendar
REM Update
REM git pull
REM docker build -t lc2opencalendar .
REM docker rm -f lc2opencalendar
REM docker run -d --name lc2opencalendar -p 8080:8080 -v lc2opencalendar-data:/data --restart unless-stopped lc2opencalendar