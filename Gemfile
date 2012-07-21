source 'https://rubygems.org'

# If you get errors about the 'ruby' line, run:
#   gem uninstall bundler
#   gem install bundler --pre

## Essentials
ruby '1.9.3'                              # Ruby!
gem 'rails', '3.2.6'                      # Rails!
gem 'pg'                                  # PostgreSQL, the database server
gem 'unicorn'                                # Web server

## Utilities
gem 'newrelic_rpm'#, :group => :production # Rails analytics - see the Heroku addon
gem 'heroku'                              # Managed hosting solution
gem 'annotate', '~>2.4.1.beta'            # Annotates models with database info: `bundle exec rake:annotate` 
gem 'rails-erd'                           # Create Entity Relationship Diagrams
gem 'progressbar'                         # Display progress bars in terminal output
gem 'facets', :require => false           # Some extra methods for ruby
gem 'seed_dump'                           # Adds a rake task which constructs a db/seeds.rb file based on the current database state.  Super useful!
gem 'jquery-ui-rails'                     # Package jQuery for the Rails 3.1+ asset pipeline 

## Performance and optimization
gem 'delayed_job_active_record'           # Lets you queue tasks as background jobs
gem 'dalli'                               # memcache gem for Rails.cache

## Admin
gem 'activeadmin'                         # Back-end Content Management System
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
gem 'friendly_id'                         # Create permalinks / descriptive URLs / slugs
gem 'gon'                                 # Easy passing of data from the controller to javascript files

## Gems used only for assets and not required
## in production environments by default.
group :assets do
  gem 'sass-rails',   '~> 3.2.5'          # Rails support for Sass, a CSS extension language
  gem "meta_search",    '>= 1.1.0.pre'    # Active_admin search for form_for
  gem 'uglifier', '>= 1.0.3'              # Squash down Javascript for speed
  gem 'less-rails-bootstrap'              # Improves the Rails / Twitter Boostrap relationship by adding support for LESS, a CSS extension language
  # gem 'coffee-rails', '~> 3.2.1'
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
  #gem 'libnotify', :require => false if (RUBY_PLATFORM =~ /darwin/i)                 # For displaying notifications about test status in Linux 
  gem 'spork-rails'                       # Speeds up TDD by launching multiple Rails instances in the background
  gem 'guard-spork'                       # Make guard aware of Spork - automatically restart spork if a change requires a rails restart   
  gem 'capybara-webkit'                   # JS driver for Capybara (headless)
end

gem 'test-unit'                           # Remove at your peril.  Too many other gems randomly depend on it.

group :test do
  gem "sqlite3"                           # Use SQLite instead of PostgreSQL for tests
  gem 'database_cleaner'                  # Purge the test database between test runs
  gem 'simplecov', :require => false      # Calculates code coverage and outputs info to html. 
end