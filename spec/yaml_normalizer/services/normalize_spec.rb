# frozen_string_literal: true

require 'spec_helper'

RSpec.describe YamlNormalizer::Services::Normalize do
  subject(:normalize_service) { described_class.new(*args) }

  let(:path) { "#{SpecConfig.data_path}#{File::SEPARATOR}" }
  let(:args) { ["#{path}#{file}"] }

  include_examples 'args receiving service'

  describe '.new' do
    subject(:instance) { described_class.new(args) }

    let(:args) { ['file.yml'] }

    it 'calls super to initialize state of the parent class' do
      expect(instance.instance_variable_get(:@args)).to eql([args])
    end
  end

  context 'when args are partially invalid' do
    let(:args) { ["#{path}*.1", :invalid, "#{path}1.*"] }

    it 'sanitizes the list of files before processing' do
      expect(normalize_service.files).to eql ["#{path}1.1", "#{path}1.2", "#{path}2.1"]
    end
  end

  describe '#call arguments' do
    subject(:normalize_call) { described_class.new(*args).call }

    context "when args don't match any file" do
      let(:args) { ['lol', :foo, nil] }

      it { expect { -> { normalize_call } }.not_to raise_error }
      it { is_expected.to eql [] }
    end

    context 'when YAML file is invalid' do
      let(:file) { 'invalid.yml' }

      it 'prints "not a YAML file" message to STDERR' do
        expect { normalize_call }
          .to output("#{path}invalid.yml not a YAML file\n").to_stderr
      end
    end

    context 'when using relative path' do
      before do
        allow($stderr).to receive(:print)
      end

      it 'processes files with a relative path' do
        Tempfile.open('foo') do |yaml|
          Dir.chdir(Pathname(yaml).dirname)

          expect { described_class.new(Pathname(yaml).basename).call }
            .not_to raise_error
        end
      end
    end
  end

  describe '#call processing' do
    subject(:normalize_call) { described_class.new(*args).call }

    let(:tempfile) { Struct.new(:file).new }
    let(:yaml) { tempfile.file }

    around do |example|
      Tempfile.open(file) do |yaml|
        yaml.write(File.read(path + file))
        yaml.rewind
        tempfile.file = yaml

        example.run
      end
    end

    context 'when YAML file contains a single document' do
      let(:file) { 'valid.yml' }

      it 'normalizes and updates the yaml file' do
        allow($stderr).to receive(:print)
        expect { described_class.new(yaml.path).call }
          .to change { File.read(yaml.path) }
          .from(File.read("#{path}#{file}"))
          .to(File.read("#{path}valid_normalized.yml"))
      end

      it 'prints out a success message with relative file path' do
        relative_path = Pathname.new(yaml.path).realpath.relative_path_from(Pathname.new(Dir.pwd))

        expect { described_class.new(yaml.path).call }
          .to output("[NORMALIZED] #{relative_path}\n").to_stderr
      end
    end

    context 'when YAML file contains multiple valid documents and byte order mark' do
      let(:file) { 'valid_bom.yml' }

      it 'normalizes the yaml file' do
        relative_path = Pathname.new(yaml.path).realpath.relative_path_from(Pathname.new(Dir.pwd))

        expect { described_class.new(yaml.path).call }.to output("[NORMALIZED] #{relative_path}\n").to_stderr
      end
    end

    context 'when at least one normalization is not stable' do
      let(:file) { 'valid2.yml' }

      it 'prints out an error to STDERR' do
        normalize = described_class.new(yaml.path)

        allow(normalize).to receive(:convert).with(read(path + file)).and_call_original
        allow(normalize).to receive(:convert).with(read("#{path}valid2_normalized.yml")).and_return(defect)

        relative_path = Pathname.new(yaml.path).realpath.relative_path_from(Pathname.new(Dir.pwd))
        expect { normalize.call }.to output("[ERROR]      Could not normalize #{relative_path}\n").to_stderr
      end

      def read(file)
        File.read(file)
      end

      def defect
        [
          { error: nil }.extend(YamlNormalizer::Ext::Namespaced),
          { 'that' => 'one, too' }.extend(YamlNormalizer::Ext::Namespaced)
        ]
      end
    end
  end
end
