FROM ruby:2.7.2
ENV DOCKERIZE_VERSION v0.6.1

RUN apt-get update && apt-get install -y \
  build-essential \
  nodejs \
  yarn \
  vim \
  locales \
  locales-all \
  mariadb-client \
  wget \
  && wget https://github.com/jwilder/dockerize/releases/download/$DOCKERIZE_VERSION/dockerize-linux-amd64-$DOCKERIZE_VERSION.tar.gz \
  && tar -C /usr/local/bin -xzvf dockerize-linux-amd64-$DOCKERIZE_VERSION.tar.gz \
  && rm dockerize-linux-amd64-$DOCKERIZE_VERSION.tar.gz \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*

ENV LANG ja_JP.UTF-8

RUN mkdir -p /app
WORKDIR /app

COPY Gemfile Gemfile.lock ./

RUN gem update bundler
RUN bundle install
COPY . .
RUN yarn install --check-files

CMD ["rails", "server", "-b", "0.0.0.0"]