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

    ##
    # Instance Methods
    def build_variant attributes = {}
      unless attributes[:sku]
        # Increment or Append to sku
        attributes[:sku] = (
          sku.match(/[\d]+$/) ?
            sku.gsub(/[\d]+$/){|match| match.to_i + 1} :
            sku + '-1'
        )
      end

      attributes[:handle] = handle unless attributes[:handle]

      new_attributes = attributes.dup.delete_if do |attribute, value|
        %w{ created_at updated_at id }.include?(attribute)
      end.merge attributes

      new_attributes[:store] = store

      self.class.new new_attributes
    end

    def create_variant sku
      build_variant(sku).save
    end

    def create_variant! sku
      build_variant(sku).save!
    end

  end
end
