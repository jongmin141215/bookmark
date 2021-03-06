ENV['RACK_ENV'] = 'test'
require 'capybara/rspec'
require './app/app'
require './app/data_mapper_setup'
require 'database_cleaner'
require 'factory_girl'
require_relative 'helpers/session'
FactoryGirl.find_definitions

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

  config.include FactoryGirl::Syntax::Methods

  config.include SessionHelpers

end
