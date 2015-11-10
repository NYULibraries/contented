module GatherContent
  module Api
    class Items < Base
      include Enumerable
      attr_accessor :project_id

      def initialize(project_id)
        @project_id = project_id
      end

      def get_items
        @get_items ||= get.body
      end

      def each
        get_items
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
