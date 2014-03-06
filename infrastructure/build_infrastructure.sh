#!/bin/bash -e
# aws cloudformation create-stack --stack-name Honolulu-`date +%Y%m%d%H%M%S` --template-body "`cat infrastructure/config/honolulu.template`"  --disable-rollback
echo "========= Gem list pre bundle install ========="
gem list
bundle install

echo "========= Gem list post bundle install ========="
gem list
ruby infrastructure/bin/create_cloudformation_stack.rb
