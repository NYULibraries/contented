require File.expand_path('../base.rb', __FILE__)
require File.expand_path('../google_sheet.rb', __FILE__)
require File.expand_path('../staffer.rb', __FILE__)

module Nyulibraries
  module Site_leaf
    module Loaders
      class Staff < Base
        attr_accessor :page_id, :spreadsheet

        def initialize(page_id, spreadsheet)
          if page_id.empty? || spreadsheet.empty?
            raise ArgumentError.new('Page ID and spreadsheet are required params')
          end
          @page_id = page_id
          @spreadsheet = Google_Sheet.new(spreadsheet).to_json()
        end

        def find_staff_posts(posts,email)
          # the meta array index is the index of email in staffer.rb for email
          posts.each {|post| return post if email.casecmp(post.meta[2]['value']) == 0}
          return nil
        end

        def crud_posts

          posts = get_all_posts(page_id)

          #delete posts in siteleaf that are not in the spreadsheet anymore

          posts.each do |post|
            person_present = false
            spreadsheet.each{|person| person_present = true if person.email.t.casecmp(post.meta[2]['value']) == 0}
            if !person_present
              post.delete
            end
          end

          #Create and Update posts in siteleaf from spreadsheet

          spreadsheet.each do |person|
            post = find_staff_posts(posts,person.email.t)
            if post.nil?
              create_post({
                :parent_id => page_id,
                :title     => (person.firstname.t+' '+person.lastname.t),
                :meta      => Staffer.new.get_staff(person)
              })
            else
              update_post_meta(post,Staffer.new.get_staff(person))
            end
          end
        end
      end
    end
  end
end