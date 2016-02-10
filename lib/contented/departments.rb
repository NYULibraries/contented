module Contented
  class Departments < GatherContent::Api::Items

    def item_class
      @item_class ||= Kernel.const_get("Contented::Department")
    end
    protected :item_class

  end
end
