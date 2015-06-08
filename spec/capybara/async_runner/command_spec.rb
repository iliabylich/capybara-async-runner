require 'spec_helper'

describe Capybara::AsyncRunner::Command do
  context 'name configuration' do
    context 'when configured' do
      it 'just returns it' do
        expect(ConfiguredCommand.command_name).to eq('configured_command')
      end
    end

    context 'when not configured' do
      it 'raises error' do
        expect { BlankCommand.command_name }.
          to raise_error('You need to define self.command_name = ... in BlankCommand')
      end
    end
  end

  context 'filename configuration' do
    context 'when configured' do
      it 'just returns it' do
        expect(ConfiguredCommand.file_to_run).to eq('configured_file_to_run')
      end
    end

    context 'when not configured' do
      it 'raises error' do
        expect { BlankCommand.file_to_run }.
          to raise_error('You need to define self.file_to_run = ... in BlankCommand')
      end
    end
  end

  context 'auto-generated uuid' do
    subject(:command) { BlankCommand.new }

    it 'is a long string' do
      expect(command.uuid).to be_a(String)
    end

    it 'is memoized' do
      expect(command.uuid).to eq(command.uuid)
    end
  end
end
