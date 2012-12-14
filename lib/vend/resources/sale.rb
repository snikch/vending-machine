module Vend
  class Sale < RemoteResource
    attribute :customer, Vend::Customer
    attribute :invoice_number, Integer
    attribute :register_sale_products, Array[RegisterSaleProduct]
    attribute :register_sale_payments, Array[RegisterSalePayment]
    attribute :total_cost, Float
    attribute :total_price, Float
    attribute :total_tax, Float
    attribute :totals, Hash[Symbol => Float] # Requires updated virtus gem
    attribute :user, Vend::User

    alias_method :products, :register_sale_products
    alias_method :payments, :register_sale_payments

    path "register_sale"
  end
end

