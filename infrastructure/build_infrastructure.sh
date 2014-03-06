#!/bin/bash -e
gem install bundler
bundle install
export RAILS_ENV="development"
ruby infrastructure/bin/create_database.rb
mv /tmp/database.yml config/database.yml
bundle exec rake db:schema:load
bundle exec rake db:seed
ruby infrastructure/bin/create_honolulu_answers_stack.rb --db `cat /tmp/rds_instance` --accountnumber ENV["AWS_ACCT_NUMBER"]
