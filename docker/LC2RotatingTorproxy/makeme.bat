mkdir myproject && cd myproject
echo "hello" > hello
echo -e "FROM busybox\nCOPY /hello /\nRUN cat /hello" > Dockerfile
docker build -t helloapp:v1 .

REM Move Dockerfile and hello into separate directories and build a second version of the image (without relying on cache from the last build). Use -f to point to the Dockerfile and specify the directory of the build context:

mkdir -p dockerfiles context
mv Dockerfile dockerfiles && mv hello context
docker build --no-cache -t helloapp:v2 -f dockerfiles/Dockerfile context

REM docker build -t myimage:latest -<<EOF
REM FROM busybox
REM RUN echo "hello world"
REM EOF
