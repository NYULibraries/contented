module GatherContent
  module Api
    class Item < Base
      attr_accessor :id

      def initialize(id)
        @id = id
      end

      def get_item
        @get_item ||= JSON.parse(get.body)
      end

    private

      def path
        @path ||= "/items/#{id}"
      end

      def params; end
    end
  end
end
