require File.expand_path('../../base.rb', __FILE__)
module Nyulibraries
  module SiteLeaf
    module Helpers
      # Creates Deletes Updates Department Pages and Meta-fields
      class CoreHelpers
        attr_accessor :data

        def initialize(data)
          @data = data
        end

        def get_body(body)
          body.empty? ? '' : element.send('' + body).t
        end

        def get_meta(meta)
          return {} if meta.empty?
          metafields = []
          meta.each do |val|
            metafields << { 'key' => val, 'value' => data.send('' + val).t }
          end
          metafields
        end

        def get_tags(tags)
          return {} if tags.empty?
          tagsets = []
          tags.each do |val|
            tagsets << { 'key' => val, 'values' => data.send('' + val).t }
          end
          tagsets
        end

        def match_title(element_title, title)
          element_title.casecmp(title) == 0
        end

        def find_subpage(parent_id, page_title)
          Loaders.get_all_pages(parent_id).each { |page| return page if match_title(page.title, page_title) }
          nil
        end

        def find_subpost(page_id, post_title)
          Loaders.get_all_posts(page_id).each { |post| return post if match_title(page.title, post_title) }
          nil
        end

        def create_subpage(parent_id, page)
          Loaders::Base.new.make_page(parent_id, data.send('' + page.title).t, get_body(page.body), get_meta(page.meta)).id
        end

        def create_subposts(parent_id, posts)
          posts.each { |post| Loaders::Base.new.make_post(parent_id, data.send('' + post.title).t, get_body(post.body), get_meta(post.meta), get_tags(post.tags)) }
        end

        def delete_subpage(parent_id, page_title)
          subpage = find_subpage(parent_id, page_title)
          subpage.delete unless subpage.nil?
        end

        # def delete_subpost(parent_id, page_title, post_title)
        #   # subpage = find_subpage(parent_id, page_title)
        #   # subpage.delete unless subpage.nil?
        # end
      end
    end
  end
end
