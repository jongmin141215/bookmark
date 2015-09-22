ENV['RACK_ENV'] = 'test'
require 'capybara/rspec'
require './app/app'
require './app/data_mapper_setup'
require 'database_cleaner'

Capybara.app = BookmarkManager

RSpec.configure do |config|

  config.before(:suite) do
    DatabaseCleaner.strategy = :transaction
    DatabaseCleaner.clean_with(:truncation)
  end

  config.before(:each) do
    DatabaseCleaner.start
  end

  config.after(:each) do
    DatabaseCleaner.clean
  end

end
