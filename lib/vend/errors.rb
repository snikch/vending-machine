module Vend
  class Error < StandardError; end

  class Unauthorized < Error
    def message; "Unauthorized"; end
  end

  class ValidationFailed < Error; end

  class ServerError < Error; end

  class InvalidConfig < Error; end

end
