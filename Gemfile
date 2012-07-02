source 'https://rubygems.org'

# If you get errors about the 'ruby' line, run:
#   gem uninstall bundler
#   gem install bundler --pre

## Essentials
ruby '1.9.3'
gem 'rails', '3.2.6'
gem 'pg'
gem 'thin'

## Deployment, maintanence, profiling, development aids
gem 'newrelic_rpm'
gem 'heroku'
gem 'annotate', '~>2.4.1.beta'
gem 'rails-erd'

## Admin interface
gem 'rails_admin', '~> 0.0.2'
gem 'devise', '~> 2.0'
gem 'cancan'

## Search and indexing
gem 'tanker'
gem 'hunspell-ffi'

## Content and presentation
gem 'bluecloth'  
gem 'friendly_id' # permalinks / descriptive URLs

## Gems used only for assets and not required
## in production environments by default.
group :assets do
  gem 'sass-rails',   '~> 3.2.3'
  gem 'jquery-ui-rails'
  gem 'uglifier', '>= 1.0.3'
  gem 'less-rails-bootstrap'  
  # gem 'coffee-rails', '~> 3.2.1'
  gem 'therubyracer'
end

## Testing
group :test, :development do
  gem 'rspec-rails', '>= 2.10.1'
  gem 'shoulda'
  gem 'capybara'
  gem 'launchy'
  gem 'guard-rspec'
  gem 'factory_girl_rails'
  gem 'libnotify'
  gem 'spork-rails'
  gem 'guard-spork'
  gem 'tanker'
  # gem 'poltergeist' # JS driver for Capybara (headless)
  gem 'capybara-webkit'
end

# This isn't actually needed for tests, but some gems
# use it so removing it ends up breaking stuff.
gem 'test-unit'


group :test do
  gem "sqlite3"
  gem 'database_cleaner'
  gem 'simplecov', :require => false
end