module Vend
  class Product < RemoteResource
    ##
    # Attribute Coercion
    attribute :active, Boolean
    attribute :brand, Vend::Brand
    attribute :display_retail_price_tax_inclusive, Attributes::Boolean
    attribute :inventory, Array[Vend::Inventory]
    attribute :price, Float
    attribute :price_book_entries, Array[Vend::PriceBookEntry]
    attribute :product_type, Vend::ProductType
    attribute :supplier, Vend::Supplier
    attribute :supply_price, Float
    attribute :tags, Attributes::CSV
    attribute :tax, Float
    attribute :tax_rate, Float

    ##
    # Required Attributes
    attribute :name, String
    attribute :handle, String
    attribute :sku, String
    attribute :retail_price, Float

    ##
    # Scopes
    collection_scope :active, default: true
    collection_scope :order_by
    collection_scope :order_direction

    collection_method :order do |by, direction='ASC'|
      order_by by
      order_direction direction
    end

  end
end
