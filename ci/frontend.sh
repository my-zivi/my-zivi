#!/bin/bash -vue

set +v
source ~/.nvm/nvm.sh
set -v
nvm install 8.3 && \
nvm use 8.3 && \
cd web-client && \
npm install -g yarn --verbose && \
yarn install && \
yarn build
