$: << File.expand_path(File.dirname(__FILE__))
%w{
  version
  errors

  modules/declarative_setters
  modules/finders
  modules/paths

  response
  resource
  remote_resource
  resource_collection

  resources/brand
  resources/contact
  resources/customer
  resources/outlet
  resources/payment_type
  resources/product_type
  resources/supplier
  resources/register_sale_product
  resources/register_sale_payment
  resources/price_book_entry
  resources/register
  resources/inventory
  resources/product
  resources/user
  resources/sale
  resources/tax

  has_resources
  store
}.each { |r| require "vend/#{r}" }

module Vend
  class << self
    def scheme
      @scheme || "https"
    end

    def domain
      @domain || "vendhq.com"
    end
  end
end
