module GatherContent
  class Department < Api::Item
    ATTRIBUTES = [:title, :location, :space, :email, :phone, :twitter, :facebook, :blog,
                  :subtitle, :classes, :keywords, :links, :libcal_id, :libanswers_id, :buttons, :body]
    attr_reader *ATTRIBUTES

    def initialize(item_id)
      super(item_id)
      @department_decorator = GatherContent::Decorators::DepartmentDecorator.new(self.get_item)
    end

    extend Forwardable
    def_delegators :@department_decorator, *ATTRIBUTES

    def to_markdown
      to_markdown = ["---"]
      ATTRIBUTES.delete_if {|attr| [:body, :blog, :links, :buttons].include? attr }.each do |attribute|
        to_markdown << "#{attribute}: #{self.send(attribute)}"
      end
      to_markdown << convert_to_markdown('blog')
      to_markdown << convert_to_markdown('buttons')
      to_markdown << convert_to_markdown('links')
      to_markdown << ["---","","# What We Do","","#{body}"]
      to_markdown.flatten.join("\n")
    end
    alias_method :to_md, :to_markdown

  private

    def convert_to_markdown(hash_name)
      convert_to_markdown = ["#{hash_name}:"]
      send(hash_name).each_pair do |key, value|
        convert_to_markdown << "\t#{key}: #{value}"
      end
      return convert_to_markdown
    end

  end
end
