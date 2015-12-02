module GatherContent
  module Api
    class Items < Base
      include Enumerable
      attr_accessor :project_id

      def initialize(project_id)
        raise ArgumentError, "Project_id is required!" if project_id.nil?
        @project_id = project_id
      end

      def to_a(items = [])
        JSON.parse(get.body)['data'].each do |item|
          new_item = item_class.new(item['id'])
          items << new_item
        end
        return items
      end

      def each(&block)
        self.to_a.each(&block)
      end

    protected

      def item_class
        @item_class ||= Kernel.const_get("GatherContent::Api::Item")
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
