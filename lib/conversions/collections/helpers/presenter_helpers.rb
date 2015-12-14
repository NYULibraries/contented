module Conversions
  module Collections
    module Helpers
      # Helper for presenter class. Runs every private method in that class
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
