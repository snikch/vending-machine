module UrlAssertions
  def assert_resource_urls(klass, verb_routes)
    verb_routes.each do |verb, route|
      it "#{klass.name}##{verb} maps to #{route}" do
        route.gsub!(/^\/api\//,'') # Remove the /api
        case verb
        when :index
          klass.index_path.must_equal route
        when :show
          klass.new(id: ":id").show_path.must_equal route
        when :create
          klass.create_path.must_equal route
        when :update
          klass.new(id: ":id").update_path.must_equal route
        when :destroy
          klass.new(id: ":id").destroy_path.must_equal route
        else
          raise "I don't know how to #{verb}"
        end
      end
    end
  end
end
