module GatherContent
  class Departments
    include Enumerable
    attr_accessor :project_id

    def initialize(project_id='57459')
      @project_id = project_id
      @items = GatherContent::Api::Items.new(project_id)
    end

    def each(departments = Array.new)
      items.each do |item|
        departments << GatherContent::Department.new(item)
      end
      departments
    end

  end
end
