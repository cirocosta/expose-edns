# expose-edns

> Exposes Docker Embedded DNS

For Docker 1.10+ now containers have an embedded DNS server at `127.0.0.11:53/udp`. That server is responsible for resolving names/aliases of container connected to the same network. 

This image uses `socat` to expose that server (which listens on `127.0.0.11`) on `0.0.0.0:53`.

## Usage

See `./test.sh`

[![Build Status](https://travis-ci.org/cirocosta/expose-edns.svg?branch=master)](https://travis-ci.org/cirocosta/expose-edns)


