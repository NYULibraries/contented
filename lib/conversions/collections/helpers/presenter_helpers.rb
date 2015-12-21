module Conversions
  module Collections
    module Helpers
      # Renderer for presenters in collections
      module PresenterHelpers
        def render
          render = ''
          (private_methods - Object.private_methods - Module.methods).each do |method_sym|
            render = "#{render}#{send(method_sym)}\n"
          end
          render
        end
      end
    end
  end
end
