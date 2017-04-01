# frozen_string_literal: true

module StableYamlFormatter
  module Refinements
    # Refine Hash to add method sort_by_key
    module HashSortByKey
      refine Hash do
        # Sorts entries alphabetically by key and returns a new Hash
        # sort_by_key does not modify the Hash it's called on.
        def sort_by_key(recursive = true, &block)
          keys.sort(&block).each_with_object({}) do |key, seed|
            seed[key] = self[key]
            if recursive && seed[key].is_a?(Hash)
              seed[key] = seed[key].sort_by_key(true, &block)
            end
          end
        end
      end
    end
  end
end

# mutant doen't support Refinements use monky-patch for mutation testing
# class Hash
#   # Sorts entries alphabetically by key and returns a new Hash
#   # sort_by_key does not modify the Hash it's called on.
#   def sort_by_key(recursive = true, &block)
#     keys.sort(&block).each_with_object({}) do |key, seed|
#       seed[key] = self[key]
#       if recursive && seed[key].is_a?(Hash)
#         seed[key] = seed[key].sort_by_key(true, &block)
#       end
#     end
#   end
# end
