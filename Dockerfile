ARG VERSION="0.2.9" 

FROM jrasell/levant:${VERSION} as deploy
LABEL name="deploy"

ADD entrypoint.sh /entrypoint.sh

ENTRYPOINT [ "/entrypoint.sh" ]