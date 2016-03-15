module Contented
  module Helpers
    module TitleHelpers
      def titlize(str)
        str = str.strip             # Remove trailing and leading whitespace
        str = str.gsub(/'/, '')     # Remove apostrophes
        str = str.gsub(/\s/, '-')   # Spaces to dashes
        I18n.transliterate(str)     # Transliterate
      end
    end
  end
end
