module Vend
  module Config
    class << self

      DEFAULT_AUTHENTICATION = :basic_auth

      attr_accessor :auth_method

      def reset
        @authenticate = DEFAULT_AUTHENTICATION
      end

      def auth_method=(auth_method)
        if auth_method == :oauth
          @authenticate = auth_method
        end
        @authenticate || DEFAULT_AUTHENTICATION
      end

      def auth_method
        @authenticate
      end

    end
    # Set default values for configuration options on load
    self.reset
  end
end