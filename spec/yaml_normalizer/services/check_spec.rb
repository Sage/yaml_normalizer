# frozen_string_literal: true

require 'spec_helper'

RSpec.describe YamlNormalizer::Services::Check do
  let(:path) { "#{SpecConfig.data_path}#{File::SEPARATOR}" }
  let(:args) { ["#{path}#{name}"] }

  include_examples 'args receiving service'

  describe '.new' do
    subject(:instance) { described_class.new(args) }

    let(:args) { ['file.yml'] }

    it 'calls super to initialize state of the parent class' do
      expect(instance.instance_variable_get(:@args)).to eql([args])
    end
  end

  context 'when there are both valid and invalid globbing inputs' do
    subject(:check_service_instance) { described_class.new(*args) }

    let(:args) { ["#{path}*.1", :invalid, "#{path}1.*"] }
    let(:expected) { ["#{path}1.1", "#{path}1.2", "#{path}2.1"] }

    it 'sanitizes list of files before processing' do
      expect(check_service_instance.files).to eql expected
    end
  end

  describe '#call arguments' do
    subject(:check_service_call) { described_class.new(*args).call }

    context 'without valid globbing inputs' do
      let(:args) { ['lol', :foo, nil] }

      it { is_expected.to be(true) }
    end

    context 'when YAML file is invalid' do
      before { allow($stderr).to receive(:print) }

      let(:name) { 'invalid.yml' }

      it { is_expected.to be(false) }

      it 'prints "is not a YAML file" message to STDERR' do
        allow($stderr).to receive(:print)
        expect { check_service_call }
          .to output("#{path}#{name} is not a YAML file\n").to_stderr
      end
    end
  end

  describe '#call processing' do
    subject(:check_service_call) { described_class.new(*args).call }

    let(:data) { { path: nil } }
    let(:file) { data[:path] }
    let(:args) { file.path }

    around do |example|
      Tempfile.open(name) do |yaml|
        yaml.write(File.read(path + name))
        yaml.rewind
        data[:path] = yaml
        example.run
      end
    end

    context 'when single document YAML file is denormalized' do
      before do
        described_class.define_method(:print) { raise 'DoNotCall' }
        allow($stderr).to receive(:print)
        allow($stdout).to receive(:print)
      end

      let(:name) { 'valid.yml' }

      it { is_expected.to be(false) }

      it 'prints out an error message with relative file path' do
        relative_path = Pathname.new(file.path).realpath.relative_path_from(Pathname.new(Dir.pwd))
        expect { check_service_call }
          .to output("[FAILED] normalization suggested for #{relative_path}\n")
          .to_stdout
      end
    end

    context 'when single document YAML file is normalized' do
      before do
        allow($stderr).to receive(:print)
        allow($stdout).to receive(:print)
      end

      let(:name) { 'valid_normalized.yml' }

      it { is_expected.to be(true) }

      it 'prints out a success message with relative file path' do
        relative_path = Pathname.new(file.path).realpath.relative_path_from(Pathname.new(Dir.pwd))
        expect { check_service_call }
          .to output("[PASSED] already normalized #{relative_path}\n")
          .to_stdout
      end
    end

    context 'when YAML file contains multiple documents' do
      let(:name) { 'valid2_normalized.yml' }

      it 'passes if YAML file is already normalized' do
        relative_path = Pathname.new(file.path).realpath.relative_path_from(Pathname.new(Dir.pwd))
        expect { check_service_call }
          .to output("[PASSED] already normalized #{relative_path}\n")
          .to_stdout
      end
    end
  end
end
