module Contented
  module Helpers
    module TitleHelpers
      def titlize(str)
        str.gsub(/[\s']/, '-')
      end
    end
  end
end
