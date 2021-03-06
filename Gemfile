source 'https://rubygems.org'

ruby '2.6.3'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end


# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 5.2.0'
# Use Puma as the app server
gem 'puma', '~> 3.11'
# Use SCSS for stylesheets
gem 'sassc-rails'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# See https://github.com/rails/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby

# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails', '~> 4.2'
# Turbolinks makes navigating your web application faster. Read more: https://github.com/turbolinks/turbolinks
gem 'turbolinks', '~> 5'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.5'
# Use ActiveModel has_secure_password
gem 'bcrypt', '~> 3.1.7'

# Do not use sprockets 4 to keep js and css source tree and loading behaviour
gem 'sprockets', '< 4.0.0'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', '>= 1.1.0', require: false

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
  # Adds support for Capybara system testing and selenium driver
  gem 'capybara', '>= 2.15'
  gem 'selenium-webdriver'
  # Use sqlite3 as the database for Active Record
  gem 'sqlite3'
end

group :development do
  # Access an IRB console on exception pages or by using <%= console %> anywhere in the code.
  gem 'web-console', '>= 3.3.0'
  gem 'listen', '>= 3.0.5', '< 3.2'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end

group :production do
# Use postgres as the database for Active Record
  gem 'pg'
  # Use fog with AWS to upload and store image in production with heroku
  gem 'fog-aws'
  # Use Redis adapter to run Action Cable in production
  gem 'redis', '~> 4.0'
  # Use resque for ActiveJob queue
  gem 'resque'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]

# carmen gem to get countries and subregions lists with translation
gem 'carmen'

# Sort UTF8 strings in alphabetical order
gem 'sort_alphabetical', '~> 1.1'

# city-state to get a list of cities around the world
gem 'city-state', '~> 0.0.13'

# Use Figaro to store keys and secrets in environment variables
# Run: figaro heroku:set -e production
gem 'figaro'

# Methods to use Google Maps APIs
gem 'googlemaps-services'

# Use carrierwave for image upload
gem 'carrierwave'

# Use kanimari for pagination
gem 'kaminari', '~> 1.2'

# To generate fake username
gem 'faker', '~> 2.11'

# Use I18n in client side
gem "i18n-js"

# Security updates
gem "rack", ">= 2.2.3"
gem "websocket-extensions", ">= 0.1.5"
