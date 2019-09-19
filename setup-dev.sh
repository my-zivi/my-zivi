#!/bin/bash

cd api && bin/setup
cd frontend && yarn install

cp api/.env.example api/.env
