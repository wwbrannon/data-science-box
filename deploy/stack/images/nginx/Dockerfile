FROM nginx:stable

RUN { \
        echo 'server_tokens off;'; \
        echo 'client_max_body_size 0;'; \
    } > /etc/nginx/conf.d/proxy.conf

