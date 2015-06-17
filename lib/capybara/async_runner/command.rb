require 'securerandom'
require 'capybara/async_runner/commands/configuration'
require 'capybara/async_runner/commands/responders'
require 'capybara/async_runner/commands/templates'

# A common class for defining your commands
#
# Every command MUST have a name and a .js.erb file
#
# @example
#   # spec/support/async_runner/commands/some_command.rb
#   #
#   class SomeCommand < Capybara::AsyncRunner::Command
#     self.command_name = :some_command_name
#     self.file_to_run = 'your/path/to/file/without/extension'
#
#     response :done
#     response :fail do |data|
#       JSON.parse(data)
#     end
#   end
#
#   SomeCommand.new({}).invoke
#   # => result
#
class Capybara::AsyncRunner::Command
  include Capybara::AsyncRunner::Commands::Configuration
  include Capybara::AsyncRunner::Commands::Responders
  include Capybara::AsyncRunner::Commands::Templates

  # @param data [Hash] data is available in template through <%= data %>
  #
  def initialize(data = {})
    @uuid = SecureRandom.uuid
    @env = Capybara::AsyncRunner::Env.new(uuid, data, responders)
  end

  attr_reader :uuid, :env

  # Invokes the command and returns its result
  #
  # @see Capybara::AsyncRunner::JsBuilder
  # @see Capybara::AsyncRunner::Env
  #
  def invoke
    js_builder.result
  end

  private

  def js_builder
    @js_builder ||= Capybara::AsyncRunner::JsBuilder.new(@env, erb)
  end

  def self.inherited(klass)
    super
    Capybara::AsyncRunner::Registry << klass
  end
end
