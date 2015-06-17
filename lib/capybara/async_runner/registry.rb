# Module for storing all defined commands
#
# @example
#   Capybara::AsyncRunner::Registry << SomeKlass
#   Capybara::AsyncRunner::Registry[:some_name]
#   # => SomeKlass
#
# You don't need to use this class directly, the gme does everything for you
#
module Capybara::AsyncRunner::Registry
  # Stores provided +command_klass+ internally
  #
  # @param command_klass [Capybara::AsyncRunner::Command]
  #
  def self.<<(command_klass)
    all << command_klass
  end

  # Returns first stored command that has provided +command_name+
  #
  # @paran command_name [String, Symbol]
  #
  def self.[](command_name)
    all.detect { |klass| klass.command_name.to_s == command_name.to_s }
  end

  private

  def self.all
    @all ||= []
  end
end
