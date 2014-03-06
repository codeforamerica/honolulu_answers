#!/bin/bash -e
# aws cloudformation create-stack --stack-name Honolulu-`date +%Y%m%d%H%M%S` --template-body "`cat infrastructure/config/honolulu.template`"  --disable-rollback
gem install bundle
bundle install
ruby infrastructure/bin/create_cloudformation_stack.rb
