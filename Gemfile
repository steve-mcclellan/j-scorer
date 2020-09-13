# rubocop:disable FileName
source 'https://rubygems.org'

ruby '2.7.1'
gem 'rails', '~> 6.0.0'

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
gem 'sdoc', group: :doc

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

  # required for update task to Rails 6.0
  gem 'listen'
end

group :test do
  # Make test results appropriately colorful
  gem 'minitest-reporters'
  # Filter dependency info from backtraces
  gem 'mini_backtrace'
  # Make Travis CI happy
  gem 'rake'
  gem 'rubocop', require: false

  # The assigns and assert_template methods have been moved here
  gem 'rails-controller-testing', '1.0.4'
end

gem 'puma'
# By default, this will create a 15-second timeout.
# On j-scorer.com, it is set to 25 seconds via an environment variable
gem 'rack-timeout'

# Use Bootstrap to make things look prettier
gem 'bootstrap-sass', '~> 3.4.1'
# And a date-time-picker for convienient, er, date and time picking...
# Freezing this at 4.17.37, as 4.17.43 causes JS error "newZone() expects
# a string parameter", crashing the Game page. TODO: Investigate this.
gem 'bootstrap3-datetimepicker-rails', '4.17.37'
gem 'momentjs-rails', '>= 2.9.0'

# Allow for dynamic default values, like setting show_date and date_played
# to the date/time the game is created.
gem 'default_value_for', '~> 3.3.0'

# Allow for convenient(-ish) customization of the data displayed
# by "render :json".
gem 'active_model_serializers', '~> 0.10.10'
# rubocop:enable FileName
