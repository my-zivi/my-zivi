#!/bin/bash -x

cd api
composer install --no-interaction && \
php artisan db:create && \
php artisan migrate