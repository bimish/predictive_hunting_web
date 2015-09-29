source 'https://rubygems.org'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
#gem 'rails', '4.0.3'
gem 'rails', '~> 4.2.4'

# Use postgresql as the database for Active Record
gem 'pg'

# Use SCSS for stylesheets
gem 'sass-rails'
gem 'compass-rails'

# Use Uglifier as compressor for JavaScript assets
gem 'uglifier'

# Use CoffeeScript for .js.coffee assets and views
gem 'coffee-rails', '~> 4.1.0'

# See https://github.com/sstephenson/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby

# Use jquery as the JavaScript library
gem 'jquery-rails'
gem "jquery-ui-rails"
gem 'jquery_mobile_rails'

# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks', '~> 2.5.3'

# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder'

gem "bootstrap-sass", "~> 3.3.5.1"
gem 'bootstrap_form'
gem "will_paginate", "~> 3.0.7"
gem 'will_paginate-bootstrap'

# PostGIS support gems
gem "rgeo", require: false
gem "rgeo-activerecord", "~> 4.0.0"
gem "activerecord-postgis-adapter", "~> 3.0.0"

group :doc do
  # bundle exec rake doc:rails generates the API under doc/api.
  gem 'sdoc', require: false
end

group :development, :test do
  gem "faker", "~> 1.3.0"
  gem 'rspec-rails', '~> 2.14.1'
  gem 'guard-rspec', '~> 4.2.8'
  gem 'annotate', '~> 2.6.2'
  #gem 'web-console', '~> 2.0'
  gem 'capistrano',         require: false
  gem 'capistrano-rvm',     require: false
  gem 'capistrano-rails',   require: false
  gem 'capistrano-bundler', require: false
  gem 'capistrano3-puma',   require: false
end

group :test do
  gem 'capybara', '~> 2.2.1'
  gem 'rb-inotify', '~> 0.9.3'
  gem 'libnotify', '~> 0.8.2'
  gem 'guard-spork', '~> 1.5.1'
  gem 'spork', '~> 0.9.2'
  gem 'factory_girl_rails', '~> 4.4.1'
  gem 'launchy', '~> 2.4.2'
end

group :production do
  #gem 'rails_12factor'
end

# Use ActiveModel has_secure_password
#gem 'bcrypt-ruby', '~> 3.1.5'
gem 'bcrypt', '~> 3.1.7'

source "https://rubygems.org"
ruby "2.2.2"

# Use unicorn as the app server
#gem 'unicorn'
gem 'puma'

# Use Capistrano for deployment
# gem 'capistrano', group: :development

# Use debugger
# gem 'debugger', group: [:development, :test]

#gem 'newrelic_rpm'
