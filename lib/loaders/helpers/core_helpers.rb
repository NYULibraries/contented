require File.expand_path('../../base.rb', __FILE__)
module Nyulibraries
  module SiteLeaf
    module Loaders
      module Helpers
        # Helper Class for all the attribute loaders like department and staff
        class CoreHelpers
          attr_accessor :data

          def initialize(data)
            @data = data
          end

          def loader
            Loaders::Base.new
          end

          def get_data_elements(column_name)
            element = convert_name_sheet_column(column_name)
            return '' unless data.send('' + element)
            element.empty? ? '' : data.send('' + element).t
          end

          def convert_name_sheet_column(name)
            name.delete(' ').downcase
          end

          def fetch_meta_or_tagset(element, m_or_t)
            val = 'value' + (m_or_t == 0 ? '' : 's')
            set = []
            element.each { |el| set << { 'key' => el, val => get_data_elements(el) } }
            set
          end

          def get_meta(meta)
            return {} unless meta
            fetch_meta_or_tagset(meta, 0) # 0 for meta-fields
          end

          def get_tags(tags)
            return {} unless tags
            fetch_meta_or_tagset(tags, 1) # anything except 0 for tagsets
          end

          def match_title(element_title, title)
            element_title.casecmp(title) == 0
          end

          def find_subpage(parent_id, page_title)
            loader.get_all_pages(parent_id).each { |page| return page if match_title(page.title, page_title) }
            nil
          end

          def find_post(page_id, post_title)
            loader.get_all_posts(page_id).each { |post| return post if match_title(post.title, post_title) }
            nil
          end

          def create_subpage(parent_id, page)
            loader.make_page(parent_id, get_data_elements(page.title), get_data_elements(page.body), get_meta(page.meta)).id
          end

          def create_post(parent_id, post)
            Loaders::Base.new.make_post(parent_id, post.title, get_data_elements(post.body), get_meta(post.meta), get_tags(post.tags))
          end

          def create_posts(parent_id, posts)
            posts.each { |post| create_post(parent_id, post) }
          end

          def update_a_post(post, ia_post)
            Loaders::Base.new.update_post(post, ia_post.title, get_data_elements(ia_post.body), get_meta(ia_post.meta), post.taxonomy << get_tags(ia_post.tags))
          end

          def update_posts(parent_id, ia_posts)
            ia_posts.each do |post|
              post_exists = find_post(parent_id, post.title)
              update_a_post(post_exists, post) if post_exists
              create_post(parent_id, post)
            end
          end

          def update_subpage_posts(ia, page)
            Loaders::Base.new.update_page(page, get_data_elements(ia.page.title), get_data_elements(ia.page.body), get_meta(ia.page.meta))
            update_posts(page.id, ia.posts)
          end

          def delete_subpage(parent_id, column_department_name)
            # Note : none of the landing pages will be deleted by the loaders
            # So, the find sub_page has been used unlike in create_subpage.
            subpage = find_subpage(parent_id, get_data_elements(column_department_name))
            subpage.delete if subpage
          end
        end
      end
    end
  end
end
