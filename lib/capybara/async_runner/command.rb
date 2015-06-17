require 'securerandom'
require 'capybara/async_runner/commands/configuration'
require 'capybara/async_runner/commands/responders'
require 'capybara/async_runner/commands/templates'

class Capybara::AsyncRunner::Command
  include Capybara::AsyncRunner::Commands::Configuration
  include Capybara::AsyncRunner::Commands::Responders
  include Capybara::AsyncRunner::Commands::Templates

  def initialize(data = {})
    @uuid = SecureRandom.uuid
    @env = Capybara::AsyncRunner::Env.new(uuid, data, responders)
  end

  attr_reader :uuid, :env

  def invoke
    js_builder.result
  end

  def js_builder
    @js_builder ||= Capybara::AsyncRunner::JsBuilder.new(@env, erb)
  end

  def self.inherited(klass)
    super
    Capybara::AsyncRunner::Registry << klass
  end
end
