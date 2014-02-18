require_relative "spec_helper"

module Vend
  describe Store do
    describe "#url" do
      it "should be the store api endpoint" do
        store = Vend::Store.new({:store_name => 'test-store', :username => :a, :password => :a})
        store.send(:url).must_equal "https://test-store.vendhq.com/api"
      end
    end

    describe "#faraday with basic auth" do
      it "should be an authorized Faraday client" do
        store = Vend::Store.new({:store_name => 'test-store', :username => 'abc', :password => '123'})
        conn = store.send(:faraday)
        assert auth = conn.headers['Authorization']
        assert_equal Faraday::Request::BasicAuthentication.header("abc", "123"), auth
      end
    end

    describe "#faraday with oauth" do
      it "should be an authorized Faraday client" do
        Vend::Config.auth_method = :oauth
        store = Vend::Store.new({:store_name => 'test-store', :auth_token => 'my-dummy-token'})
        conn = store.send(:faraday)
        assert auth = conn.headers['Authorization']
        assert_equal Faraday::Request::Authorization.header("Bearer", "my-dummy-token"), auth
      end
    end
  end
end
