FROM golang:1.11.4-alpine3.8 as builder

RUN apk add --no-cache git

COPY . /opt
RUN /opt/scripts/build.sh

FROM alpine:3.8
COPY --from=builder /install/caddy /usr/bin/caddy

RUN set -ex; \
  apk add --no-cache openssh-client git; \
  /usr/bin/caddy --version; \
  /usr/bin/caddy --plugins

EXPOSE 80 443
VOLUME /root/.caddy /root/cache /var/www/html
WORKDIR /var/www/html

COPY . /opt

ENTRYPOINT ["/opt/scripts/entrypoint.sh"]
CMD ["-agree=true", "-log", "stdout"]
