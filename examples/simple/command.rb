# Don't forget to run 'bundle install' before running this script
#
require 'pathname'
ROOT = Pathname.new(File.expand_path('../../..', __FILE__))
$: << ROOT.join('lib')

require 'capybara'
require 'capybara/async_runner'

# Base gem configuration
Capybara::AsyncRunner.setup do |config|
  config.commands_directory = ROOT.join('examples/simple')
end

# Defining a command
class TestCommand < Capybara::AsyncRunner::Command
  # global command name
  self.command_name = :json_and_timeout

  # .js.erb file in directory specified above
  self.file_to_run = 'template'

  response :parsed_json do |data|
    JSON.parse(data)
  end
end

# I'm using poltergeist as a webdriver here, but you can use whatever you want
require 'capybara/poltergeist'

# My command is totally abstract, so I'm running it in context of 'about:blank' page
Capybara.run_server = false
Capybara.default_driver = :poltergeist

p Capybara::AsyncRunner.run(:json_and_timeout)
# or TestCommand.new.invoke
