FROM alpine:3

RUN apk add --no-cache \
    bash \
    wget \
    tar \
    gzip \
    zstd \
    p7zip

COPY entrypoint.sh /
ENTRYPOINT ["/entrypoint.sh"]
CMD []
