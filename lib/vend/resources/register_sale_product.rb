module Vend
  class RegisterSaleProduct < Resource
    attribute :display_retail_price_tax_inclusive, Attributes::Boolean
    attribute :price, Float
    attribute :price_set, Boolean
    attribute :price_total, Float
    attribute :quantity, Integer
    attribute :tax, Float
    attribute :tax_rate, Float
    attribute :tax_total, Float
  end
end
