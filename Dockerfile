FROM abiosoft/caddy:builder as builder

ARG version="1.0.3"
ARG plugins="git,cors,realip,expires,cache,extauth,forwardproxy"

RUN go get -v github.com/abiosoft/parent

RUN VERSION=${version} PLUGINS=${plugins} ENABLE_TELEMETRY=false /bin/sh /usr/bin/builder.sh


FROM alpine:edge

ARG version="1.0.3"

LABEL maintainer "zyclonite"
LABEL description "Caddy, php and mongodb as Docker Image"
LABEL caddy_version="$version"

ENV ENABLE_TELEMETRY="false"

RUN apk add --no-cache -X http://dl-cdn.alpinelinux.org/alpine/edge/testing \
  ca-certificates curl git mailcap openssh-client  php7-fpm tar tzdata php7-dom \
  php7-pecl-imagick php7-pecl-apcu php7-pecl-apcu php7-bcmath php7-ctype php7-curl \
  php7-exif php7-fileinfo php7-gd php7-iconv php7-json php7-mbstring php7-mysqli \
  php7-opcache php7-openssl php7-pdo php7-pdo_mysql php7-pdo_pgsql php7-pdo_sqlite \
  php7-pgsql php7-phar php7-session php7-simplexml php7-sqlite3 php7-tokenizer \
  php7-xml php7-xmlreader php7-xmlwriter php7-zip php7-pecl-mongodb php7-pecl-mcrypt \
  php7-sockets && \
  rm -rf /var/cache/apk/* && \
  ln -sf /usr/bin/php7 /usr/bin/php && \
  ln -sf /usr/bin/php-fpm7 /usr/bin/php-fpm && \
  addgroup -g 1000 www-user && \
  adduser -D -H -u 1000 -G www-user www-user && \
  sed -i "s|^user = .*|user = www-user|g" /etc/php7/php-fpm.d/www.conf && \
  sed -i "s|^group = .*|group = www-user|g" /etc/php7/php-fpm.d/www.conf && \
  curl --silent --show-error --fail --location \
  --header "Accept: application/tar+gzip, application/x-gzip, application/octet-stream" \
  "https://getcomposer.org/installer" \
  | php -- --install-dir=/usr/bin --filename=composer && \
  echo "clear_env = no" >> /etc/php7/php-fpm.conf

COPY --from=builder /install/caddy /usr/bin/caddy

EXPOSE 80 443 2015
VOLUME /root/.caddy /srv
WORKDIR /srv

COPY Caddyfile /etc/Caddyfile
COPY index.php /srv/index.php
COPY --from=builder /go/bin/parent /bin/parent

ENTRYPOINT ["/bin/parent", "caddy"]
CMD ["--conf", "/etc/Caddyfile", "--log", "stdout", "--agree=true"]
