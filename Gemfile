source 'https://rubygems.org'

#gem 'bundler', '~> 1.3.0.pre.5'		        # Bundler version to match what is used on Heroku.

## Essentials
ruby '2.1.1'                              # Ruby!
gem 'rails', '~> 4.0'                  # Rails!
gem 'pg'                                  # PostgreSQL, the database server
gem 'thin'                                # Web server

gem 'newrelic_rpm', :group => [:production, :staging, :development] # Rails analytics - see the Heroku addon
gem 'progressbar'                         # Display progress bars in terminal output
gem 'facets', :require => false           # Some extra methods for ruby
gem 'jquery-ui-rails'                     # Package jQuery for the Rails 3.1+ asset pipeline
gem 'rollbar', '~>0.10.11'                # SaaS to track exceptions

## SEO
gem 'meta-tags', :require => 'meta_tags'  # Search Engine Optimization (SEO) plugin for Ruby on Rails applications.

## Performance and optimization
gem 'delayed_job_active_record', '~> 4.0.0' # Lets you queue tasks as background jobs
gem 'dalli'                               # memcache gem for Rails.cache
gem 'memcachier'
gem 'kgio'                                # gives 20~30% performance boost to Dalli

## Admin

gem 'activeadmin', github: 'gregbell/active_admin'# Back-end Content Management System

gem 'devise', '~> 3.2'                    # User authentication
gem 'cancan'                              # User permissions

## Search and NLP
gem 'tanker'                              # library for interacting with Searchify
gem 'hunspell-ffi'                        # Spellchecking library
gem 'text'                                # NLP algorithms
gem 'httparty'                            # For accessing APIs directly
gem 'json'                                # Convert between JSON and Ruby objects

## Content and presentation
gem 'kramdown'                            # Better markdown parser with support for markdown-extra
gem 'friendly_id'                         # Create permalinks / descriptive URLs / slugs
gem 'paperclip', '~> 3.0'                 # Easy file attachment library for ActiveRecord
gem 'aws-sdk', '~> 1.3.4'                 # Upload files to Amazon S3

## Testing
group :test, :development do
  gem 'rspec-rails', '>= 2.0'             # Testing framework
  gem 'shoulda', '~> 3.5.0'               # Extra RSpec matchers for Active Record Associations
  gem 'factory_girl_rails', '~> 4.0'      # Create factories to test against
  gem 'capybara', '~> 2.1'
  gem 'launchy'
  gem 'guard', '~> 1.8.0'
  gem 'guard-rspec', '~> 3.0.0'
  gem 'terminal-notifier-guard'
  gem 'sextant'                           # visit /rails/routes in the browser for nicer 'rake routes'
  gem 'seed_dump', '~> 0.6.0'             # Adds rake db:seed:dump to generate db/seeds.rb
end


group :test do
  gem "sqlite3"                           # Use SQLite instead of PostgreSQL for tests
end
