module Capybara::AsyncRunner::Commands
  module Templates
    def erb
      fullname = self.class.file_to_run + '.js.erb'
      filepath = Capybara::AsyncRunner.config.commands_directory.join(fullname)
      File.read(filepath)
    end
  end
end
