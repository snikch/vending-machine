module Vend
  module Config
    class << self

      VALID_AUTHENTICATION_METHODS = %i(basic_auth oauth)
      DEAFULT_AUTHENTICATION_METHOD = :basic_auth

      def auth_method=(method)
        if VALID_AUTHENTICATION_METHODS.include?(method.to_sym)
          @auth_method = method.to_sym
        else
          raise Vend::InvalidConfig("%s is not a valid authentication method" % method)
        end
      end

      def auth_method
        @auth_method || DEAFULT_AUTHENTICATION_METHOD
      end

    end
  end
end