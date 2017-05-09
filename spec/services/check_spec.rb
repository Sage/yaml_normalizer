# frozen_string_literal: true

require 'spec_helper'

# rubocop:disable Metrics/BlockLength
RSpec.describe YamlNormalizer::Services::Check do
  subject { described_class.new(*args) }

  let(:path) { "#{SpecConfig.data_path}#{File::SEPARATOR}" }
  let(:args) { ["#{path}#{file}"] }

  context 'not a string, not a file' do
    subject { described_class.new(*args).call }
    let(:args) { ['lol', :foo, nil] }
    it { is_expected.to eql [] }
  end

  context 'not a string, not a file' do
    let(:args) { ["#{path}*.1", :invalid, "#{path}1.*"] }
    it 'sanitaizes list of files before processing' do
      expect(subject.files).to eql ["#{path}1.1", "#{path}1.2", "#{path}2.1"]
    end
  end

  describe '#call' do
    subject { described_class.new(*args).call }
    context 'invalid YAML file' do
      let(:file) { 'invalid.yml' }

      it 'prints "not a YAML file" message to STDERR' do
        expect { subject }
          .to output("#{path}invalid.yml not a YAML file\n").to_stderr
      end
    end

    context 'single-document YAML file' do
      let(:denormalized) { 'valid.yml' }
      let(:normalized) { 'valid_normalized.yml' }

      it 'prints out a success message with relative file path' do
        Tempfile.open(denormalized) do |yaml|
          yaml.write(File.read(path + denormalized))
          yaml.rewind
          f = Pathname.new(yaml.path).relative_path_from(Pathname.new(Dir.pwd))
          expect { described_class.new(yaml.path).call }
            .to output("[FAILED] normalization suggested for #{f}\n").to_stdout
        end
      end

      it 'prints out a success message with relative file path' do
        Tempfile.open(normalized) do |yaml|
          yaml.write(File.read(path + normalized))
          yaml.rewind
          f = Pathname.new(yaml.path).relative_path_from(Pathname.new(Dir.pwd))
          expect { described_class.new(yaml.path).call }
            .to output("[PASSED] already normalized #{f}\n").to_stdout
        end
      end
    end

    context 'multi-document YAML file' do
      let(:file) { 'valid2_normalized.yml' }

      it 'passes if YAML file is already normalized' do
        Tempfile.open(file) do |yaml|
          yaml.write(File.read(path + file))
          yaml.rewind
          f = Pathname.new(yaml.path).relative_path_from(Pathname.new(Dir.pwd))
          expect { described_class.new(yaml.path).call }
            .to output("[PASSED] already normalized #{f}\n").to_stdout
        end
      end
    end
  end
end
