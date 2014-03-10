#!/bin/bash -e
gem install bundler
bundle install
ruby infrastructure/bin/create_cloudformation_stack.rb
