#!/bin/bash -vue

if [[ $TRAVIS_COMMIT_MESSAGE != *"[skip-tests]"* ]]; then
    cp ./api/.env.travis ./api/.env
    php api/artisan db:create
    php api/artisan migrate:fresh -q
    ./api/vendor/phpunit/phpunit/phpunit -c api --coverage-clover=coverage.xml
    if [ $? == 0 ]; then
        bash <(curl -s https://codecov.io/bash)
    fi
fi
