# Class for configuring a gem
#
# @example
#   config = Capybara::AsyncRunner::Configuration
#   config.commands_directory = 'some/dir'
#
class Capybara::AsyncRunner::Configuration
  def initialize
    @data = {}
  end

  # A DSL for defining accessors with default values
  #
  # @example
  #   config_accessor :access_name # no default value
  #   config_accessor :timeout, 12
  #
  def self.config_accessor(attribute_name, default = nil)
    define_method attribute_name do
      @data[attribute_name] || default
    end

    define_method "#{attribute_name}=" do |value|
      @data[attribute_name] = value
    end
  end

  # Returns directory that contains all command files
  #
  config_accessor :commands_directory

  # Drops all configured values
  #
  def reset!
    @data = {}
  end
end
