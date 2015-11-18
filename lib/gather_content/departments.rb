module GatherContent
  class Departments < Api::Items

    def initialize(project_id)
      super(project_id)
      @items = GatherContent::Api::Items.new(project_id)
    end

    def to_a(departments = [])
      items.to_a.each do |item|
        departments << GatherContent::Department.new(item.item_id)
      end
      return departments
    end

  end
end
