#!/bin/bash -e
pushd infrastructure
ruby bin/create_database.rb
cd ..
mv infrastructure/database.yml config/database.yml
gem install bundler
bundle install
rake db:schema:load
rake db:seed
popd
ruby bin/create_honolulu_answers_stack.rb
