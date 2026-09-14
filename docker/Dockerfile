FROM php:7.2-apache

WORKDIR /var/www/html
COPY --chown=www-data:www-data . .

RUN find . -type f -exec chmod 660 '{}' \; \
    && find . -type d -exec chmod 770 '{}' \;

USER www-data
