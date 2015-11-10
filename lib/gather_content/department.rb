module GatherContent
  class Department
    attr_accessor :json_string
    ATTRIBUTES = [:title, :date, :location, :space, :email, :phone, :twitter, :blog,
                  :libcal_id, :libanswers_id, :buttons, :body]
    attr_reader *ATTRIBUTES

    def initialize(json_string)
      @json_string = json_string
      @title = get_title
      @body = get_body
      @location = get_location
    end

    def to_markdown
    end

  private

    def get_body
      about.first["elements"].select {|element| element["type"] == "text" && element["label"].gsub(/\s+/, "") == "What We Do" }.first["value"]
    end

    def get_title
      contact_info.first["elements"].select {|element| element["label"].gsub(/\s+/, "") == "Department Name" }.first["options"].select {|option| option["selected"] == true }.first["label"]
    end

    def get_location
      binding.pry
      contact_info.first["elements"].select {|element| element["label"].gsub(/\s+/, "") == "Department Name" }.first["options"].select {|option| option["selected"] == true }.first["label"]
    end

    def about
      @about ||= section("About Your Dept")
    end

    def contact_info
      @contact_info ||= section("Contact Info")
    end

    def related_depts
      @related_depts ||= section("Related Dept/Units")
    end

    def people
      @people ||= section("People")
    end

    def links
      @links ||= secion("Links/Guides/Class")
    end

    def social_media
      @social_media ||= section("Social Media")
    end

    def services
      @services ||= section("Services")
    end

    def section(label)
      parsed_json["data"]["config"].select { |section| section["label"] == label }
    end

    def config
      @config ||= data["config"]
    end

    def data
      @data ||= parsed_json["data"]
    end

    def parsed_json
      @parsed_json ||= JSON.parse(json_string)
    end

  end
end
