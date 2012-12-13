require "addressable/uri"
require "json"
require "webmock/minitest"

WebMock.disable_net_connect!

##
# WebMock request expectations.
module RequestExpectations

  def self.included(klass)
    klass.before { @expected_requests = [] }
    klass.after { @expected_requests.each { |sr| assert_requested(sr) } }
  end

  def stub_and_assert_request(*parameters)
    stub_request(*parameters).tap do |request|
      @expected_requests << request
    end
  end

  def expect_request(options)
    rack_method_override!(options, :patch)

    url = options.fetch(:url)
    parameters = options[:parameters]
    method = options.fetch(:method)
    request_body = options[:request_body]
    request_headers = options[:request_headers]
    response_body = options[:response_body]
    response_headers = options[:response_headers]

    if parameters
      url = Addressable::URI.parse(url).tap do |url|
        url.query_values = parameters
      end.to_s
    end

    request = {}
    request[:body] = request_body if request_body
    request[:headers] = request_headers if request_headers

    response = {status: options[:status] || 200}
    response[:body] = JSON.generate(response_body) if response_body
    response[:headers] = response_headers if response_headers

    stub_and_assert_request(method, url).
      with(request).
      to_return(response)
  end
end

MiniTest::Spec.send(:include, RequestExpectations)
