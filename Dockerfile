
FROM debian:10.6-slim as deploy
LABEL name="deploy"

ARG VERSION="0.2.9" 
ARG BINARY="linux-amd64-levant"

RUN apt-get update && \
    apt-get install -y \
    wget

ADD entrypoint.sh /entrypoint.sh

RUN wget https://github.com/hashicorp/levant/releases/download/${VERSION}/${BINARY} -O /usr/bin/levant &&\
    chmod +x /usr/bin/levant
ENTRYPOINT [ "/entrypoint.sh" ]
