# frozen_string_literal: true

require 'spec_helper'

# rubocop:disable Metrics/BlockLength
RSpec.describe YamlNormalizer::Services::Check do
  let(:path) { "#{SpecConfig.data_path}#{File::SEPARATOR}" }
  let(:args) { ["#{path}#{name}"] }

  include_examples :args_receving_service

  context 'parially invalid globbing inputs' do
    subject { described_class.new(*args) }
    let(:args) { ["#{path}*.1", :invalid, "#{path}1.*"] }
    it 'sanitaizes list of files before processing' do
      expect(subject.files).to eql ["#{path}1.1", "#{path}1.2", "#{path}2.1"]
    end
  end

  describe '#call' do
    subject { described_class.new(*args).call }

    context 'only invalid globbing inputs' do
      let(:args) { ['lol', :foo, nil] }
      it { is_expected.to eql(true) }
    end

    context 'invalid YAML file' do
      let(:name) { 'invalid.yml' }

      it { is_expected.to eql(false) }

      it 'prints an error message to STDERR' do
        expect { subject }
          .to output("\t[ERROR] #{path}#{name} is not parseable as YAML - (<unknown>): mapping values are not allowed in this context at line 3 column 7\n\n")
          .to_stderr
      end
    end

    context 'file handling' do
      let(:data) { { path: nil } }
      let(:file) { data[:path] }
      let(:args) { file.path }

      around :example do |example|
        Tempfile.open(name) do |yaml|
          yaml.write(File.read(path + name))
          yaml.rewind
          data[:path] = yaml
          example.run
        end
      end

      context 'single-document YAML file' do
        context 'denormalized YAML file' do
          let(:name) { 'valid.yml' }

          it { is_expected.to eql(false) }

          it 'prints out an error message with relative file path' do
            f_abs = Pathname.new(file.path).realpath
            expect { subject }
              .to output("Processing #{f_abs}\n\t[FAILED] file needs normalization\n\n")
              .to_stdout
          end
        end

        context 'normalized YAML file' do
          let(:name) { 'valid_normalized.yml' }

          it { is_expected.to eql(true) }

          it 'prints out a success message with relative file path' do
            f_abs = Pathname.new(file.path).realpath
            expect { subject }
              .to output("Processing #{f_abs}\n\t[PASSED] file is already normalized\n\n")
              .to_stdout
          end
        end
      end

      context 'multi-document YAML file' do
        let(:name) { 'valid2_normalized.yml' }

        it 'passes if YAML file is already normalized' do
          f_abs = Pathname.new(file.path).realpath
          expect { subject }
            .to output("Processing #{f_abs}\n\t[PASSED] file is already normalized\n\n")
            .to_stdout
        end
      end
    end
  end
end
# rubocop:enable Metrics/BlockLength
