LC2Docker-rotating-proxy
=====================
``
Docker Container
-------------------------------------
                        <-> Polipo 1 <-> Tor Proxy 1
Client <---->  HAproxy  <-> Polipo 2 <-> Tor Proxy 2
                        <-> Polipo n <-> Tor Proxy n
`

__Why:__ Simulate lots of IP addresses with one single endpoint for your client.
Load-balancing by HAproxy.

Usage
-----

```bash
# build docker container
call docker build -t david/lc2rotatingtorproxy:latest .

# ... or pull docker container
docker pull mattes/rotating-proxy:latest

# start docker container
docker run -d -p 5566:5566 -p 4444:4444 --env tors=25 david/lc2rotatingtorproxy

# test with ...
curl --proxy 127.0.0.1:5566 https://api.my-ip.io/ip

# monitor
http://127.0.0.1:4444/haproxy?stats
```
Sources:
----------------

 * [Tor Manual](https://www.torproject.org/docs/tor-manual.html.en)
 * [Tor Control](https://www.thesprawl.org/research/tor-control-protocol/)
 * [HAProxy Manual](http://cbonte.github.io/haproxy-dconv/configuration-1.5.html)
 * [Polipo](http://www.pps.univ-paris-diderot.fr/~jch/software/polipo/)

--------------

Please note: Tor offers a SOCKS Proxy only. In order to allow communication
from HAproxy to Tor, Polipo is used to translate from HTTP proxy to SOCKS proxy.
HAproxy is able to talk to HTTP proxies only.

Big thanks to
[![Docker Pulls](https://img.shields.io/docker/pulls/mattes/rotating-proxy.svg)](https://hub.docker.com/r/mattes/rotating-proxy/)