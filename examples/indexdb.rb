require 'pathname'
ROOT = Pathname.new(File.expand_path('../..', __FILE__))
$: << ROOT.join('lib')

require 'capybara'
require 'capybara/async_runner'
require 'capybara/poltergeist'
require 'pry'

Capybara.run_server = false
Capybara.default_driver = :poltergeist

Capybara::AsyncRunner.config.commands_directory = ROOT.join('examples')

class IndexDBWrapperLoader < Capybara::AsyncRunner::Command
  self.command_name = :inject_indexeddb_wrapper
  self.file_to_run = 'indexeddb_injector'

  response :success
end

class IndexDBSample < Capybara::AsyncRunner::Command
  self.command_name = :indexdb_test
  self.file_to_run = 'indexdb'

  response :fail_with_error do |data|
    binding.pry
    data
  end

  response :plain_success
  response :parsed_json do |data|
    JSON.parse(data)
  end
end

Capybara.current_session.visit('http://google.com')
wrapper_url = "https://raw.githubusercontent.com/dfahlander/Dexie.js/master/src/Dexie.js"
Capybara::AsyncRunner.run(:inject_indexeddb_wrapper, url: wrapper_url)
p Capybara::AsyncRunner.run(:indexdb_test, data)
