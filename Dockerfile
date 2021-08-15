FROM ruby:2.7.2-alpine3.12

ENV DOCKERIZE_VERSION v0.6.1

ENV APP_ROOT /myapp

ENV LANG=C.UTF-8 \
  TZ=Asia/Tokyo \
  BUILD_PACKAGES="curl-dev ruby-dev build-base" \
  DEV_PACKAGES="zlib-dev libxml2-dev libxslt-dev tzdata yaml-dev sqlite-dev shared-mime-info" \
  RUBY_PACKAGES="ruby-json yaml" \
  DB_PACKAGES="mariadb-dev mariadb-client" \
  OTHER_PACKEGES="linux-headers nodejs yarn less"

# Update and install base packages and nokogiri gem that requires a
# native compilation
RUN apk update && \
  apk upgrade && \
  apk add --no-cache --update\
  $BUILD_PACKAGES \
  $DEV_PACKAGES \
  $DB_PACKAGES \
  $OTHER_PACKEGES \
  $RUBY_PACKAGES \
  && wget https://github.com/jwilder/dockerize/releases/download/$DOCKERIZE_VERSION/dockerize-alpine-linux-amd64-$DOCKERIZE_VERSION.tar.gz \
  && tar -C /usr/local/bin -xzvf dockerize-alpine-linux-amd64-$DOCKERIZE_VERSION.tar.gz \
  && rm dockerize-alpine-linux-amd64-$DOCKERIZE_VERSION.tar.gz \
  && mkdir -p ${APP_ROOT}

RUN ln -sf /usr/share/zoneinfo/Asia/Tokyo /etc/localtime

# Copy the app into the working directory. This assumes your Gemfile
# is in the root directory and includes your version of Rails that you
# want to run.
WORKDIR ${APP_ROOT}
COPY Gemfile ${APP_ROOT}
COPY Gemfile.lock ${APP_ROOT}

RUN gem install -N rails
RUN bundle install
RUN SECRET_KEY_BASE=placeholder bundle exec rails assets:precompile \
  && yarn cache clean \
  && rm -rf node_modules tmp/cache

# Add a script to be executed every time the container starts.
COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]
CMD ["bundle", "exec", "rails", "s", "-p", "3000", "-b", "0.0.0.0", "--pid", "/tmp/server.pid"]

COPY ./ ${APP_ROOT}
EXPOSE 3000