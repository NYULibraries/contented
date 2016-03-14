module Contented
  module Helpers
    module TitleHelpers
      def titlize(str)
        I18n.transliterate(str.gsub(/[\s']/, '-'))
      end
    end
  end
end
