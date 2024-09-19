# frozen_string_literal: true

require 'spec_helper'

RSpec.describe YamlNormalizer::Services::IsYaml do
  describe '.new' do
    subject(:instance) { described_class.new(file) }

    let(:file) { 'foo.yml' }

    it 'calls super to initialize state of the parent class' do
      expect(instance.instance_variable_get(:@args)).to eql([file])
    end
  end

  describe '#call' do
    subject { described_class.new(file).call }

    let(:path) { "#{SpecConfig.data_path}#{File::SEPARATOR}" }

    context 'when passing an invalid argument' do
      let(:file) { :does_not_exist }

      it { is_expected.to be false }
    end

    context 'when YAML file is invalid' do
      let(:file) { "#{path}invalid.yml" }

      it { is_expected.to be false }
    end

    context 'when YAML file is a scalar' do
      let(:file) { "#{path}scalar.yml" }

      it { is_expected.to be false }
    end

    context 'when YAML file is valid' do
      let(:file) { "#{path}valid.yml" }

      it { is_expected.to be true }
    end
  end
end
