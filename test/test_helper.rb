ENV["RAILS_ENV"] ||= "test"
require_relative "../config/environment"
require "rails/test_help"
require_relative("_factories/factory_helper")

# https://github.com/simplecov-ruby/simplecov/issues/1082
require 'simplecov'
SimpleCov.start 'rails'
Rails.application.eager_load!

module ActiveSupport
  class TestCase
    include FactoryHelper

    # Run tests in parallel with specified workers
    parallelize(workers: :number_of_processors)

    # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
    fixtures :all

    # Add more helper methods to be used by all tests here...
    setup do
      # Bullet.start_request
    end

    teardown do
      # Bullet.perform_out_of_channel_notifications if Bullet.notification?
      # Bullet.end_request
    end
  end
end