source 'https://rubygems.org'
ruby '2.3.3'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 4.2.9.rc1'

# Use SCSS for stylesheets
gem 'sass-rails'

# Bootstrap
gem 'bootstrap-sass'

gem 'autoprefixer-rails'
# See https://github.com/rails/execjs#readme for more supported runtimes
gem 'therubyracer', platforms: :ruby

# Sprockets implementation for Rails
gem 'sprockets', '3.6.3'

# Webpacker for handling our JS assets
gem 'webpacker', '~> 2.0'

# Use Postgresql for production
gem 'pg'

# Send mails
gem 'mail'

# track errors with rollbar
gem 'rollbar'

# User pg_search for search
gem 'pg_search'

# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder'
# bundle exec rake doc:rails generates the API under doc/api.
gem 'sdoc', '~> 0.4.0', group: :doc

# Devise for users
gem 'devise', '~> 4.1.0'
gem 'omniauth'
gem 'omniauth-linkedin-oauth2', git: "git://github.com/decioferreira/omniauth-linkedin-oauth2.git"
gem 'figaro'
gem 'typhoeus'

# Paperclip for handling files (profile photos mainly) + Amazon S3
gem 'paperclip'
gem 'aws-sdk'

# Admin for our usage
gem 'rails_admin'

gem 'draper'
gem 'language_list'
gem 'pundit'
gem 'ransack'
gem 'phonelib'
gem 'seedbank'
gem 'csv-importer'
gem 'friendly_id', '~> 5.1.0'
gem 'rails4-autocomplete'
gem 'select2-rails'
gem 'hashie-forbidden_attributes'

# Remove unnecessary whitespaces from ActiveRecord or ActiveModel
gem 'auto_strip_attributes', '~> 2.1'

# API related
gem 'grape'
gem 'doorkeeper'

# Grape extensions
gem 'wine_bouncer'
gem 'grape-kaminari'
gem 'grape-active_model_serializers'
gem 'grape-route-helpers'

# Swagger
gem 'grape-swagger', '~> 0.26.0'
gem 'grape-swagger-rails', '~> 0.2.0'

group :production, :staging do
  gem 'rails_12factor'
end

group :development, :test do
  gem 'byebug'
  gem 'awesome_print', require: 'ap'
  gem 'quiet_assets'
  gem 'pry-rails'
  gem 'faker'
end

group :development do
  gem 'spring'
  gem 'guard-livereload', require: false
  gem 'annotate'
  gem 'better_errors'
  gem 'web-console'
  gem 'seed_dump'
end

group :test do
  gem 'factory_girl_rails'
  gem 'rspec-rails'
  gem 'mocha'
  gem 'database_cleaner'
  gem 'rails_best_practices', require: false
end
