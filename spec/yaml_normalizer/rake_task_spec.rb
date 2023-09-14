# frozen_string_literal: true

require 'spec_helper'
require 'yaml_normalizer/rake_task'
Rake::TaskManager.record_task_metadata = true

module YamlNormalizer
  RSpec.describe RakeTask do
    describe 'defining tasks' do
      describe 'yaml:check' do
        it 'creates "yaml:check"' do
          described_class.new
          expect(Rake::Task.task_defined?('yaml:check')).to be true
        end

        it 'describes "yaml:check"' do
          expect(Rake::Task['yaml:check'].comment)
            .to eql('Check if configured YAML files are normalized')
        end

        it 'creates a named task' do
          described_class.new(:lint_lib)

          expect(Rake::Task.task_defined?('lint_lib:check')).to be true
        end
      end

      describe 'yaml:normalize' do
        it 'lists "yaml:normalize"' do
          described_class.new
          expect(Rake::Task.task_defined?('yaml:normalize')).to be true
        end

        it 'describes "yaml:normalize"' do
          expect(Rake::Task['yaml:normalize'].comment)
            .to eql('Normalize configured YAML files')
        end

        it 'creates a named task' do
          described_class.new(:lint_lib)

          expect(Rake::Task.task_defined?('lint_lib:normalize')).to be true
        end
      end
    end

    describe 'running rake tasks' do
      around do |example|
        Rake::Task[task].clear if Rake::Task.task_defined?(task)
        example.run
      end

      describe 'running rake task "yaml:check"' do
        let(:task) { 'yaml:check' }
        let(:msg) do
          <<~MSG
            yaml:check failed.
            Run 'rake yaml:normalize' to normalize YAML files.
          MSG
        end

        it 'runs with default file configuration' do
          described_class.new
          allow(Services::Check).to receive(:call).and_return(true)

          Rake::Task['yaml:check'].execute

          expect(Services::Check).to have_received(:call).with(no_args)
        end

        it 'runs with files = "*.yml"' do
          described_class.new { |task| task.files = '*.yml' }
          allow(Services::Check).to receive(:call).and_return(true)

          Rake::Task['yaml:check'].execute

          expect(Services::Check).to have_received(:call).with('*.yml')
        end

        it 'raises an error if yaml:check fails' do
          described_class.new
          allow(Services::Check).to receive(:call).with(no_args)
          allow($stderr).to receive(:write)

          expect { Rake::Task['yaml:check'].execute }.to raise_error(msg)
        end
      end

      describe 'running rake task "yaml:normalize"' do
        let(:task) { 'yaml:normalize' }

        it 'runs with default options' do
          described_class.new
          allow(Services::Normalize).to receive(:call)

          Rake::Task[task].execute

          expect(Services::Normalize).to have_received(:call).with(no_args)
        end

        it 'runs with configured files' do
          described_class.new { |task| task.files = '*.yml' }
          allow(Services::Normalize).to receive(:call)

          Rake::Task[task].execute

          expect(Services::Normalize).to have_received(:call).with('*.yml')
        end
      end
    end
  end
end
