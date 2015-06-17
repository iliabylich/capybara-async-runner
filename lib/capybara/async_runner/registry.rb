module Capybara::AsyncRunner::Registry
  def self.<<(command_klass)
    all << command_klass
  end

  def self.[](command_name)
    all.detect { |klass| klass.command_name.to_s == command_name.to_s }
  end

  private

  def self.all
    @all ||= []
  end
end
