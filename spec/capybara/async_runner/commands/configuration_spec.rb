require 'spec_helper'

describe Capybara::AsyncRunner::Command do
  around(:each) do |example|
    begin
      class ConfiguredCommand < Capybara::AsyncRunner::Command
        self.command_name = 'configured_command'
        self.file_to_run = 'configured_file_to_run'
      end

      class BlankCommand < Capybara::AsyncRunner::Command
      end

      class InheritedCommand < ConfiguredCommand
      end

      class InheritedAndCustomizedCommand < ConfiguredCommand
        self.command_name = 'another_command_name'
      end

      example.run
    ensure
      [
        :ConfiguredCommand,
        :BlankCommand,
        :InheritedCommand,
        :InheritedAndCustomizedCommand
      ].each do |const_name|
        Object.send(:remove_const, const_name)
      end
    end
  end

  context 'when configured' do
    subject(:command) { ConfiguredCommand }
    its(:command_name) { is_expected.to eq('configured_command') }
    its(:file_to_run) { is_expected.to eq('configured_file_to_run') }
  end

  context 'when not configured' do
    subject(:command) { BlankCommand }

    let(:error) do
      {
        command: 'You need to define self.command_name = ... in BlankCommand',
        filename: 'You need to define self.file_to_run = ... in BlankCommand'
      }
    end

    it 'raises error for command name' do
      expect { BlankCommand.command_name }.to raise_error(error[:command])
    end

    it 'raises error for file' do
      expect { BlankCommand.file_to_run }.to raise_error(error[:filename])
    end
  end

  context 'inheritance' do
    it 'is inheritable' do
      expect(InheritedCommand.command_name).to eq('configured_command')
      expect(InheritedCommand.file_to_run).to eq('configured_file_to_run')

      expect(InheritedAndCustomizedCommand.command_name).to eq('another_command_name')
      expect(InheritedAndCustomizedCommand.file_to_run).to eq('configured_file_to_run')
    end
  end
end
