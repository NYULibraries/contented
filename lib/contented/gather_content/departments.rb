module Contented
  module GatherContent
    class Departments < Api::Items

      def item_class
        @item_class ||= Kernel.const_get("Contented::GatherContent::Department")
      end
      protected :item_class

    end
  end
end
