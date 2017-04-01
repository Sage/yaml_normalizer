# frozen_string_literal: true

module StableYamlFormatter
  module Services
    # The Base Service provides a convenience class method "call" to initialize
    # the Service with the given arguments and call the method "call" on the
    # instance.
    class Base
      # A convenience class method to initialize Normalize with the given
      # arguments and call the method "call" on the instance.
      def self.call(*args)
        new(*args).call
      end

      # Inherit from Base and implement the call method
      def call
        raise NotImplementedError
      end
    end
  end
end
