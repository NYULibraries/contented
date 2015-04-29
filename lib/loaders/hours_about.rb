require File.expand_path('../base.rb', __FILE__)

module Nyulibraries
  module Site_leaf
    module Loaders
      class Hours_About < Base
        attr_accessor :page_id, :libcal_hours

        def initialize(page_id, libcal_hours)    
          if page_id.empty? || libcal_hours.empty?
            raise ArgumentError.new("Page ID and libcal hours url are required params")
          end          
          @page_id = page_id
          @libcal_hours =  (Hashie::Mash.new(JSON.parse((open(libcal_hours).read)))).locations          
        end

        def find_hours_posts(posts,name)
          #the meta index is 0 because that is where the name of the library is.
          posts.each {|post| return post if name.casecmp(post.title) == 0}
          return nil                              
        end 

        def crud_posts

          posts = get_all_posts(page_id)

          #delete posts in siteleaf that are not in Hours Libcal

          posts.each do |post|                 
            lirary_present=false
            libcal_hours.each{|lib| lirary_present=true if lib.category == 'library' && lib.name.casecmp(post.title) == 0}
            if !lirary_present
              post.delete          
            end            
          end

          #Create posts in siteleaf from Hours Libcal

          libcal_hours.each do |lib|
            if lib.category == 'library' && find_hours_posts(posts,lib.name).nil?
              create_post({
                :parent_id => page_id,
                :title     => lib.name
              })              
            end
          end

          #Re-order Posts this is done by changing the date field in posts and it can thus be displayed in sorted manner
          #This Approach is followed because Libcal Hours can re-order libraries and json recieved is the proper order

          days = 0
          libcal_hours.each do |lib|
            next if lib.category != 'library'
            update_post_date(find_hours_posts(posts,lib.name),DateTime.now+(days=days+1))
          end               
        end
      end
    end
  end
end


