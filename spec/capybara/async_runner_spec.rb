require 'spec_helper'

describe Capybara::AsyncRunner do
  context 'configuration' do
    let(:directory) { double(:directory) }

    it 'can be configured with directory that contains commands' do
      Capybara::AsyncRunner.config.commands_directory = directory
      expect(Capybara::AsyncRunner.config.commands_directory).to eq(directory)
    end

    it 'can be flushed' do
      Capybara::AsyncRunner.config.commands_directory = directory
      Capybara::AsyncRunner.config.reset!
      expect(Capybara::AsyncRunner.config.commands_directory).to eq(nil)
    end
  end
end
