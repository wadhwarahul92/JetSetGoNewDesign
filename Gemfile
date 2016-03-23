source 'https://rubygems.org'

ruby '2.2.3'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.2.5'
# Use mysql as the database for Active Record
gem 'mysql2'
# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails', '~> 4.1.0'
# See https://github.com/rails/execjs#readme for more supported runtimes
gem 'therubyracer', platforms: :ruby

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

group :development, :test do

  gem 'rspec-rails', '~> 3.0'

  gem 'factory_girl_rails'

  gem 'dotenv-rails'

end

group :development do
  # Access an IRB console on exception pages or by using <%= console %> in views
  # gem 'web-console', '~> 2.0'

  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'

  gem 'query_diet'

  gem 'letter_opener'
end

group :production do
  gem 'rails_12factor'

  gem 'exception_notification'

  gem 'ffaker'
end

gem 'simple_form'

gem 'devise'

gem 'puma'

#heroku kills request that take more that 30 seconds to process, we shall takeover it and kill in 25 seconds
gem 'rack-timeout'

gem 'delayed_job_active_record'

gem 'paperclip', '~> 4.3'

gem 'aws-sdk'

gem 'paper_trail', '~> 4.0.0'

gem 'will_paginate'

gem 'wicked_pdf'

gem 'wkhtmltopdf-binary'

gem 'bootstrap-datepicker-rails'

gem 'foundation-rails'

gem 'slim-rails' #todo remove this and convert all slim files to erb

gem 'rmagick'

gem 'time_diff'

gem 'paranoia', '~> 2.0'

gem 'nokogiri'

gem 'premailer-rails'

gem 'newrelic_rpm'

gem 'httparty'

gem 'rubyXL'