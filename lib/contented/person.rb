module Contented
  class Person
    attr_accessor :raw, :person, :save_location

    def initialize(raw, save_location)
      @raw = raw
      @save_location = save_location
      @person = raw # Do something with this
    end

    # Save markdown to file `title`.md
    def save_as_markdown!
      File.write(save_location, to_markdown)
    end

    # Convert this object to a markdown string
    def to_markdown
      template = Liquid::Template.parse(template_file)
      to_markdown = template.render(person, { strict_variables: true })
    end

    def title
      "#{first_name}-#{last_name}"
    end

    def sort_title
      "#{last_name}, #{first_name}"
    end

  end
end
