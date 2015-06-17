require 'spec_helper'

describe Capybara::AsyncRunner::Command do
  context 'auto-generated uuid' do
    subject(:command) { TestCommand.new }

    it 'is a long string' do
      expect(command.uuid).to be_a(String)
    end

    it 'is memoized' do
      expect(command.uuid).to eq(command.uuid)
    end
  end

  context '#invoke' do
    let(:command) { TestCommand.new(data) }
    let(:data) { {} }
    subject(:result) { command.invoke }

    context 'when requesting for a local variable' do
      before { $requesting =  'local-variable' }
      it { is_expected.to eq('local-variable') }
    end

    context 'when requesting for a data from context' do
      before { $requesting = 'from-context' }
      let(:data) { { number: 15 } }
      it { is_expected.to eq(30) }
    end

    context 'when requesting as callback' do
      before { $requesting = 'as-callback' }
      it { is_expected.to eq('as-callback') }
    end

    context 'when requesting for something with post-processing' do
      before { $requesting = 'with-processing' }
      let(:expected) { { 'a' => 1, 'b' => 2, 'c' => 'three' } }
      it { is_expected.to eq(expected) }
    end

    context 'when command fails with timeout' do
      let(:command) { InfiniteCommand.new(data) }

      it 'raises error' do
        expect { result }.to raise_error(Capybara::AsyncRunner::FailedToFetchResult)
      end
    end
  end
end
