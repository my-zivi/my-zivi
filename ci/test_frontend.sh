#!/bin/bash -vue

if [[ $TRAVIS_COMMIT_MESSAGE != *"[skip-tests]"* ]]; then
    cp ./api/.env.travis ./api/.env
    php api/artisan db:create
    php api/artisan serve &
    yarn --cwd web-client start &
    php api/artisan migrate:fresh --seed -q
    cd web-client && yarn run cypress run --config video=false,baseUrl="http://localhost:3000"
fi
