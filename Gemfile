source 'https://rubygems.org'
ruby "2.2.3"

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.2.3'

# Load dotenv _before_ Global, so that Global can pick up environment variables
# set by dotenv.
gem 'dotenv-rails', :require => 'dotenv/rails-now'

# Use Global for configuration data parsing/loading
gem 'global'

# REST client
gem 'rest-client'

# Devise & Omniauth (auth, oauth)
gem 'devise'
gem 'omniauth'

# Omniauth support for GitHub OAuth service
gem 'omniauth-github'

# Use Bootstrap (Sass version)
gem 'bootstrap-sass', '~> 3.3.5'

# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0'

# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails', '~> 4.1.0'
# See https://github.com/rails/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby

# Use jquery as the JavaScript library
gem 'jquery-rails'
# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.0'
# bundle exec rake doc:rails generates the API under doc/api.
gem 'sdoc', '~> 0.4.0', group: :doc

# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use Unicorn as the app server
# gem 'unicorn'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

# Use Postgres, as that DB is available on Heroku.
gem 'pg'

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug'

  # Access an IRB console on exception pages or by using <%= console %> in views
  gem 'web-console', '~> 2.0'

  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'

  # Quiet asset serve logging.
  gem 'quiet_assets'

  # Debug data creator
  gem 'faker'
end

group :production do
  # Heroku static file serving helper.
  gem 'rails_12factor'
end
