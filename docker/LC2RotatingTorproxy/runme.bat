call docker run -d -p 5566:5566 -p 4444:4444 --env tors=25 mattes/rotating-proxy
REM call docker run -d -p 5566:5566 -p 4444:4444 --env tors=25 david/lc2rotatingtorproxy:latest
REM # test with ...
call curl --proxy 127.0.0.1:5566 https://api.my-ip.io/ip
REM # monitor
start http://127.0.0.1:4444/haproxy?stats
timeout 3