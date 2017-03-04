server {
    listen       {{http_port}};
    server_name  {{#domains}}{{.}} {{/domains}};

    access_log  /var/log/nginx/{{service_name}}-http.access.log  main;
    error_log  /var/log/nginx/{{service_name}}-http.error.log warn;
    
    # By DEFAULT REDIRECT ON HTTPS
    location / {
        return 301 https://$host$request_uri;
    }

    # CERTBOT ACME Challenge
    location /.well-known/acme-challenge/ {
        allow all;
        root   /var/www/{{service_name}}/;
    }
}

server {
    listen       {{https_port}} ssl http2;
    server_name  {{#domains}}{{.}} {{/domains}};

    #charset koi8-r;
    access_log  /var/log/nginx/{{service_name}}-https.access.log  main;
    error_log  /var/log/nginx/{{service_name}}-https.error.log warn;

    location / {
        root             /usr/share/nginx/html;
        index            index.html index.htm;
        proxy_pass       http://{{service_name}}{{#service_port}}:{{service_port}}{{/service_port}}{{service_path}};
        proxy_set_header X-Real-IP       $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    }

    ssl_certificate     {{ssl_cert_path}};
    ssl_certificate_key {{ssl_key_path}};

    # Thx to https://www.bjornjohansen.no/optimizing-https-nginx
    ssl_session_cache shared:SSL:20m;
    ssl_session_timeout 180m;
    ssl_protocols TLSv1 TLSv1.1 TLSv1.2;
    ssl_prefer_server_ciphers on;
    ssl_ciphers ECDH+AESGCM:ECDH+AES256:ECDH+AES128:DH+3DES:!ADH:!AECDH:!MD5
    ssl_dhparam /etc/nginx/cert/dhparam.pem;
    add_header Strict-Transport-Security "max-age=31536000" always;
}
