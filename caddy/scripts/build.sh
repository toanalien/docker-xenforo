#!/bin/sh

# https://github.com/mholt/caddy/releases
_version='0.11.1'

# caddy
git clone https://github.com/mholt/caddy -b "v$_version" /go/src/github.com/mholt/caddy \
  && cd /go/src/github.com/mholt/caddy \
  && git checkout -b "v$_version"

# plugin helper
GOOS=linux GOARCH=amd64 go get -v github.com/abiosoft/caddyplug/caddyplug
alias caddyplug='GOOS=linux GOARCH=amd64 caddyplug'

# builder dependency
git clone https://github.com/caddyserver/builds /go/src/github.com/caddyserver/builds

# plugins
_plugins='cache cloudflare cors expires realip'
for _plugin in $_plugins; do \
  go get -v $(caddyplug package $_plugin); \
  printf "package caddyhttp\nimport _ \"$(caddyplug package $_plugin)\"" > \
    /go/src/github.com/mholt/caddy/caddyhttp/$_plugin.go ; \
  done

# build
cd /go/src/github.com/mholt/caddy/caddy \
  && git checkout -f \
  && GOOS=linux GOARCH=amd64 go run build.go -goos=$GOOS -goarch=$GOARCH -goarm=$GOARM \
  && mkdir -p /install \
  && mv caddy /install
