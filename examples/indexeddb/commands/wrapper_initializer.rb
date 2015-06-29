class IndexDB::WrapperInitializer < Capybara::AsyncRunner::Command
  self.command_name = 'indexeddb:wrapper:initialize'
  self.file_to_run = 'wrapper/initialize'

  response :error do |response|
    raise "Client error: #{response}"
  end

  response :success
end
