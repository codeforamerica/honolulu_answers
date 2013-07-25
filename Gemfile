source 'https://rubygems.org'

## Essentials
ruby '1.9.3'                              # Ruby!
gem 'rails', '3.2.13'                     # Rails!
gem 'pg'                                  # PostgreSQL, the database server
gem 'thin'                                # Web server
gem 'foreman'                             # For launching with the Procfile and keeping track of environment variables from .env

## Utilities
gem 'newrelic_rpm', :group => [:production, :staging, :development] # Rails analytics
gem 'annotate', '~>2.4.1.beta'            # Annotates models with database info: `bundle exec rake:annotate`
gem 'rails-erd'                           # Create Entity Relationship Diagrams
gem 'progressbar'                         # Display progress bars in terminal output
gem 'facets', :require => false           # Some extra methods for ruby
gem 'seed_dump'                           # Adds a rake task which constructs a db/seeds.rb file based on the current database state.  Super useful!
gem 'jquery-ui-rails'                     # Package jQuery for the Rails 3.1+ asset pipeline
gem 'ruby-prof', '~>0.12.2'               # ruby profiler

## SEO
gem 'meta-tags', :require => 'meta_tags'  # Search Engine Optimization (SEO) plugin for Ruby on Rails applications.

## Performance and optimization
gem 'delayed_job_active_record'           # Lets you queue tasks as background jobs
gem 'dalli'                               # memcache gem for Rails.cache
gem 'kgio'

## Admin
gem 'activeadmin', '0.4.4'                # Back-end Content Management System
gem 'devise', '~> 2.0'                    # User authentication 
gem 'cancan'                              # User permissions

## Search and NLP
gem 'tanker'                              # library for interacting with Searchify
gem 'hunspell-ffi'                        # Spellchecking library
gem 'text'                                # NLP algorithms
gem 'httparty'                            # For accessing APIs directly
gem 'json'                                # Convert between JSON and Ruby objects

## Content and presentation
gem 'bluecloth'                           # Parse Markdown
gem 'kramdown'                            # Better markdown parser with support for markdown-extra
gem 'friendly_id', '~> 4.0.9'             # Create permalinks / descriptive URLs / slugs
gem 'gon'                                 # Easy passing of data from the controller to javascript files
gem 'paperclip', '~> 3.0'                 # Easy file attachment library for ActiveRecord
gem 'aws-sdk', '~> 1.3.4'                 # Upload files to Amazon S3
#gem 'pagedown-rails', '1.0.0'             # Markdown editor

## Gems used only for assets and not required
## in production environments by default.
group :assets do
  gem 'sass-rails', '~> 3.2.5'            # Rails support for Sass, a CSS extension language
  gem "meta_search", '>= 1.1.0.pre'       # Active_admin search for form_for
  gem 'uglifier', '>= 1.0.3'              # Squash down Javascript for speed
  gem 'less-rails-bootstrap'              # Improves the Rails / Twitter Boostrap relationship by adding support for LESS, a CSS extension language
  gem 'coffee-rails', '~> 3.2.1'
  gem 'therubyracer'                      # Embeds the V8 Javascript interpreter into Ruby
end

## Testing
group :test, :development do
  gem 'rspec-rails', '>= 2.10.1'          # Testing framework
  gem 'shoulda'                           # Extra RSpec matchers for Active Record Associations
  gem 'capybara'                          # Simulates real-user behaviour for acceptance and integration testing
  gem 'launchy'                           # Lets you 'save_and_open_page' in the middle of a test - opens up the browser and shows you the current state of the page
  gem 'guard-rspec'                       # Guard integratio for RSpec.  Guard monitors files and automatically and intelligently runs 'rspec spec' in the background
  gem 'factory_girl_rails'                # Create factories to test against
  gem 'spork-rails'                       # Speeds up TDD by launching multiple Rails instances in the background
  gem 'guard-spork'                       # Make guard aware of Spork - automatically restart spork if a change requires a rails restart
  gem 'capybara-webkit'                   # JS driver for Capybara (headless)
  gem 'memcached'                         # Local memcache
  gem 'sextant'                           # visit /rails/routes in the browser for nicer 'rake routes'
  gem 'better_errors'                     # more information in the browser when rails errors.
  gem 'binding_of_caller'                 # improves better_errors
end

gem 'test-unit'                           # Remove at your peril.  Too many other gems randomly depend on it.

group :test do
  gem "sqlite3"                           # Use SQLite instead of PostgreSQL for tests
  gem 'database_cleaner'                  # Purge the test database between test runs
  gem 'simplecov', :require => false      # Calculates code coverage and outputs info to html. 
end
