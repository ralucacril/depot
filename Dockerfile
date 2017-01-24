FROM registry.env.intra.local.ch/web/ruby:2.3.3

# see update.sh for why all "apt-get install"s have to stay as one long line
RUN apt-get update && apt-get install -y nodejs --no-install-recommends && rm -rf /var/lib/apt/lists/*

# see http://guides.rubyonrails.org/command_line.html#rails-dbconsole
RUN apt-get update && apt-get install -y ssh mysql-client postgresql-client ca-certificates sqlite3 --no-install-recommends && rm -rf /var/lib/apt/lists/*

RUN mkdir -p /usr/src/app
WORKDIR /usr/src/app

RUN mkdir /root/.ssh
RUN ssh-keyscan -t rsa github.com > ~/.ssh/known_hosts
ONBUILD COPY . /usr/src/app
ONBUILD RUN bundle install
ONBUILD RUN RAILS_ENV=production bundle exec rake assets:precompile
ONBUILD VOLUME /usr/src/app/public

EXPOSE 3000
ENV RAILS_ENV "production"
ENV RAILS_LOG_TO_STDOUT "true"
CMD ["bundle", "exec", "rails", "server", "-b", "0.0.0.0", "-e", "production"]
