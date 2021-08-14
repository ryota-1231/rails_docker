#既存のプロジェクトのrubyのバージョンを指定
FROM ruby:2.7.2
# dockerizeパッケージダウンロード用環境変数
ENV DOCKERIZE_VERSION v0.6.1

#パッケージの取得
RUN apt-get update && apt-get install -y curl apt-transport-https build-essential mariadb-client wget && \
  wget https://github.com/jwilder/dockerize/releases/download/$DOCKERIZE_VERSION/dockerize-linux-amd64-$DOCKERIZE_VERSION.tar.gz && \
  tar -C /usr/local/bin -xzvf dockerize-linux-amd64-$DOCKERIZE_VERSION.tar.gz && \
  rm dockerize-linux-amd64-$DOCKERIZE_VERSION.tar.gz && \
  curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - && \
  echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list && \
  apt-get update && apt-get install -y yarn

RUN curl -sL https://deb.nodesource.com/setup_7.x | bash - && \
  apt-get install nodejs

WORKDIR /myapp

COPY Gemfile /myapp/Gemfile
COPY Gemfile.lock /myapp/Gemfile.lock

RUN gem install bundler
RUN bundle install

COPY . /myapp
