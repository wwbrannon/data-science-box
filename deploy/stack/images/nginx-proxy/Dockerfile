FROM nginx

RUN rm -f /etc/nginx/conf.d/default.conf

COPY *.conf /etc/nginx/conf.d/
COPY certs/output /etc/nginx/certs

