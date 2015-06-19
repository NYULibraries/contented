require File.expand_path('../../base.rb', __FILE__)
module Nyulibraries
  module SiteLeaf
    module Loaders
      module Helpers
        # Loads Yaml files from config to create IA i.e page and posts
        class IAYamlLoader
          attr_accessor :ia_yaml

          def initialize(yaml_file)
            @ia_yaml = Hashie::Mash.new(YAML.load_file(yaml_file))
          end

          def convert_name_sheet_column(name)
            name.gsub(' ', '').downcase
          end

          def get_meta_or_tag(element)
            m_or_tag = []
            element.each { |_meta, key| m_or_tag << convert_name_sheet_column(key) unless key.nil? }
            m_or_tag
          end

          def uniform_structure(element)
            ia = IA.new
            ia.title =  convert_name_sheet_column(element.title)
            ia.body =  element.body.nil? ? '' : convert_name_sheet_column(element.body)
            ia.meta = get_meta_or_tag(element.meta)
            ia
          end

          def page
            uniform_structure(ia_yaml.Page)
          end

          def posts
            ia = []
            ia_yaml.Page.Posts.each do |post|
              tmp_ia = uniform_structure(post)
              tmp_ia.tags = get_meta_or_tag(post.tags)
              ia << tmp_ia
            end
            ia
          end
        end
        # Defines a unuform basic structure of any post or page
        # only exception is that tags are present in page but not in post
        class IA
          attr_accessor :title, :body, :meta, :tags
        end
      end
    end
  end
end
