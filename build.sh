export BHT_API_KEY="7868d47a7c43908cc80a44738acebb41"
bundle install
bundle exec rake db:drop
bundle exec rake db:setup
bundle exec rake spec
