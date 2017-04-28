# frozen_string_literal: true

module YamlNormalizer
  module Ext
    # Extends an instance of Hash to add the method namespaced.
    # The approach of extending Hash instances avoids monkey-patching a Ruby
    # Core class and using refinements.
    module Namespaced
      # Transforms a tree-shaped hash into a plain key-value pair Hash,
      # separating tree levels with a dot. namespaced does not modify the Hash
      # it's called on.
      # @example
      #   {a: {b: {c: 1}}, b:{x: 2, y: {ok: true}, z: 4}}.namespaced
      #   => {"a.b.c"=>1, "b.x"=>2, "b.y.ok"=>true, "b.z"=>4}
      # @param namespace [Array] the namespace cache for the current namespace,
      #   used on recursive tree traversal
      # @param tree [Hash] the accumulator object beeing build while recursive
      #   traversing the original tree-like Hash
      def namespaced(namespace = [], tree = {})
        each do |key, value|
          child_ns = namespace.dup << key
          if value.instance_of?(Hash)
            value.extend(Namespaced).namespaced child_ns, tree
          else
            tree[child_ns.join('.')] = value
          end
        end
        tree
      end
    end
  end
end
