module GatherContent
  module Api
    class Items < Base
      include Enumerable
      attr_accessor :project_id

      def initialize(project_id)
        @project_id = project_id
      end

      def each(items = [])
        get_items["data"].each do |item|
          items << GatherContent::Api::Item.new(item)
        end
        items
      end

      def get_items
        @get_items ||= JSON.parse(get.body)
      end

    private

      def params
        { project_id: project_id }
      end

      def path
        @path ||= '/items'
      end

    end
  end
end
