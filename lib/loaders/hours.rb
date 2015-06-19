require File.expand_path('../base.rb', __FILE__)

module Nyulibraries
  module SiteLeaf
    module Loaders
      # Loads Hours Posts
      class Hours < Base
        attr_accessor :page_id, :lib

        def initialize(page_id, lib)
          if page_id.empty? || lib.empty?
            fail ArgumentError, 'Page ID and libcal url are required params'
          end
          @page_id = page_id
          @lib = Hashie::Mash.new(JSON.parse((open(lib).read))).locations
        end

        def get_hour_post(posts, name)
          posts.each { |post| return post if name.casecmp(post.title) == 0 }
        end

        def find_hour_post(posts, name)
          posts.each { |post| return false if name.casecmp(post.title) == 0 }
        end

        def match_name(lib, name)
          lib.category == 'library' && lib.name.casecmp(name) == 0
        end

        def find_lib_hours(title)
          lib.each { |lib| return false if match_name(lib, title) }
        end

        def delete_rm_lib(posts)
          # delete posts in siteleaf that are not in Hours Libcal
          posts.each do |post|
            next unless find_lib_hours(post.title)
            post.delete
          end
        end

        def create_lib(posts)
          # Create posts in siteleaf from Hours Libcal
          lib.each do |lib|
            next unless lib.category == 'library'
            next unless find_hour_post(posts, lib.name)
            create_post(parent_id: page_id, title: lib.name)
          end
        end

        def reorder_lib(posts)
          # Re-order Posts by changing the date in posts in sorted manner
          # Libcal Hours can re-order libraries from json in the proper order
          # This will change to using a rank system.
          days = DateTime.now
          lib.each do |library|
            next unless library.category == 'library'
            update_post_date(get_hour_post(posts, library.name), (days += 1))
          end
        end

        def update_posts
          delete_rm_lib(get_all_posts(page_id))
          create_lib(get_all_posts(page_id))
          reorder_lib(get_all_posts(page_id))
        end
      end
    end
  end
end
