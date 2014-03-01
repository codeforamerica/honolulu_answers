#!/bin/bash -e
ruby infrastructure/bin/create_database.rb
mv /tmp/database.yml config/database.yml
gem install bundler
bundle install
rake db:schema:load
rake db:seed
ruby bin/create_honolulu_answers_stack.rb --db `cat /tmp/rds_instance`
