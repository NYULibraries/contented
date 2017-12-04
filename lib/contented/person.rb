require 'ostruct'
module Contented
  class Person
    attr_accessor :raw, :person, :save_location

    def initialize(raw, save_location)
      unless raw.is_a?(Hash)
        raise ArgumentError.new("Expecting a hash as the first parameter")
      end
      @raw = raw
      @save_location = save_location
      @person = OpenStruct.new(transform_raw_keys_to_downcase)
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

    def subject_specialties
      @subject_specialties ||= OpenStruct.new(person.subject_specialties)
    end

    def title
      "#{first_name}-#{last_name}"
    end

    def sort_title
      "#{last_name}, #{first_name}"
    end

  private

    def transform_raw_keys_to_downcase
      transform = raw
      transform.keys.each do |key|
        transform[key.downcase] = transform.delete(key)
      end
      transform
    end

    def method_missing(meth, *args, &block)
      if person.send(meth.to_sym) != nil
        person.send(meth)
      else
        super(meth, *args, &block)
      end
    end

  end
end
