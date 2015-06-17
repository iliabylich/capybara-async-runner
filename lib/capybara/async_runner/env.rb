class Capybara::AsyncRunner::Env
  def initialize(uuid, data, responders)
    @uuid = uuid
    @data = data
    @responders = responders
  end
  attr_reader :data, :responders, :uuid

  def js_environment
    Hash.new do |h, k|
      k.to_s
    end
  end
  alias_method :js, :js_environment

  def method_missing(method_name, *args)
    if responders.include?(method_name)
      response_method_for(method_name, *args)
    else
      super
    end
  end

  def respond_to_missing?(method_name, include_private = false)
    super || responders.include?(method_name)
  end

  def local_binding
    binding
  end

  attr_reader :responders

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
