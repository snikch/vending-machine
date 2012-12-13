# TODO: Implement the attribute declaration as a Proc to avoid this
module Vend
  class Product < RemoteResource
  end
end
module Vend
  class Inventory < RemoteResource
    attribute :attributed_cost, Float
    attribute :count, Integer
    attribute :product, Vend::Product
    attribute :outlet, Vend::Outlet
  end
end

