FROM ruby:2.5.1-alpine

LABEL maintainer="SWO"
LABEL version="0.1"
LABEL description="Izivi backend"

ENV BUNDLER_VERSION=2.0.1
ENV RAILS_ENV=production

RUN gem install bundler -v "2.0.1" --no-document
WORKDIR /api
COPY Gemfile* ./

RUN apk update && apk add pdftk mariadb-client-libs
RUN apk add --virtual "temporary" build-base git mariadb-dev; \
     bundle install --without development:test --deployment --jobs=2; \
     apk del temporary; \
     rm -rf /var/cache/apk/*

COPY . /api

EXPOSE 3000
CMD ["bin/rails", "server", "-p", "3000", "-b", "0.0.0.0", "-e", "production"]
