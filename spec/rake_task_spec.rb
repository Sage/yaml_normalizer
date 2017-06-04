# frozen_string_literal: true

require 'spec_helper'
require 'yaml_normalizer/rake_task'
Rake::TaskManager.record_task_metadata = true

# rubocop:disable Metrics/BlockLength
RSpec.describe YamlNormalizer::RakeTask do
  describe 'defining tasks' do
    context 'yaml:check' do
      it 'creates "yaml:check"' do
        subject
        expect(Rake::Task.task_defined?('yaml:check')).to be true
      end

      it 'describes "yaml:check"' do
        expect(Rake::Task['yaml:check'].comment)
          .to eql('Check if configured YAML are normalized')
      end

      it 'lists "yaml:normalize"' do
        subject
        expect(Rake::Task.task_defined?('yaml:normalize')).to be true
      end

      it 'describes "yaml:normalize"' do
        expect(Rake::Task['yaml:normalize'].comment)
          .to eql('Normalize configured YAML files')
      end

      it 'creates a named task' do
        described_class.new(:lint_lib)

        expect(Rake::Task.task_defined?('lint_lib:check')).to be true
      end

      it 'creates a named task' do
        described_class.new(:lint_lib)

        expect(Rake::Task.task_defined?('lint_lib:normalize')).to be true
      end
    end
  end

  context 'running rake tasks' do
    around do |example|
      $stdout = StringIO.new
      $stderr = StringIO.new
      Rake::Task[task].clear if Rake::Task.task_defined?('yaml:check')

      example.run

      $stdout = STDOUT
      $stderr = STDERR
    end

    describe 'running rake task "yaml:check"' do
      let(:task) { 'yaml:check' }

      it 'runs with default file configuration' do
        described_class.new

        expect(YamlNormalizer::Services::Check).to receive(:call)
          .with(no_args)
          .and_return(true)
        Rake::Task['yaml:check'].execute
      end

      it 'runs with files = "*.yml"' do
        described_class.new { |task| task.files = '*.yml' }

        expect(YamlNormalizer::Services::Check).to receive(:call)
          .with('*.yml')
          .and_return(true)
        Rake::Task['yaml:check'].execute
      end

      it 'raises an error if yaml:check fails' do
        described_class.new
        msg = <<~MSG
          yaml:check failed.
          Run 'rake yaml:normalize' to normalize YAML files.
        MSG

        allow(YamlNormalizer::Services::Check).to receive(:call).with(no_args)

        expect { Rake::Task['yaml:check'].execute }.to raise_error(msg)
      end
    end

    describe 'running rake task "yaml:normalize"' do
      let(:task) { 'yaml:normalize' }

      it 'runs with default options' do
        described_class.new

        expect(YamlNormalizer::Services::Normalize)
          .to receive(:call).with(no_args)

        Rake::Task[task].execute
      end

      it 'runs with configured files' do
        described_class.new { |task| task.files = '*.yml' }

        expect(YamlNormalizer::Services::Normalize)
          .to receive(:call).with('*.yml')

        Rake::Task[task].execute
      end
    end
  end
end
