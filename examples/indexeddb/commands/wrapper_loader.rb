class IndexDB::WrapperLoader < Capybara::AsyncRunner::Command
  self.command_name = 'indexeddb:wrapper:inject'
  self.file_to_run = 'wrapper/inject'

  response :success
  response :error do
    raise 'Failed to inject script'
  end
end
