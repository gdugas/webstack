FROM nginx

RUN echo "deb http://ftp.debian.org/debian jessie-backports main" > /etc/apt/sources.list.d/backports.list
RUN apt-get update && \
    apt-get install -y certbot -t jessie-backports && \
    apt-get install -y python python-pystache

COPY ./conf.d/nginx.conf /etc/nginx/
COPY ./conf.d/default.conf ./conf.d/vhost.conf.tpl /etc/nginx/conf.d/
COPY ./bin/* /usr/local/bin/

RUN chmod +x /usr/local/bin/*

RUN mkdir -p /etc/nginx/cert && openssl dhparam 2048 -out /etc/nginx/cert/dhparam.pem

VOLUME /etc/letsencrypt
