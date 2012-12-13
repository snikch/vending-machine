module Vend
  class RegisterSalePayment < Resource
    attribute :amount, Float
    attribute :payment_type_id, Integer
  end
end
