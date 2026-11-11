@echo off
call docker build -t lc2opencalendar .
call docker run -d --name lc2opencalendar -p 8080:8080 -v lc2opencalendar-data:/data --restart unless-stopped lc2opencalendar
REM Update
REM git pull
REM docker build -t lc2opencalendar .
REM docker rm -f lc2opencalendar
REM docker run -d --name lc2opencalendar -p 8080:8080 -v lc2opencalendar-data:/data --restart unless-stopped lc2opencalendar