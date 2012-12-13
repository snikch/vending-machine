module Vend
  class Response
    attr_reader :status, :headers, :data

    def initialize status, headers, data
      @status, @headers, @data = status, headers, data
    end
  end
end
