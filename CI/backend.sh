#!/bin/bash -x

cd api
cp .env.travis .env && \
composer install --no-interaction && \
php artisan db:create && \
php artisan migrate