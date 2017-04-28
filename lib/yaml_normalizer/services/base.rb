# frozen_string_literal: true

module YamlNormalizer
  module Services
    # The Base Service provides a convenience class method "call" to initialize
    # the Service with the given arguments and call the method "call" on the
    # instance.
    # @example
    #   class ReverseService < Base
    #     def initialize(str)
    #       @str = str.to_s
    #     end
    #
    #     def call
    #       @str.reverse
    #     end
    #   end
    class Base
      # A convenience class method to initialize Normalize with the given
      # arguments and call the method "call" on the instance.
      # @param *args [Array] arguments to be passed to Base.new
      def self.call(*args)
        new(*args).call
      end

      # Inherit from Base and implement the call method
      # @raise [NotImplementedError] if call is not implemented
      def call
        raise NotImplementedError
      end
    end
  end
end
