require 'erb'

# Internal class for executing javascript code.
#  Don't use directly
#
class Capybara::AsyncRunner::JsBuilder
  # @param env [Capybara::AsyncRunner::Env] context of erb
  # @param erb [String] erb template with js code
  #
  def initialize(env, erb)
    @env = env
    @erb = erb
  end

  attr_reader :env, :erb

  # Executes provided code and returns its result
  #
  # @return [Object]
  #
  # @raise [Capybara::AsyncRunner::FailedToFetchResult] when javascript VM doesn't have any response after timeout
  #
  def result
    Capybara.current_session.evaluate_script(calculation_code)

    ResponseProcessor.new(raw_result, env.responders).result
  end

  private

  def raw_result
    RawResult.new(env.uuid).fetch or
      raise Capybara::AsyncRunner::FailedToFetchResult, "No response for command with uuid = #{env.uuid}"
  end

  RawResult = Struct.new(:uuid) do
    def fetch
      Capybara::AsyncRunner::WaitHelper.wait_until(2) do
        Capybara.current_session.evaluate_script(result_code)
      end
    end

    def result_code
      "window.Capybara[#{uuid.inspect}]"
    end
  end

  ResponseProcessor = Struct.new(:raw_result, :responders) do
    def method_name
      raw_result['from'].to_sym
    end

    def data
      raw_result['data'][0]
    end

    def responder
      responders[method_name][:processor]
    end

    def result
      responder.call(data)
    end
  end

  def calculation_code
    <<-JS
    function() {
      if (typeof(window.Capybara) === 'undefined') {
        window.Capybara = {};
      }
      #{dynamic_code}
    }()
    JS
  end

  def dynamic_code
    ERB.new(erb).result(env.local_binding)
  end
end
