class InfiniteCommand < Capybara::AsyncRunner::Command
  self.command_name = 'infinite'
  self.file_to_run = 'infinite'
end
