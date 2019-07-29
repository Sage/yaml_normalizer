# frozen_string_literal: true

require 'peach'

module YamlNormalizer
  module Services
    # Normalize is a service class that provides functionality to update giving
    # YAML files to a standardized (normalized) format.
    # @exmaple
    #   normalize = YamlNormalizer::Services::Normalize.new('path/to/*.yml')
    #   result = normalize.call
    class Normalize < Base
      include Helpers::Normalize

      # files is a sorted array of file path Strings
      attr_reader :files

      # Create a Normalize service object by calling .new and passing one or
      # more String that are interpreted as file glob pattern.
      # @param *args [Array<String>] a list of file glob patterns
      def initialize(*args)
        files = args.each_with_object([]) { |a, o| o << Dir[a.to_s] }
        @files = files.flatten.sort.uniq
      end

      # Normalizes all YAML files defined on instantiation.
      def call
        files.peach { |file| process(file) }
      end

      private

      def process(file)
        if IsYaml.call(file)
          normalize!(file)
        else
          $stderr.print "#{file} not a YAML file\n"
        end
      end

      def normalize!(file)
        file = relative_path_for(file)
        input = read(file)
        norm = normalize_yaml(input)
        norm = sanitize_yaml(input, norm)
        if stable?(input, norm)
          File.open(file, 'w') { |f| f.write(norm) }
          $stderr.print "[NORMALIZED] #{file}\n"
        else
          $stderr.print "[ERROR]      Could not normalize #{file}\n"
        end
      end

      def stable?(yaml_a, yaml_b)
        convert(yaml_a).each_with_index.all? do |a, i|
          a.namespaced.eql?(convert(yaml_b).fetch(i).namespaced)
        end
      end

      # Psych parser sometimes adds / removes whitespace at the end of the file which causes confising changes in the
      # files - this sanitization it 
      def sanitize_yaml(original, processed)
        new_lines = processed.split("\n")
        original_lines = original.split("\n")
        indices = indices_to_correct(original_lines, new_lines)
        indices.each { |index| new_lines[index] = original_lines[index] } if indices.size > 0
        new_lines.join("\n") + "\n"
      end

      def indices_to_correct(original_lines, new_lines)
        line_diffs = new_lines.each_with_index.select { |l, i| l != original_lines[i] }.map {|n, i| [n, original_lines[i], i]}
        line_diffs.select {|l, k, i| k.end_with?(':') && l == k + ' '}.map(&:last)
      end

      def convert(yaml)
        ary = Psych.parse_stream(yaml).transform
        ary.each { |hash| hash.extend(Ext::Namespaced) }
        ary
      end
    end
  end
end
