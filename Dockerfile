FROM ruby:4.0.7-slim

WORKDIR /rails

RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y build-essential default-libmysqlclient-dev git libvips libyaml-dev pkg-config && \
    rm -rf /var/lib/apt/lists/*

ENV RAILS_ENV=development \
    BUNDLE_PATH=/usr/local/bundle \
    BUNDLE_IGNORE_CONFIG=1

COPY Gemfile Gemfile.lock ./
RUN bundle install

COPY . .

EXPOSE 3000
CMD ["bin/rails", "server", "-b", "0.0.0.0"]
