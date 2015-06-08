require 'securerandom'

class Capybara::AsyncRunner::Command
  class << self
    attr_writer :command_name, :file_to_run

    def command_name
      @command_name or raise NotImplementedError, "You need to define self.command_name = ... in #{self}"
    end

    def file_to_run
      @file_to_run or raise NotImplementedError, "You need to define self.file_to_run = ... in #{self}"
    end
  end

  def uuid
    @uuid ||= SecureRandom.uuid
  end

  def run
    raise NotImplementedError
  end
end
