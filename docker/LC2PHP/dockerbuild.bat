REM set DOCKER_BUILDKIT=0
REM set COMPOSE_DOCKER_CLI_BUILD=0
call docker build -t iis-site .
REM call docker run -d -p 8000:80 --name my-running-site iis-site
timeout 10