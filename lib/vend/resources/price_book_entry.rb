module Vend
  class PriceBookEntry < Resource
    attribute :max_units, Integer
    attribute :min_units, Integer
    attribute :price, Float
    attribute :tax, Float
    attribute :tax_rate, Float
  end
end

