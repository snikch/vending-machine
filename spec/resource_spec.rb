require_relative "spec_helper"

module Vend
  describe Resource do
    describe "#has_many" do
      it "returns the same instance of ResourceCollection" do
        class Widget < RemoteResource
          attribute :name, String
        end
        resource = Class.new(RemoteResource) do
          attribute :id, Integer
          has_many :widgets, ->{ Widget }
        end
        i = resource.new widgets: [{ name: "Knob" }]
        widgets = i.widgets
        widgets.send(:records).size.must_equal 1
        i.widgets << Widget.new(name: "Flange")
        widgets.send(:records).size.must_equal 2
      end
    end
  end
end
