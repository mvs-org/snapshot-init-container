FROM alpine:3

RUN apk add --no-cache \
    bash \
    wget \
    tar \
    gzip \
    zstd \
    p7zip

COPY entrypoint.sh /
RUN  chmod 755  entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
CMD []
