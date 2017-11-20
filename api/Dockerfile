FROM php:7.1-cli

RUN apt-get update && apt-get install -y unzip

RUN docker-php-ext-install pdo pdo_mysql && \
    php -r "readfile('https://getcomposer.org/installer');" > composer-setup.php && \
    php composer-setup.php && \
    php -r "unlink('composer-setup.php');" && \
    mv composer.phar /usr/local/bin/composer
