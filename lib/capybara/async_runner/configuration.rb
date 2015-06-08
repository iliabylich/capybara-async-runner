class Capybara::AsyncRunner::Configuration
  def initialize
    @data = {}
  end

  def self.config_accessor(attribute_name, default = nil)
    define_method attribute_name do
      @data[attribute_name] || default
    end

    define_method "#{attribute_name}=" do |value|
      @data[attribute_name] = value
    end
  end

  config_accessor :commands_directory

  def reset!
    @data = {}
  end
end
