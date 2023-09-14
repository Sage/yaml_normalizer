# frozen_string_literal: true

RSpec.shared_examples 'args receiving service' do
  describe 'param triggered methods' do
    subject { described_class.new(*args) }

    context 'when called with version param' do
      ['-v', '--version'].each do |param|
        let(:args) { [param] }

        # rubocop:disable RSpec/MultipleExpectations
        it 'prints the version and exits' do
          expect do
            expect do
              subject.call
            end.to raise_error(SystemExit)
          end.to output("#{YamlNormalizer::VERSION}\n").to_stdout
        end
        # rubocop:enable RSpec/MultipleExpectations
      end
    end

    context 'when called with help param' do
      ['-h', '--help'].each do |param|
        let(:args) { [param] }
        let(:help_message) do
          "Usage: #{program_name} [options] file1, file2...\n    " \
            "-h, --help                       Prints this help\n    " \
            "-v, --version                    Prints the yaml_normalizer version\n"
        end

        # rubocop:disable RSpec/MultipleExpectations
        it 'prints the help message and exits' do
          expect do
            expect do
              subject.call
            end.to raise_error(SystemExit)
          end.to output(help_message).to_stdout
        end
        # rubocop:enable RSpec/MultipleExpectations
      end
    end

    def program_name
      $PROGRAM_NAME.split('/').last
    end
  end
end
