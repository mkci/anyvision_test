FROM alpine:3.11 as builder
  
ENV NGINX_VERSION nginx-1.16.1

RUN apk --update add openssl-dev wget build-base && \
    wget -O /usr/local/bin/gosu "https://github.com/tianon/gosu/releases/download/1.11/gosu-amd64" \
    && chmod +x /usr/local/bin/gosu \
    && gosu nobody true && \
    mkdir -p /tmp/src && \
    cd /tmp/src && \
    wget http://nginx.org/download/${NGINX_VERSION}.tar.gz && \
    tar -zxvf ${NGINX_VERSION}.tar.gz && \
    cd /tmp/src/${NGINX_VERSION} && \
    ./configure \
        --with-http_ssl_module \
        --without-http_rewrite_module \
        --without-http_gzip_module \
        --conf-path=/etc/nginx/nginx.conf \
        --error-log-path=stderr \
        --http-log-path=/tmp/stdout \
        --sbin-path=/usr/local/bin/nginx && \
    make && \
    make install && \
    apk del build-base && \
    rm -rf /tmp/src && \
    rm -rf /var/cache/apk/*

FROM alpine:3.11
COPY --from=builder /usr/local/bin/nginx /usr/local/bin/nginx
COPY --from=builder /usr/local/bin/gosu /usr/local/bin/gosu
RUN adduser -h /etc/nginx -D -s /bin/sh nginx -u 1000
COPY nginx.conf /etc/nginx/
ADD docker-entrypoint.sh /usr/bin/
ENTRYPOINT ["/usr/bin/docker-entrypoint.sh"]
