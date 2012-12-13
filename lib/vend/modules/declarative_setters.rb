module Vend::DeclarativeSetters
  module ClassMethods
    # The path fragment used for this resource
    def path(path = nil)
      @path = path if path
      @path || (
        self.
          name.
          split('::').
          last.
          gsub(/([a-z\d])([A-Z])/,'\1_\2').
          downcase
      ) # Underscored class name
    end

    # Customize the collection api path
    def collection_api_path(path=nil)
      @collection_api_path = path if path
      @collection_api_path || "#{self.path}s"
    end

    # Customize the resource api path
    def resource_api_path(path=nil)
      @resource_api_path = path if path
      @resource_api_path || "1.0/#{self.path}"
    end

    # The name of a child collection.
    def has_many(name, class_proc)
      define_method "#{name}=" do |items|
        (@_has_many ||= {})[name] = items
      end
      define_method name do
        has_many_reader(name, class_proc)
      end
    end

    # The name of a one to one resource
    def has_one(name, class_proc)
      define_method "#{name}=" do |instance|
        (@_has_one ||= {})[name] = instance
      end
      define_method name do
        has_one_reader(name, class_proc)
      end
    end

    # Defines a resource collection scope
    def collection_scope name, options = {}
      default = options[:default] || nil
      collection_method name do |value=default|
        value = value == false ? "0" : value.to_s
        current_value = (@parameters ||= {})[name]
        clear if value != current_value
        (@parameters ||= {})[name] = value
        self
      end
    end

    # Defines a resource collection method
    def collection_method name, &block
      collection_methods[name] = block
    end

    # Returns all collection methods
    def collection_methods
      (@_collection_methods ||= {})
    end
  end

  def self.included(base)
    base.extend(ClassMethods)
  end
end
