require_relative "spec_helper"

module Vend
  describe Store do
    describe "#url" do
      it "should be the store api endpoint" do
        store = Vend::Store.new('test-store', :a, :a)
        store.send(:url).must_equal "https://test-store.vendhq.com/api"
      end
    end

    describe "#faraday" do
      it "should be an authorized Faraday client" do
        store = Vend::Store.new('test-store', "abc", "123")
        conn = store.send(:faraday)
        assert auth = conn.headers['Authorization']
        assert_equal Faraday::Request::BasicAuthentication.header("abc", "123"), auth
      end
    end
  end
end
