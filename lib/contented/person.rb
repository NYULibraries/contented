module Contented
  class Person
    attr_accessor :raw, :person

    def initialize(raw)
      @raw = raw
      @person = raw
    end

    # Save markdown to file `title`.md
    def to_markdown!
      self.to_markdown
    end

    # Convert this object to a markdown string
    def to_markdown

    end

    def title
      "#{first_name}-#{last_name}"
    end

  end
end
