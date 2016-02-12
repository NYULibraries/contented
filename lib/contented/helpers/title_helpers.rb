module Contented
  module Helpers
    module TitleHelpers
      def self.titlize(str)
        str.gsub(/[\s']/, '-')
      end
    end
  end
end
