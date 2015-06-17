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

    def self.config
      @config ||= Configuration.new
    end

    def self.run(command_name, data = {})
      Registry[command_name].new(data).invoke
    end
  end
end
