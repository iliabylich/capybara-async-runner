module ResetConfigHelper
  def self.included(base)
    base.instance_eval do
      around(:each) do |example|
        begin
          Capybara::AsyncRunner.config.commands_directory = ROOT.join('spec/support/js')
          example.run
        ensure
          Capybara::AsyncRunner.config.reset!
        end
      end
    end
  end
end

RSpec.configure do |config|
  config.include ResetConfigHelper
end
