# frozen_string_literal: true

# rubocop:disable Metrics/BlockLength
shared_examples :args_receving_service do
  describe 'param triggered methods' do
    subject { described_class.new(*args) }

    context 'when presented with version param' do
      let(:args) { ['--version'] }

      it 'prints the version of software' do
        expect do
          expect(subject).to receive(:print_version)
          subject.call
        end.to raise_error(SystemExit) { |e| expect(e.status).to be_zero }
      end
    end

    context 'when presented with help param' do
      let(:args) { ['--help'] }
      it 'prints the help message' do
        expect do
          subject.call
        end.to raise_error(SystemExit) { |e| expect(e.status).to be_zero }
      end
    end
  end

  context '#print_version' do
    let(:args) { [] }
    it 'prints the current version' do
      expect do
        subject.print_version
      end.to output("#{YamlNormalizer::VERSION}\n").to_stdout
    end
  end
end
# rubocop:enable Metrics/BlockLength
