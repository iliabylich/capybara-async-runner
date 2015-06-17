module Capybara::AsyncRunner::Commands
  module Responders
    def self.included(base)
      base.send(:include, InstanceMethods)
      base.extend(ClassMethods)
    end

    module InstanceMethods
      def responders
        self.class.responders
      end
    end

    module ClassMethods
      def responders
        store[:responders] ||= {}
      end

      BLANK_PROXY = proc { |value| value }

      def response(method_name, options = {}, &block)
        mapping = {
          options: options,
          processor: block || BLANK_PROXY
        }
        responders[method_name] = mapping
      end
    end
  end
end
