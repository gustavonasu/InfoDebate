source 'https://rubygems.org'

gem 'rails', '3.2.6'
gem 'rack', '1.4.1'

gem 'gravatar_image_tag', '1.1.3'
gem 'will_paginate', '3.0.3'

gem 'jquery-rails'

group :production do
  gem 'pg', '0.13.0'
end

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails',   '~> 3.2.3'
  gem 'bootstrap-sass', '~> 2.2.1.1'
  gem 'coffee-rails', '~> 3.2.1'
  gem 'uglifier', '>= 1.0.3'
  gem "select2-rails", "~> 3.2.1"
end

gem 'sqlite3-ruby', '1.3.3', :require => 'sqlite3', :group => [:development, :test]

group :development do
  gem 'rspec-rails', '2.11.0'
  gem 'annotate', '2.5.0'
  gem 'faker', '1.0.1'
end

group :test do
  gem 'rspec', '2.11.0'
  gem 'webrat', '0.7.3'
  gem 'spork', '0.9.2'
  gem 'factory_girl_rails', '4.0.0'
end
