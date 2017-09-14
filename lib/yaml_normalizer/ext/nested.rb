# frozen_string_literal: true

module YamlNormalizer
  module Ext
    # Extends an instance of Hash to add the method nested.
    # The approach of extending Hash instances avoids monkey-patching a Ruby
    # Core class and using refinements.
    module Nested
      # Transforms a flat key-value pair Hash into a tree-shaped Hash, assuming
      # tree levels are separated by a dot. nested does not modify the Hash
      # it's called on.
      # @example
      #   {'a.b.c' => 1, 'b.x' => 2, 'b.y.ok' => true, 'b.z' => 4}.nested
      #   => {"a"=>{"b"=>{"c"=>1}}, "b"=>{"x"=>2, "y"=>{"ok"=>true}, "z"=>4}}
      # @return [Hash] tree-shaped Hash
      def nested
        tree = Hash.new { |h, k| h[k] = Hash.new(&h.default_proc) }
        each { |key, val| nest_key(tree, key.to_s, val) }
        tree.default_proc = nil
        tree
      end

      private

      def nest_key(hash, key, val)
        if key.include?('.')
          keys = key.split('.')
          hash.dig(*(keys[0..-2]))[keys.fetch(-1)] = val
        else
          hash[key] = val
        end
      end
    end
  end
end
