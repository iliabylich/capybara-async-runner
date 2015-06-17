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

  describe '.run' do
    it 'running commands using shortcut' do
      $requesting = 'from-context'
      result = Capybara::AsyncRunner.run(:with_result, number: 123)
      expect(result).to eq(246)
    end
  end
end
