require 'active_support/inflector'

module Contented
  module LiquidCollection
    FILE_ROOT = File.join(File.dirname(__FILE__), '../').freeze
    TEMPLATE_DIR = 'templates/campusmedia/'.freeze

    def save_as_markdown!(options)
      File.write(
        "#{options[:save_location]}/#{options[:filename]}.markdown",
        to_markdown(options[:liquid_hash])
      )
    end

    def to_markdown(liquid_hash)
      template = Liquid::Template.parse(template_file)
      rendered = template.render(liquid_hash, strict_variables: true)
      p template.errors unless template.errors.empty?
      rendered
    end

    def template_file
      klass = self.class.to_s.underscore
      File.read("#{FILE_ROOT}#{TEMPLATE_DIR}#{klass}.markdown")
    end
  end
end
