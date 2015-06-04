$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)

require 'simplecov'
require 'active_record'
require 'database_cleaner'
require 'rspec/its'

require_relative './db/boot'

Dir[File.join(File.dirname(__FILE__), "support/**/*.rb")].each { |f| require f }

SimpleCov.start do
  add_filter 'spec/activerecord'
  add_filter 'spec/statesman'
  add_filter 'spec/support'
  add_filter 'null_object'
end

require 'statesman/trigger'

RSpec.configure do |config|
  config.filter_gems_from_backtrace 'database_cleaner', 'activesupport'

  config.before(:suite) do
    DatabaseCleaner.strategy = :transaction
    DatabaseCleaner.clean_with :truncation
  end

  config.around(:each) do |example|
    DatabaseCleaner.cleaning do
      example.run
    end
  end
end
