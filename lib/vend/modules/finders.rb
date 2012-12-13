module Vend::Finders
  def find(id)
    @klass.new(id: id, store: store)
  end
end
