source "https://rubygems.org"

gem "rails", "~> 7.2.1"
gem "sprockets-rails"

gem "puma"
gem "importmap-rails"
gem "turbo-rails"
gem "stimulus-rails"
gem "jbuilder"
gem "tzinfo-data", platforms: %i[ windows jruby ]
gem "bootsnap", require: false

gem "rails-i18n", "~> 7.0"
gem "dotenv"
gem "tailwindcss-rails"

gem "http"

group :development, :test do
  gem "debug", platforms: %i[ mri windows ], require: "debug/prelude"
  gem "brakeman", require: false
  gem 'rspec-rails'
  gem 'rubocop', require: false
  gem 'rubocop-performance', require: false
  gem 'rubocop-rails', require: false
  gem 'rubocop-rspec', require: false
  gem "rubocop-rails-omakase", require: false
end

group :development do
  gem "web-console"
  gem 'ruby-lsp'
  gem 'letter_opener_web', '~> 3.0'

  gem 'htmlbeautifier'

  gem 'bundler-audit'
  gem 'better_errors'
  gem 'binding_of_caller'

end
