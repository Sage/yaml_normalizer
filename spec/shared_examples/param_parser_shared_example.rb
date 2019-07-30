# frozen_string_literal: true

shared_examples :args_receving_service do
  describe 'param triggered methods' do
    subject { described_class.new(*args) }

    context 'when presented with version param' do
      ['-v', '--version'].each do |param|
        let(:args) { [param] }

        it 'prints the version of software' do
          expect do
            subject.call
          end.to output("#{YamlNormalizer::VERSION}\n").to_stdout
        end
      end
    end

    context 'when presented with help param' do
      ['-h', '--help'].each do |param|
        let(:args) { [param] }
        it 'prints the help message' do
          expect do
            subject.call
          end.to output("Usage: rspec [options] file1, file2...\n"\
            "    -v, --version                    Prints the yaml_normalizer version\n"\
            "    -h, --help                       Prints this help\n").to_stdout
        end
      end
    end
  end
end
