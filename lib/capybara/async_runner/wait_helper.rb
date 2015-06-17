module Capybara::AsyncRunner::WaitHelper
  extend self

  def wait_until(timeout, &block)
    begin
      Timeout.timeout(timeout) do
        sleep(0.1) until value = block.call
        value
      end
    rescue TimeoutError
      false
    end
  end
end
