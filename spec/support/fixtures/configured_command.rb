class ConfiguredCommand < Capybara::AsyncRunner::Command
  self.command_name = 'configured_command'
  self.file_to_run = 'configured_file_to_run'
end
