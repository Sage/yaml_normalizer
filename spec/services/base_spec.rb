# frozen_string_literal: true

require 'spec_helper'

RSpec.describe YamlNormalizer::Services::Base do
  describe '.call' do
    subject { described_class }

    let(:args) { [:foo, 'bar', 842] }
    let(:instance) { double('SubClassOfBase', call: nil) }

    it 'creates an instance and passes all arguments' do
      expect(subject).to receive(:new).with(*args).and_return(instance)
      subject.call(*args)
    end

    it 'calls method "call" on instance' do
      allow(subject).to receive(:new).with(*args).and_return(instance)
      expect(instance).to receive(:call)
      subject.call(*args)
    end
  end

  describe '#call' do
    it 'raises NotImplementedError' do
      expect { subject.call }.to raise_error(NotImplementedError)
    end
  end
end
