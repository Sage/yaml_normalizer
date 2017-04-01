# frozen_string_literal: true

module StableYamlFormatter
  module Refinements
    # Refine Hash to add method sort_by_key
    module HashNamespaced
      refine Hash do
        # Transforms a tree-shaped hash into a plain key-value pair hash,
        # separating tree levels with a dot.
        # @examples
        #   {a: {b: {c: 1}}, b:{x: 2, y: {ok: true}, z: 4}}.namespaced
        #   => {"a.b.c"=>1, "b.x"=>2, "b.y.ok"=>true, "b.z"=>4}
        def namespaced(namespace = [], tree = {})
          each do |key, value|
            child_ns = namespace.dup << key
            if value.is_a?(Hash)
              value.namespaced child_ns, tree
            else
              tree[child_ns.join('.')] = value
            end
          end
          tree
        end
      end
    end
  end
end

# mutant doen't support Refinements use monky-patch for mutation testing
# class Hash
#   # Transforms a tree-shaped hash into a plain key-value pair hash,
#   # separating tree levels with a dot.
#   # @examples
#   #   {a: {b: {c: 1}}, b:{x: 2, y: {ok: true}, z: 4}}.namespaced
#   #   => {"a.b.c"=>1, "b.x"=>2, "b.y.ok"=>true, "b.z"=>4}
#   def namespaced(namespace = [], tree = {})
#     each do |key, value|
#       child_ns = namespace.dup << key
#       if value.is_a?(Hash)
#         value.namespaced child_ns, tree
#       else
#         tree[child_ns.join('.')] = value
#       end
#     end
#     tree
#   end
# end
