module Vend
  class Register < RemoteResource
    attribute :invoice_sequence, Integer
    attribute :print_receipt, Attributes::Boolean
    attribute :register_close_time, DateTime
    attribute :register_open_time, DateTime
    attribute :register_open_count_sequence, Integer

    # Close register
    def close!
      self.attributes = store.post(
        path: close_path,
        status: 200
      ).data
      self
    end

    # Open register
    def open!
      self.attributes = store.post(
        path: open_path,
        status: 200
      ).data
      self
    end
  end
end
