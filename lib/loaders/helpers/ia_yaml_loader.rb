require File.expand_path('../../base.rb', __FILE__)
module Nyulibraries
  module SiteLeaf
    module Helpers
      # Loads Yaml files from config to create IA i.e page and posts
      class IAYamlLoader
        attr_accessor :ia_yaml

        def initialize(yaml_file)
          @ia_yaml = Hashie::Mash.new(YAML.load_file(yaml_file))
        end

        def uniform_structure(element)
          ia = IA.new
          ia.title =  element.title
          ia.body =  element.body.nil? ? '' : element.body
          element.meta.each { |_meta, key| ia.meta << key unless key.nil? }
          ia
        end

        def page
          uniform_structure(ia_yaml.Page)
        end

        def posts
          ia = []
          ia_yaml.Page.Posts.each do |post|
            tmp_ia = uniform_structure(post)
            post.tags.each { |_tag, key| tmp_ia.tags << key unless key.nil? }
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
