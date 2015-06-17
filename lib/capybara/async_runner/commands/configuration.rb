module Capybara::AsyncRunner::Commands
  module Configuration
    def self.included(base)
      base.extend(ClassMethods)
    end

    module ClassMethods
      def command_name
        store[:command_name] or
          raise NotImplementedError, "You need to define self.command_name = ... in #{self}"
      end

      def command_name=(command_name)
        store[:command_name] = command_name
      end

      def file_to_run
        store[:file_to_run] or
          raise NotImplementedError, "You need to define self.file_to_run = ... in #{self}"
      end

      def file_to_run=(file_to_run)
        store[:file_to_run] = file_to_run
      end

      def inherited(klass)
        super
        return if self == Capybara::AsyncRunner::Command
        klass.command_name = self.command_name
        klass.file_to_run = self.file_to_run
      end

      private

      def store
        Thread.current[:capybara_async_runner] ||= {}
        Thread.current[:capybara_async_runner][self.name] ||= {}
      end
    end
  end
end
