require "capybara/async_runner/version"

module Capybara
  module AsyncRunner
    autoload :Configuration, 'capybara/async_runner/configuration'
    autoload :Command, 'capybara/async_runner/command'

    def self.config
      @config ||= Configuration.new
    end
  end
end
