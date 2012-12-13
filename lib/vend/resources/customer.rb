module Vend
  class Customer < RemoteResource
    attribute :balance, Float
    attribute :contact, Vend::Contact
    attribute :points, Integer
    attribute :year_to_date, Float
  end
end
