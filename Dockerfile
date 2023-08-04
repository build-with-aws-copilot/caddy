
FROM amazonlinux:2

ARG CADDY_VERSION=v2.6.4
ARG OS=linux

# Install dependencies
RUN yum update -y && \
  yum install golang -y

RUN GOBIN=/usr/local/bin/ go install github.com/caddyserver/xcaddy/cmd/xcaddy@latest

RUN mkdir -p /caddy-build && \
  GOOS=${OS} xcaddy build ${CADDY_VERSION} --with github.com/gamalan/caddy-tlsredis --output /caddy-build/caddy

COPY Caddyfile /etc/caddy/Caddyfile

EXPOSE 80
EXPOSE 443

CMD ["/caddy-build/caddy", "run", "--config", "/etc/caddy/Caddyfile", "--adapter", "caddyfile"]