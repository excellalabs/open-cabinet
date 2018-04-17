FROM ruby:2.2.9
RUN apt-get update -qq && apt-get install -y build-essential nodejs npm vim

RUN mkdir /myapp

WORKDIR /tmp
COPY Gemfile Gemfile
COPY Gemfile.lock Gemfile.lock
RUN bundle install

ADD . /myapp
WORKDIR /myapp

RUN bundle exec rake assets:precompile RAILS_ENV=production
