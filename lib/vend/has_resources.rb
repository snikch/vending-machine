module Vend::HasResources
  def self.included base
    %w(
      customers
      payment_types
      products
      registers
      sales
      suppliers
      taxes
      users
    ).each do |r|
      define_method r do
        if resource = instance_variable_get("@_#{r}")
          resource
        else
          resource_name = r.
            gsub(/s$/,'').
            sub(/^[a-z]/) { $&.capitalize }.
            gsub(/(?:_|(\/))([a-z\d]*)/) { "#{$1}#{$2.capitalize}" }

          case resource_name
          when 'Taxe'
            resource_name.gsub! /e$/, ''
          end

          resource = Vend::ResourceCollection.new(self, "Vend::#{resource_name}".constantize)
            instance_variable_set("@_#{r}", resource)
          resource
        end
      end
    end
  end
end
