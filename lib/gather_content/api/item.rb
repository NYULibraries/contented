module GatherContent
  module Api
    class Item < Base
      attr_accessor :item_id

      def initialize(item_id)
        raise ArgumentError, "Item_id is required!" if item_id.nil?
        @item_id = item_id
      end

      def get_item
        @get_item ||= JSON.parse(get.body)
      end

    private

      def path
        @path ||= "/items/#{item_id}"
      end

      def params; end
    end
  end
end
