# Don't forget to run 'bundle install' before running this script
#
require 'pathname'
ROOT = Pathname.new(File.expand_path('../..', __FILE__))
$: << ROOT.join('lib')

require 'capybara'

# put this to your spec_helper
#
require 'capybara/async_runner'

Capybara::AsyncRunner.setup do |config|
  # Change the directory here to you spec/support/async_runner/templates
  #
  config.commands_directory = ROOT.join('examples')
end

# Put this to spec/support/async_runner/commands/command_with_json.rb
#
class CommandThatReturnsJSONAfterTimeout < Capybara::AsyncRunner::Command
  self.command_name = :using_timeout
  self.file_to_run = 'using_timeout'

  response :parsed_json do |data|
    JSON.parse(data)
  end
end

# I'm using poltergeist here, but you can use whatever you want
require 'capybara/poltergeist'

# My command is abstract, so I'm running it in 'about:blank'
Capybara.run_server = false
Capybara.default_driver = :poltergeist

p Capybara::AsyncRunner.run(:using_timeout)
# or CommandThatReturnsJSONAfterTimeout.new.invoke