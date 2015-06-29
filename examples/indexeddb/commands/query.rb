class IndexDB::Commands::Query < Capybara::AsyncRunner::Command
  ErrorDuringQuerying = Class.new(StandardError)

  self.command_name = 'indexeddb:query'
  self.file_to_run = 'commands/query'

  response :success
  response :error do |response|
    raise ErrorDuringQuerying, response
  end
end
