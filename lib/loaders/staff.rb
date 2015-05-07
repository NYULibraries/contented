require File.expand_path('../base.rb', __FILE__)
require File.expand_path('../google_sheet.rb', __FILE__)
require File.expand_path('../staffer.rb', __FILE__)

module Nyulibraries
  module SiteLeaf
    module Loaders
      # Creates Deletes Updates Staff Posts and Meta-fields
      class Staff < Base
        attr_accessor :page_id, :spreadsheet

        def initialize(page_id, spreadsheet)
          if page_id.empty? || spreadsheet.empty?
            fail ArgumentError, 'Page ID and spreadsheet are required params'
          end
          @page_id = page_id
          @spreadsheet = GoogleSheet.new(spreadsheet).json_data
        end

        def match_email(post, email)
          post.meta[2]['value'].casecmp(email) == 0
        end

        def find_staff_posts(posts, email)
          # the meta array index is the index of email in staffer.rb for email
          posts.each { |post| return post if match_email(post, email) }
          nil
        end

        def find_staff_sheet(post)
          spreadsheet.each { |p| return false if match_email(post, p.email.t) }
        end

        def del_fired_staff_posts(posts)
          # delete posts in siteleaf that are not in the spreadsheet anymore
          posts.each do |post|
            next unless find_staff_sheet(post)
            post.delete
          end
        end

        # Create and Update posts in siteleaf from spreadsheet
        def create_update_posts(posts)
          spreadsheet.each do |person|
            if (post = find_staff_posts(posts, person.email.t)).nil?
              create_post(
                parent_id:  page_id,
                title:      person.firstname.t + ' ' + person.lastname.t,
                meta:       Staffer.new.get_staff(person)
              )
            else
              update_post_meta(post, Staffer.new.get_staff(person))
            end
          end
        end

        def update_posts
          del_fired_staff_posts(get_all_posts(page_id))
          create_update_posts(get_all_posts(page_id))
        end
      end
    end
  end
end
