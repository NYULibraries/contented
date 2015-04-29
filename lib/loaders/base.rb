require 'siteleaf'
require 'json'
require 'open-uri'
require 'hashie'
require 'date'
require 'figs'
Figs.load

module Nyulibraries
  module Site_leaf
    module Loaders
      class Base

        def initialize
          Siteleaf.api_key    = ENV['SITELEAF_KEY']
          Siteleaf.api_secret = ENV['SITELEAF_SECRET']
        end

        def create_posts_from_spreadsheet
          raise NotImplementedError, "#{child} must implement this method"
        end

        def create_page(title)
          Siteleaf::Page.create({
            :site_id  => ENV['SITELEAF_ID'],
            :title    => title
          })
        end

        def get_page(page_id)
          Siteleaf::Page.find(page_id)
        end

        def get_all_posts(page_id)
          get_page(page_id).posts
        end

        def update_post_meta(post,meta)
          post.meta = meta
          post.save
        end

        def update_post_date(post,date)
          post.published_at = date
          post.save
        end

        def create_post(attrs = {})
          Siteleaf::Post.create(attrs)
        end

        def theme
          Siteleaf::Theme.find_by_site_id(ENV['SITELEAF_ID'])
        end
      end
    end
  end
end

