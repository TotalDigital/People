FROM ruby:2.3.3
RUN apt-get update -qq && apt-get install -y build-essential libpq-dev nodejs
RUN mkdir /justone-poc-docker
WORKDIR /justone-poc-docker
ADD Gemfile /justone-poc-docker/Gemfile
ADD Gemfile.lock /justone-poc-docker/Gemfile.lock
RUN bundle install
ADD . /justone-poc-docker