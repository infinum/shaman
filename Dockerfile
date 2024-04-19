FROM ruby:3.0 as base

RUN apt-get update -qq \
  && apt-get install -yq --no-install-recommends git build-essential less

WORKDIR /app

COPY Gemfile shaman.gemspec ./
COPY lib/shaman/version.rb lib/shaman/version.rb

RUN bundle install

FROM base as ci
RUN mkdir /app/tmp
COPY . /app
