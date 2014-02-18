require 'json'

module Vend
  class RemoteResource < Resource
    include Vend::DeclarativeSetters
    include Vend::Paths

    attr_reader :error

    def save
      begin
        save!
      rescue ValidationFailed
        (@error ||= []) << $!.message
        false
      end
    end

    def save!
      save_path = id ? update_path : self.class.create_path
      method = id ? :post : :post
      response = store.send(method, path: save_path,
        data: sendable_attributes.to_json,
        status: 200
      ).data

      if response['status'] && response['status'] == 'error'
        raise ValidationFailed.
          new [response['error'], response['details']].join(': ')
      end

      self.attributes = response[self.class.path]
      true
    end

    def load
      self.attributes = store.get(
        path: resource_path,
        status: 200
      ).data
      self
    end



    private

    def sendable_attributes
      blacklist = %w{
        created_at
        updated_at
      }
      attributes.delete_if{|name,value| blacklist.include? name }.dup
    end
  end
end
