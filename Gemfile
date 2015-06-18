source 'https://rubygems.org'


# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.2.2'
# Use postgresql as the database for Active Record
gem 'pg'
# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'

# Use jquery as the JavaScript library
gem 'jquery-rails'
# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.0'
# bundle exec rake doc:rails generates the API under doc/api.
# gem 'sdoc', '~> 0.4.0', group: :doc

# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use Puma as the app server
gem 'puma'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

gem 'travis'
gem 'coveralls', require: false
gem 'bourbon'
gem 'neat'
gem 'autoprefixer-rails'

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug'

  # Access an IRB console on exception pages or by using <%= console %> in views
  gem 'web-console', '~> 2.0'

  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'pry'
  gem 'rubocop', '0.29.1'
end

group :test do
  gem 'sqlite3', '~> 1.3.9'
  gem 'activerecord-nulldb-adapter'
end

group :acceptance, :travis do
  gem 'cucumber-rails', '~> 1.4.1', :require => false
  gem 'database_cleaner', '~> 1.3.0'
  gem 'capybara-screenshot', '~> 1.0.4'
  gem 'poltergeist', '~> 1.5.1'
  gem 'launchy', '~> 2.4.2'
  gem 'rack_session_access', '~> 0.1.1'
end

group :acceptance, :test, :travis do
  gem 'rspec-rails'
end

gem 'rails_12factor', group: :production

ruby '2.2.2'
