# Module for confoiguring your commands
#
# @example
#   class SomeCommand < Capybara::AsyncRunner::Command
#     self.command_name = 'my_command_name'
#     # (use underscores, your can later call them by passing symbols)
#     self.file_to_run = 'path/to/your/file'
#   end
#
module Capybara::AsyncRunner::Commands
  module Configuration
    def self.included(base)
      base.extend(ClassMethods)
    end

    module ClassMethods
      # Returns configured command name or raises error
      #
      # @return [String, Symbol]
      #
      # @raise NotImplementedError
      #
      def command_name
        store[:command_name] or
          raise NotImplementedError, "You need to define self.command_name = ... in #{self}"
      end

      # Saves provided +command_name+
      #
      # @param command_name [String]
      #
      def command_name=(command_name)
        store[:command_name] = command_name
      end

      # Returns configured filepath or raises error
      #
      # @return [String, Symbol]
      #
      # @raise NotImplementedError
      #
      def file_to_run
        store[:file_to_run] or
          raise NotImplementedError, "You need to define self.file_to_run = ... in #{self}"
      end

      # Stores provided relative +file_to_run+ (don't include directory and extension)
      #
      # @param file_to_run [String]
      #
      def file_to_run=(file_to_run)
        store[:file_to_run] = file_to_run
      end

      # @private
      #
      # Inherits all configuration from parent
      #
      def inherited(klass)
        super
        return if self == Capybara::AsyncRunner::Command
        klass.command_name = self.command_name
        klass.file_to_run = self.file_to_run
      end

      private

      # @private
      def store
        @store ||= {}
      end
    end
  end
end
