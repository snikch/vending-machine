require "addressable/uri"
require "faraday"
require "faraday_middleware"

module Vend
  class Store
    include HasResources

    def initialize(credentials={})
      @authenticator = Vend::Config.auth_method
      case @authenticator
      when :basic_auth
        @name, @credentials = credentials[:store_name], [credentials[:username], credentials[:password]]
      when :oauth
        @name, @auth_token =  credentials[:store_name], credentials[:auth_token]
      end
    end

    ##
    # Dispatch a request using HTTP GET
    def get options
      dispatch :get, options
    end

    ##
    # Dispatch a request using HTTP POST
    def post options
      dispatch :post, options
    end

    private

    ##
    # Dispatches an HTTP request
    def dispatch method, options
      path = options[:path]
      parameters = options[:parameters]
      data = options[:data]

      if parameters
        path = Addressable::URI.parse(path).tap do |uri|
          uri.query_values = (uri.query_values || {}).merge(parameters)
        end.to_s
      end

      headers = faraday.headers.merge(options[:headers] || {})
      response = faraday.run_request(method, path, data, headers)

      assert_http_status(response, options[:status])

      ::Vend::Response.new(
        response.status,
        response.headers,
        response.body
      )

    end

    ##
    # Raises an error unless the response status matches the required status
    def assert_http_status(response, status)
      case response.status
      when nil, status then return
      when 401
        raise Unauthorized
      when 422
        raise ValidationFailed, "Validation failed: #{response.body.to_s}"
      when 500
        raise ServerError, internal_server_error_message(status, response)
      else
        raise Error, "Expected HTTP #{status}, got HTTP #{response.status}"
      end
    end

    def internal_server_error_message(expected_status, response)
      body = response.body
      if body["type"] && body["message"] && body["backtrace"]
        "Expected HTTP %d, got HTTP %d with error:\n%s\n%s\n\n%s" % [
          expected_status,
          response.status,
          response.body["type"],
          response.body["message"],
          response.body["backtrace"].join("\n"),
        ]
      else
        "Expected HTTP %d, got %d" % [
          expected_status,
          response.status,
        ]
      end
    end

    ##
    # Base URL for the Vend AP
    def url
      "%s://%s.%s/api" % [ Vend.scheme, @name, Vend.domain ]
    end

    ##
    # Memoized Faraday client with auth credentials
    def faraday
      @_faraday ||= Faraday.new(url) do |conn|
        conn.request :json
        conn.response :json
        case @authenticator
        when :basic_auth
          conn.basic_auth *@credentials
        when :oauth
          conn.authorization :Bearer, @auth_token
        end
        conn.adapter Faraday.default_adapter
      end
    end
  end
end
