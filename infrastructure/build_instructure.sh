#!/bin/bash -e
pushd infrastructure
ruby bin/create_database.rb
cd ..
mv infrastructure/database.yml config/database.yml
gem install bundler
bundle install
rake db:setup
popd
ruby bin/create_honolulu_answers_stack.rb
