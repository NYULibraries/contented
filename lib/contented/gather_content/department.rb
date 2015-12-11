module Contented
  module GatherContent
    class Department < Api::Item
      PUBLISHED_STATUSES = ["Ready for the Web"]
      ATTRIBUTES = [:title, :location, :space, :email, :phone, :twitter, :facebook, :blog,
                    :subtitle, :classes, :keywords, :links, :libcal_id, :libanswers_id, :buttons, :body]
      attr_reader *ATTRIBUTES

      def initialize(item_id)
        super(item_id)
        @department_decorator = Contented::GatherContent::Decorators::DepartmentDecorator.new(self.get_item)
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

      def filename
        if title
          title.downcase.gsub(/\s/,'-').gsub(/&amp;/,'and').gsub(/,/,'')
        else
          "department_#{Time.now.strftime('%Y%m%d%H%M%S')}"
        end
      end

      def published?
        PUBLISHED_STATUSES.include? status
      end

    private

      def status
        self.get_item["data"]["status"]["data"]["name"]
      end

      def convert_to_markdown(hash_name)
        convert_to_markdown = ["#{hash_name}:"]
        unless send(hash_name).nil?
          send(hash_name).each_pair do |key, value|
            convert_to_markdown << "  #{key}: #{value}"
          end
        end
        return convert_to_markdown
      end

    end
  end
end
