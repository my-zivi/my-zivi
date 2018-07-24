#!/bin/bash -vue

if [[ $TRAVIS_COMMIT_MESSAGE != *"[skip-tests]"* ]]; then
    php api/artisan migrate:fresh --seed -q
    cd web-client && CYPRESS_BASE_URL=http://localhost:3000 yarn run cypress run
fi
