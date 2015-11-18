module GatherContent
  module Api
    class Items < Base
      include Enumerable
      attr_accessor :project_id, :items

      def initialize(project_id)
        raise ArgumentError, "Project_id is required!" if project_id.nil?
        @project_id = project_id
      end

      extend Forwardable
      def_delegator :to_a, :each

      def to_a(items = [])
        JSON.parse(get.body)["data"].each do |item|
          new_item = GatherContent::Api::Item.new(item["id"])
          items << new_item
        end
        return items
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
