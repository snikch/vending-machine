module Vend
  class Supplier < RemoteResource
    attribute :contact, Vend::Contact
    collection_api_path "supplier"
  end
end
