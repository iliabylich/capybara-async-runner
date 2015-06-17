require "capybara/async_runner/version"

module Capybara
  module AsyncRunner
    FailedToFetchResult = Class.new(StandardError)

    autoload :Configuration, 'capybara/async_runner/configuration'
    autoload :Command, 'capybara/async_runner/command'
    autoload :Env, 'capybara/async_runner/env'
    autoload :JsBuilder, 'capybara/async_runner/js_builder'
    autoload :WaitHelper, 'capybara/async_runner/wait_helper'
    autoload :Registry, 'capybara/async_runner/registry'

    # Returns current gem configuration.
    #
    # @return [Capybara::AsyncRunner::Configuration]
    #
    def self.config
      @config ||= Configuration.new
    end

    # Yields current configuration
    #
    # @yield [Capybara::AsyncRunner::Configuration]
    #
    # @example
    #   Capybara::AsyncRunner.setup do |config|
    #     config.commands_directory = Rails.root.join('spec/support/async_runner')
    #   end
    #
    def self.setup
      yield config
    end

    # Runs command that has provided +command_name+ and passes provided +data+
    #
    # @example
    #   class MyCoolCommand < Capybara::AsyncRunner::Command
    #     self.command_name = 'cool_command'
    #     self.file_to_run = 'path/to/cool/command'
    #   end
    #
    #   Capybara::AsyncRunner.run(:cool_command)
    #
    def self.run(command_name, data = {})
      Registry[command_name].new(data).invoke
    end
  end
end
