require File.expand_path('../base.rb', __FILE__)
require File.expand_path('../google_sheet.rb', __FILE__)
require File.expand_path('../dept_attr.rb', __FILE__)

module Nyulibraries
  module SiteLeaf
    module Loaders
      # Creates Deletes Updates Department Pages and Meta-fields
      class Departments < Base
        attr_accessor :page_id, :spreadsheet

        def initialize(page_id, spreadsheet)
          if page_id.empty? || spreadsheet.empty?
            fail ArgumentError, 'Page ID and spreadsheet are required params'
          end
          @page_id = page_id
          @spreadsheet = GoogleSheet.new(spreadsheet).json_data
        end

        def match_name(post, name)
          post.meta[0]['value'].casecmp(name) == 0
        end

        def find_dept_sheet(post)
          spreadsheet.each { |p| return false if match_name(post, p.departmentname.t) }
        end

        def find_dept_posts(posts, name)
          posts.each { |post| return post if match_name(post, name) }
          nil
        end

        def del_fired_dept_posts(posts)
          # delete dept. pages that are not in the spreadsheet anymore
          posts.each do |post|
            next unless find_dept_sheet(post)
            post.delete
          end
        end

        # Create and Update Department Pages in siteleaf from spreadsheet
        def create_update_posts(posts)
          spreadsheet.each do |dept|
            if (post = find_dept_posts(posts, dept.departmentname.t)).nil?
              create_post(
                parent_id:  page_id,
                title:      dept.departmentname.t,
                meta:       DeptAttr.new.get_dept_meta(dept),
                taxonomy:   DeptAttr.new.get_dept_tags(dept)
              )
            else
              update_post_meta(post, DeptAttr.new.get_dept_meta(dept))
              update_post_tags(post, DeptAttr.new.get_dept_tags(dept))
            end
          end
        end

        def update_pages
          del_fired_dept_posts(get_all_posts(page_id))
          create_update_posts(get_all_posts(page_id))
        end
      end
    end
  end
end
