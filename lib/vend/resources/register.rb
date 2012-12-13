module Vend
  class Register < RemoteResource
    attribute :invoice_sequence, Integer
    attribute :print_receipt, Attributes::Boolean
    attribute :register_close_time, DateTime
    attribute :register_open_time, DateTime
    attribute :register_open_count_sequence, Integer
  end
end
