FROM ruby:2.5.1-alpine

LABEL maintainer="SWO"
LABEL version="0.1"
LABEL description="Izivi backend"

RUN apk update && apk add mysql-client build-base mariadb-dev pdftk

ENV BUNDLER_VERSION=2.0.1
RUN gem install bundler -v "2.0.1" --no-document
WORKDIR /api
COPY Gemfile* ./
RUN bundle install
COPY . /api

EXPOSE 3000
CMD ["rails", "server", "-p", "3000", "-b", "0.0.0.0"]
