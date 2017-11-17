#!/bin/bash -x

cp api/.env.travis api/.env && \
composer install -n && \
php artisan db:create && \
php artisan migrate