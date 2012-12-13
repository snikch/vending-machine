module Vend
  class Tax < RemoteResource
    attribute :rate, Float
    attribute :default, Attributes::Boolean
    collection_api_path "taxes"

    ##
    # Scopes
    collection_method :default do
      select(&:default).first
    end
  end
end
