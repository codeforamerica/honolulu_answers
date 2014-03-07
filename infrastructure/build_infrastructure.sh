#!/bin/bash -e
gem install bundler
bundle install
export RAILS_ENV="development"
ruby infrastructure/bin/create_database.rb
mv /tmp/database.yml config/database.yml
bundle exec rake db:schema:load
bundle exec rake db:seed

echo $AWS_ACCT_NUMBER
echo $AWS_SECRET_ACCESS_KEY
echo $AWS_ACCESS_KEY
ruby infrastructure/bin/create_honolulu_answers_stack.rb --db `cat /tmp/rds_instance` --accountnumber $AWS_ACCT_NUMBER
