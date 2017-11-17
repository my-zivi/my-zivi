#!/bin/bash -x

nodepath=`pwd`/node-v8.9.1-linux-x64/bin

wget -q "https://nodejs.org/dist/v8.9.1/node-v8.9.1-linux-x64.tar.xz" && \
tar xf node-v8.9.1-linux-x64.tar.xz && \
cd web-client && \
$nodepath/npm install -g yarn --verbose && \
$nodepath/npm install && \
yarn run watch