module Vend::Paths
  # Collection Paths
  module ClassMethods
    def collection_path
      collection_api_path
    end

    def index_path
      collection_path
    end

    def create_path
      collection_path
    end
  end

  # Instance Paths
  def resource_path
    [ self.class.resource_api_path, id ].compact.join("/")
  end

  def show_path
    resource_path
  end

  def update_path
    self.class.collection_path
  end

  def destroy_path
    [ self.class.collection_api_path, id ].compact.join("/")
  end

  def self.included(base)
    base.extend(ClassMethods)
  end
end
