# frozen_string_literal: true

module YamlNormalizer
  module Ext
    # *YamlNormalizer::Ext::Nested* extends instances of *Hash* to provide the
    # additional public helper method *nested*.
    # The approach of extending Hash instances avoids monkey-patching a Ruby
    # Core class and using refinements.
    module Nested
      # Transforms a flat key-value pair *Hash* into a tree-shaped *Hash*,
      # assuming tree levels are separated by a dot.
      # *nested* does not modify the instance of *Hash* it's called on.
      # @example
      #   hash = {'a.b.c' => 1, 'b.x' => 2, 'b.y.ok' => true, 'b.z' => 4}
      #   hash.extend(YamlNormalizer::Ext::Nested)
      #   hash.nested
      #   => {"a"=>{"b"=>{"c"=>1}}, "b"=>{"x"=>2, "y"=>{"ok"=>true}, "z"=>4}}
      # @return [Hash] tree-shaped Hash
      def nested
        tree = {}
        each { |key, val| nest_key(tree, key, val) }
        tree
      end

      private

      def nest_key(hash, dotted_key, val)
        keys = dotted_key.to_s.split('.')
        last_key = keys.pop.to_s
        sub_hash = hash
        keys.each do |key|
          sub_hash = (sub_hash[key] ||= {})
        end
        sub_hash[last_key] = val
      end
    end
  end
end
