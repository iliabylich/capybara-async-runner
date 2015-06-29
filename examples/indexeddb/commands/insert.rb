class IndexDB::Commands::Insert < Capybara::AsyncRunner::Command
  FailedToInsertData = Class.new(StandardError)

  self.command_name = 'indexeddb:insert'
  self.file_to_run = 'commands/insert'

  response :error do |response|
    raise FailedToInsertData, response
  end

  response :success
end
