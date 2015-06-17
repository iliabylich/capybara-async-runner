class TestCommand < Capybara::AsyncRunner::Command
  self.command_name = 'with_result'
  self.file_to_run = 'example'

  response :done1
  response :done2
  response :done3
  response :done4, as: :callback
  response :done5 do |result|
    JSON.parse(result)
  end
end
