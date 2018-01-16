#!/bin/bash

if [[ $TRAVIS_COMMIT_MESSAGE != *"[skip-tests]"* ]]; then
  ./api/vendor/phpunit/phpunit/phpunit -c api --coverage-clover=coverage.xml
fi
