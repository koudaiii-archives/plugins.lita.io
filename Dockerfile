FROM litaio/ruby:2.2.0

RUN apt-get install -qqy --no-install-recommends apt-transport-https && \
  curl -s "https://deb.nodesource.com/gpgkey/nodesource.gpg.key" | apt-key add - && \
  echo "deb https://deb.nodesource.com/node wheezy main" > /etc/apt/sources.list.d/nodesource.list && \
  echo "deb-src https://deb.nodesource.com/node wheezy main" >> /etc/apt/sources.list.d/nodesource.list && \
  apt-get update -qq && \
  DEBIAN_FRONTEND=noninteractive apt-get install -qqy --no-install-recommends \
    libpq-dev \
    nodejs && \
  apt-key del "NodeSource <gpg@nodesource.com>" && \
  apt-get autoremove && \
  apt-get clean && \
  rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* && \
  gem install bundler

COPY Gemfile /app/
COPY Gemfile.lock /app/
WORKDIR /app
RUN bundle install --jobs $(nproc)

COPY . /app

EXPOSE 3000
CMD ["bundle", "exec", "rails", "server"]
