FROM ruby:2.5.1-alpine

ENV INSTALL_PATH /app

WORKDIR $INSTALL_PATH

ADD http://www.freetds.org/files/stable/freetds-1.00.92.tar.gz .

ENV BUILD_PACKAGES build-base libc6-compat linux-headers
RUN apk add --no-cache $BUILD_PACKAGES \
  && tar -xzf freetds-1.00.92.tar.gz \
  && cd freetds-1.00.92 \
  && ./configure \
  && make install \
  && cd ../ && rm -rf freetds-1.00.92

COPY Gemfile .dockerignore contented.gemspec ./
COPY ./lib/contented/version.rb ./lib/contented/version.rb

RUN gem install bundler && bundle install --jobs 20 --retry 5

COPY . .
