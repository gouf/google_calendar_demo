# frozen_string_literal: true

source 'https://rubygems.org'

git_source(:github) { |repo_name| "https://github.com/#{repo_name}" }

# Object-relational mapper framework (part of Rails). (https://rubyonrails.org)
gem 'activerecord'
# Client for accessing Google APIs (https://github.com/google/google-api-ruby-client)
gem 'google-api-client'
# Automatic Ruby code style checking tool. (https://github.com/rubocop-hq/rubocop)
gem 'rubocop'
# This module allows Ruby programs to interface with the SQLite3 database engine (http://www.sqlite.org) (https://github.com/sparklemotion/sqlite3-ruby)
gem 'sqlite3'

group :development, :test do
  # Strategies for cleaning databases.  Can be used to ensure a clean state for testing. (http://github.com/DatabaseCleaner/database_cleaner)
  gem 'database_cleaner'
  # factory_bot provides a framework and DSL for defining and using model instance factories. (https://github.com/thoughtbot/factory_bot)
  gem 'factory_bot'
  # the instafailing RSpec progress bar formatter (https://github.com/thekompanee/fuubar)
  gem 'fuubar'
  # rspec-3.9.0 (http://github.com/rspec)
  gem 'rspec'
  # Record your test suite's HTTP interactions and replay them during future test runs for fast, deterministic, accurate tests. (https://relishapp.com/vcr/vcr/docs)
  gem 'vcr'
  # Library for stubbing HTTP requests in Ruby. (http://github.com/bblimke/webmock)
  gem 'webmock'
end

group :development do
  # An IRB alternative and runtime developer console (http://pryrepl.org)
  gem 'pry'
  # Guard keeps an eye on your file modifications (http://guardgem.org)
  gem 'guard'
  # Guard gem for RSpec (https://github.com/guard/guard-rspec)
  gem 'guard-rspec'
end

group :test do
  # Code coverage for Ruby 1.9+ with a powerful configuration library and automatic merging of coverage across test suites (http://github.com/colszowka/simplecov)
  gem 'simplecov'
end
