FROM php:8.2-apache

RUN apt-get update && \
    apt-get install -y libbz2-dev libicu-dev libfreetype-dev libjpeg-dev libpng-dev libwebp-dev && \
    docker-php-ext-configure gd --with-freetype --with-jpeg && \
    docker-php-ext-install gd intl bz2 && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /var/www/html
COPY --chown=www-data:www-data . .

RUN find . -type f -exec chmod 660 '{}' \; \
    && find . -type d -exec chmod 770 '{}' \;

USER www-data
