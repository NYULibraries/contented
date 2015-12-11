module Conversions
  module Collections
    module Helpers
      module PresenterHelpers
        def render
          render = ""
          (self.private_methods - Object.private_methods - Module.methods).each do |method_sym|
            render = "#{render}#{self.send(method_sym)}\n"
          end
          render
        end
      end
    end
  end
end
