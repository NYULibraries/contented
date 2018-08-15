require 'active_support/inflector'

module Contented
  module Markdownable
    FILE_ROOT = File.join(File.dirname(__FILE__), '../').freeze
    TEMPLATE_DIR = 'templates/'.freeze

    def self.included(base)
      [:to_liquid_hash, :filename].each do |meth|
        define_method(meth) { raise_if_no_method(meth) }
      end
    end

    def save_as_markdown!(options)
      File.write(
        "#{options[:save_location]}/#{filename}.markdown",
        to_markdown
      )
    end

    private

    def raise_if_no_method(meth)
      raise "Classes including the Markdownable module must include a #{meth} method"
    end

    def to_markdown
      file = File.read("#{FILE_ROOT}#{TEMPLATE_DIR}#{template_file}.markdown")
      template = Liquid::Template.parse(file)
      rendered = template.render(to_liquid_hash, strict_variables: true)
      p template.errors unless template.errors.empty?
      rendered
    end

    def template_file
      self.class.to_s.underscore
    end
  end
end
