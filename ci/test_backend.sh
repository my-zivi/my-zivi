#!/bin/bash -vue

set -e

cp ./api/.env.travis ./api/.env
php api/artisan db:create
php api/artisan migrate:fresh -q
./api/vendor/phpunit/phpunit/phpunit -c api --coverage-clover=coverage.xml
bash <(curl -s https://codecov.io/bash)
if [[ $TRAVIS_COMMIT_MESSAGE != *"[skip-tests]"* ]]; then
    if [ $? == 0 ]; then
    fi
fi
