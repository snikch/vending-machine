require 'virtus'

module Vend
  class Resource
    include Virtus

    attr_accessor :store

    attribute :id, String

    alias_method :initialize_virtus, :initialize
    def initialize attributes={}
      current_attribute_set = attribute_set
      self.extend(Virtus)
      attribute_set.merge(current_attribute_set)
      initialize_virtus attributes
    end

    alias_method :set_attributes_virtus, :set_attributes
    def set_attributes(attributes)
      public_method_names = public_methods.map(&:to_s)

      unknown_attributes = attributes.
        dup.
        delete_if{|k, v| public_method_names.include?("#{k.to_s}=") }

      if unknown_attributes.size > 0
        dates = %w{ created_at deleted_at updated_at }
        self.extend Virtus unless self.respond_to?(:attribute)
        unknown_attributes.
          each do |k,v|
            case
            when dates.include?(k)
              klass = DateTime
            else
              klass = String
            end
            self.attribute k, klass
          end
      end

      set_attributes_virtus attributes
    end


    private

    def has_many_reader(name, class_proc)
      variable_name = "@_has_many_reader_#{name}"
      instance_variable_get(variable_name) ||
        instance_variable_set(variable_name, (
          klass = class_proc.call
          ResourceCollection.new(
            store,
            class_proc.call,
            (@_has_many || {})[name] || nil
          )
        )
      )
    rescue KeyError
      raise Error, "No reference to children :#{name}"
    end

    def has_one_reader(name, class_proc)
      klass = class_proc.call
      record = (@_has_one || {}).fetch(name)
      if record.is_a?(Resource)
        record
      else
        @_has_one[name] = klass.new(record)
      end
    rescue KeyError
      raise Error, "No reference to child :#{name}"
    end

  end
  module Attributes
    class CSV < Virtus::Attribute::Object
      primitive Array

      def coerce(value)
        require 'csv'
        ::CSV.parse(value).first
      end
    end
    class Boolean < Virtus::Attribute::Object
      primitive Boolean

      def coerce(value)
        if [1, '1'].include? value
          true
        elsif [0, '0'].include? value
          false
        else
          value == true
        end
      end
    end
  end
end
