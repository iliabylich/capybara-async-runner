# Module for defining your responders
#
# Responder is a method that you should call in you .js code
#
# @example
#   class MyCommand < Capybara::AsyncRunner::Commands
#     response :done
#     response :fail, as: :callback
#     response :parsed_json do |data|
#       JSON.parse(data)
#     end
#
#   # template
#   if (done) {
#     <%= done %>
#   } else if (fail) {
#     afterFail(<%= fail %>)
#   } eles if (returnedJSON) {
#     <%= parsed_json(js[:returnedJSON]) %>
#   }
#
# Only one responder can be executed for 1 script during 1 invokation
#
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

      # Defines a responder for script
      #
      # @param method_name [String, Symbols]
      # @param options [Hash]
      # @option options [Symbol] :as can be :callback
      # @yield raw_data from script
      #
      # raw_data will be returned if no block provided
      #
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
