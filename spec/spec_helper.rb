ROOT = Pathname.new(File.expand_path('../..', __FILE__))
$LOAD_PATH << ROOT.join('lib')

require 'rspec/its'

require 'pry'
require 'capybara/async_runner'
require 'capybara'
require 'capybara/poltergeist'

Capybara.run_server = false
Capybara.default_driver = :poltergeist

# support files
Dir[ROOT.join('spec/support/**/*.rb')].each { |f| require f }

RSpec.configure do |config|
  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end
end
