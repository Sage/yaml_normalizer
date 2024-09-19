# frozen_string_literal: true

require 'spec_helper'

# Dummy class to test base class
class Dummy < YamlNormalizer::Services::Base; end

RSpec.describe YamlNormalizer::Services::Base do
  let(:args) { [:foo, 'bar', 842] }

  describe '.new' do
    it 'accepts arbitrary arguments' do
      instance = described_class.new(*args)
      expect(instance.instance_variable_get(:@args)).to eql(args)
    end
  end

  describe '.call' do
    let(:args) { [:foo, 'bar', 842] }
    let(:instance) { instance_double(Dummy, call: nil) }

    it 'creates an instance and passes all arguments' do
      allow(Dummy).to receive(:new).and_return(instance)
      Dummy.call(*args)
      expect(Dummy).to have_received(:new).with(*args)
    end

    it 'calls method "call" on instance' do
      allow(Dummy).to receive(:new).with(*args).and_return(instance)
      Dummy.call(*args)
      expect(instance).to have_received(:call)
    end
  end

  describe '#call' do
    subject(:base_service) { described_class.new }

    it 'raises NotImplementedError' do
      expect { base_service.call }.to raise_error(NotImplementedError)
    end
  end
end
