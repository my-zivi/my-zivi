FROM ruby:2.6.5

LABEL maintainer="SWO"
LABEL version="0.1"
LABEL description="Izivi backend"

ENV BUNDLER_VERSION=2.1.4
ENV RAILS_ENV=production
ENV RACK_ENV=production

RUN gem install bundler -v "2.1.4" --no-document
RUN apt-get update && apt-get install -y mariadb-client pdftk

WORKDIR /api
COPY Gemfile* ./
COPY . /api

RUN bundle install --jobs=8

EXPOSE 3000
CMD ["bin/rails", "server", "-p", "3000", "-b", "0.0.0.0", "-e", "production"]
