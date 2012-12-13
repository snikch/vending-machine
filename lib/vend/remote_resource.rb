module Vend
  class RemoteResource < Resource
    include Vend::DeclarativeSetters
    include Vend::Paths

    def save
      id ? save_existing : save_new
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

    def save_new
      self.attributes = store.post(
        path: create_path,
        parameters: sendable_attributes,
        status: 200
      ).data
      self
    end

    def save_existing
      self.attributes = store.put(
        path: update_path,
        parameters: sendable_attributes,
        status: 200
      ).data
      self
    end
  end
end
