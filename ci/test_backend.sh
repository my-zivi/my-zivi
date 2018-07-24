#!/bin/bash -vue

if [[ $TRAVIS_COMMIT_MESSAGE != *"[skip-tests]"* ]]; then
    php api/artisan migrate:fresh -q
    ./api/vendor/phpunit/phpunit/phpunit -c api --coverage-clover=coverage.xml
fi
