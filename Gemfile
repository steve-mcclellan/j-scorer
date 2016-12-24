source 'https://rubygems.org'

ruby '2.3.3'
gem 'rails', '~> 4.2.6'

# Use postgresql as the database for Active Record
gem 'pg', '~> 0.15'
# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# Use CoffeeScript for .coffee assets and views
# gem 'coffee-rails', '~> 4.1.0'
# See https://github.com/rails/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby

# Use jquery as the JavaScript library
gem 'jquery-rails'
gem 'jquery-ui-rails'

# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
# gem 'turbolinks'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.0'
# bundle exec rake doc:rails generates the API under doc/api.
gem 'sdoc', '~> 0.4.0', group: :doc

# Use ActiveModel has_secure_password
gem 'bcrypt', '~> 3.1.7'

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug'
end

group :development do
  # Access an IRB console on exception pages or by using <%= console %> in views
  gem 'web-console'

  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
end

group :test do
  # Make test results appropriately colorful
  gem 'minitest-reporters'
  # Filter dependency info from backtraces
  gem 'mini_backtrace'
  # Make Travis CI happy
  gem 'rake'
  gem 'rubocop', require: false
end

# Heroku will gripe if this isn't present
gem 'rails_12factor', group: :production
# Use better webserver than Rails default
gem 'puma'
# Without an initializer file, use default timeout of 15 seconds
gem 'rack-timeout'

# Use Bootstrap to make things look prettier
gem 'bootstrap-sass', '~> 3.3.6'
# And a date-time-picker for convienient, er, date and time picking...
# Freezing this at 4.17.37, as 4.17.43 causes JS error "newZone() expects
# a string parameter", crashing the Game page. TODO: Investigate this.
gem 'momentjs-rails', '>= 2.9.0'
gem 'bootstrap3-datetimepicker-rails', '4.17.37'

# Allow for dynamic default values, like setting show_date and date_played
# to the date/time the game is created.
gem 'default_value_for', '~> 3.0.0'

# Allow for convenient(-ish) customization of the data displayed
# by "render :json".
gem 'active_model_serializers', '~> 0.10.0'
