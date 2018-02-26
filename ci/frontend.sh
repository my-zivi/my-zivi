#!/bin/bash

source ~/.nvm/nvm.sh && \
nvm install 8.3 && \
nvm use 8.3 && \
cd web-client && \
npm install -g yarn --verbose && \
yarn install && \
yarn build
