FROM ruby:2.7.1-alpine

LABEL maintainer="MyZivi"
LABEL version="0.1"
LABEL description="MyZivi"

ARG GH_NPM_TOKEN

ENV BUNDLER_VERSION 2.1.4
ENV PATH "/usr/lib/jvm/java-11-openjdk/bin:${PATH}"
ENV JAVA_HOME "/usr/lib/jvm/java-11-openjdk/"
ENV LD_LIBRARY_PATH "/usr/lib/jvm/java-11-openjdk/jre/lib/amd64/server/"

WORKDIR /app
RUN gem install bundler -v "2.1.4" --no-document

COPY Gemfile* ./
COPY . /app

RUN echo 'http://dl-cdn.alpinelinux.org/alpine/v3.14/main' >> /etc/apk/repositories \
&& apk update && apk add --update bash build-base git less \
postgresql-dev npm postgresql-libs postgresql openjdk11 \
tzdata gcc g++ pkgconfig shadow musl-dev autoconf automake \
make libtool nasm tiff jpeg zlib zlib-dev file pkgconf dpkg \
libpng libpng-dev postgresql-client imagemagick

RUN bash -lc "mkdir -p /usr/lib/jvm/java-11-openjdk/lib/amd64/server"
RUN bash -lc "ln -s /usr/lib/jvm/java-11-openjdk/lib/server/libjvm.so /usr/lib/jvm/java-11-openjdk/lib/amd64/server/libjvm.so"

RUN bundle install --jobs=8
RUN echo "//npm.pkg.github.com/:_authToken=${GH_NPM_TOKEN}" > .npmrc && \
    npm i -g yarn \
    && yarn global add mozjpeg \
    && yarn install --check-files


EXPOSE 3000
CMD ["bin/rails", "server", "-p", "3000", "-b", "0.0.0.0", "-e", "production"]
