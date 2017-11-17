#!/bin/bash -x

cp api/.env.travis api/.env && \
composer install --no-interaction --working-dir ./api  && \
php artisan db:create && \
php artisan migrate