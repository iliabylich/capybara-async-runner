# Internal class for building environment for rendering .js.erb code
#
class Capybara::AsyncRunner::Env
  # @param uuid [String] just a uuid of running command
  # @param data [Hash] data that is available in .erb through <%= data[:something] %>
  # @param responders [Hash<Symbol, Hash>] mapping method_name => options
  #
  # For responders:
  # @see Capybara::AsyncRunner::Commands::Responders
  #
  def initialize(uuid, data, responders)
    @uuid = uuid
    @data = data
    @responders = responders
  end
  attr_reader :data, :responders, :uuid

  # Returns a js environment that can be used for fetching data from the code on-the-fly
  #
  # @example
  #   # spec/support/async_runner/templates/command1.js.erb
  #   var jsLocal = 123;
  #   <%= done(js[:jsLocal] %>
  #
  def js_environment
    Hash.new do |h, k|
      k.to_s
    end
  end
  alias_method :js, :js_environment

  # Delegates a method to responder
  #
  # @example
  #   <%= responder1(js[:var1]) %>
  #
  # @see Capybara::AsyncRunner::Commands::Responders
  #
  def method_missing(method_name, *args)
    if responders.include?(method_name)
      response_method_for(method_name, *args)
    else
      super
    end
  end

  # @private
  def respond_to_missing?(method_name, include_private = false)
    super || responders.include?(method_name)
  end

  # Returns local binding that is used for rendering (ERB.new(template).result(binding))
  #
  # @return [Binding]
  #
  def local_binding
    binding
  end

  attr_reader :responders

  private

  def response_method_for(method_name, *args)
    options = responders[method_name][:options]
    if options[:as] == :callback
      <<-JS
      function() {
        var args = Array.prototype.slice.call(arguments, 0);
        window.Capybara[#{uuid.inspect}] = { from: #{method_name.to_s.inspect}, data: args };
      }
      JS
    else
      formatted_args = "[#{args.join(', ')}]"
      "window.Capybara[#{uuid.inspect}] = { from: #{method_name.to_s.inspect}, data: #{formatted_args} };"
    end
  end
end
