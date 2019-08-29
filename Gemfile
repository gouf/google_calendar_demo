# frozen_string_literal: true

source 'https://rubygems.org'

git_source(:github) { |repo_name| "https://github.com/#{repo_name}" }

# Object-relational mapper framework (part of Rails). (https://rubyonrails.org)
gem 'activerecord'
# Client for accessing Google APIs (https://github.com/google/google-api-ruby-client)
gem 'google-api-client'
# Automatic Ruby code style checking tool. (https://github.com/rubocop-hq/rubocop)
gem 'rubocop'

group :development, :test do
  # the instafailing RSpec progress bar formatter (https://github.com/thekompanee/fuubar)
  gem 'fuubar'
  # rspec-3.8.0 (http://github.com/rspec)
  gem 'rspec'
  # Record your test suite's HTTP interactions and replay them during future test runs for fast, deterministic, accurate tests. (https://relishapp.com/vcr/vcr/docs)
  gem 'vcr'
  # Library for stubbing HTTP requests in Ruby. (http://github.com/bblimke/webmock)
  gem 'webmock'
end

group :development do
  # Guard keeps an eye on your file modifications (http://guardgem.org)
  gem 'guard'
  # Guard gem for RSpec (https://github.com/guard/guard-rspec)
  gem 'guard-rspec'
end
