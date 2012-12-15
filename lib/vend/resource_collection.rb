module Vend
  class ResourceCollection
    attr_accessor :parameters, :store

    include Vend::Finders
    include Enumerable

    def initialize(store, klass, records = nil)
      @store = store
      @klass = klass
      @records = records
    end

    ##
    # Check for a collection method
    # defined on the resource
    def method_missing symbol, *args
      if @klass.collection_methods[symbol]
        instance_exec *args, &@klass.collection_methods[symbol]
      else
        super
      end
    end

    def create(attributes = {})
      build(attributes).tap(&:save)
    end

    def create!(attributes = {})
      build(attributes).tap(&:save!)
    end

    def build(attributes)
      @klass.new(attributes.merge store: @store)
    end

    def << record
      (@records || []) << record
    end

    def to_a
      records.to_a
    end

    def each
      records.each do |attributes|
        yield build(attributes)
      end
    end

    private

    def http_response
      @_http_response ||= @store.get(
        path: @klass.collection_path,
        parameters: @parameters,
        status: 200
      )
    end

    def remote_records
      http_response.data.first.last
    end

    def records
      # Data comes back with a root element, so get the first response's value
      # { products: [ {}, {}, ..] }.first.last == [ {}, {}, ... ]
      @records ||= remote_records
    end

    def clear
      @records = nil
      @_http_response = nil
    end
  end
end
