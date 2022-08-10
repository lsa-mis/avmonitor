source 'https://rubygems.org'
git_source(:github) { |repo| 'https://github.com/#{repo}.git' }

ruby '3.1.2'

gem 'activerecord-oracle_enhanced-adapter', '~> 7.0', '>= 7.0.2'
gem 'bootsnap', require: false
gem 'devise', '~> 4.8'
gem 'em-redis', '~> 0.3.0'
gem 'faye-websocket', '~> 0.11.1'
gem 'importmap-rails'
gem 'jbuilder'
gem 'ldap_lookup', '~> 0.1.6'
# gem install mysql2 -v '0.5.4' -- --with-ldflags=-L/usr/local/opt/openssl/lib --with-cppflags=-I/usr/local/opt/openssl/include
gem 'mysql2', '~> 0.5.4'
gem 'omniauth-saml', '~> 2.1'
gem 'omniauth-rails_csrf_protection'
gem 'puma', '~> 5.0'
gem 'pundit', '~> 2.2'
gem 'rails', '~> 7.0.3.1'
gem 'ransack', '~> 3.2', '>= 3.2.1'
gem 'redis', '~> 4.0'
gem 'resolv', '~> 0.2.1'
gem 'ruby-oci8', '~> 2.2', '>= 2.2.11'
gem 'sidekiq', '~> 6.5', '>= 6.5.1'
gem 'sprockets-rails'
gem 'stimulus-rails'
gem 'tailwindcss-rails'
gem 'thin', '~> 1.8', '>= 1.8.1'
gem 'turbo-rails'
gem 'typhoeus', '~> 1.4'
gem 'tzinfo-data', platforms: %i[ mingw mswin x64_mingw jruby ]

# Use Kredis to get higher-level data types in Redis [https://github.com/rails/kredis]
# gem 'kredis'

group :development, :test do
  gem 'capistrano', '~> 3.10', require: false
  gem 'capistrano-rails', '~> 1.3', require: false
  gem 'capistrano-rbenv', '~> 2.2',   require: false
  gem 'debug', platforms: %i[ mri mingw x64_mingw ]
end

group :development do
  gem 'annotate', '~> 3.2'
  gem 'pry', '~> 0.14.1'
  # Use console on exceptions pages [https://github.com/rails/web-console]
  gem 'web-console'
end