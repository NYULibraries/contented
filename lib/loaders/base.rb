require 'siteleaf'
require 'json'
require 'open-uri'
require 'hashie'
require 'date'
require 'figs'
require 'yaml'
Figs.load

module Nyulibraries
  module SiteLeaf
    module Loaders
      # Loaders keep siteleaf post and page in sync with the data
      # Loaders create empty posts and pages with the correct name for mapping
      # Contains All Siteleaf related functions
      class Base
        def initialize
          Siteleaf.api_key = ENV['API_KEY']
          Siteleaf.api_secret = ENV['API_SECRET']
        end

        def create_page(attrs = {})
          attrs[:site_id] = ENV['SITELEAF_ID']
          Siteleaf::Page.create(attrs)
        end

        def get_page(page_id)
          Siteleaf::Page.find(page_id)
        end

        def get_all_posts(page_id)
          get_page(page_id).posts
        end

        def get_all_pages(page_id)
          get_page(page_id).pages
        end

        def update_post_meta(post, meta)
          post.meta = meta
          post.save
        end

        def update_post_tags(post, tags)
          post.taxonomy = tags
          post.save
        end

        def update_post_date(post, date)
          post.published_at = date
          post.save
        end

        def create_post(attrs = {})
          Siteleaf::Post.create(attrs)
        end

        def theme
          Siteleaf::Theme.find_by_site_id(ENV['SITELEAF_ID'])
        end

        def make_page(parent_id, title, body, meta)
          # Creates a page with all these attributes
          create_page(
            parent_id:  parent_id,
            title:      title,
            body:       body,
            meta:       meta
          )
        end

        def make_post(parent_id, title, body, meta, tags)
          # Creates a post with all these attributes
          create_post(
            parent_id:  parent_id,
            title:      title,
            body:       body,
            meta:       meta,
            taxonomy:   tags
          )
        end

        def update_page(page, title, body, meta)
          # Updates a page with all these attributes
          page.title = title
          page.body = body
          page.meta = meta
          page.save
        end

        def update_post(post, title, body, meta, tags)
          # Updates a page with all these attributes
          post.title = title
          post.body = body
          post.meta = meta
          post.taxonomy = tags
          post.save
        end
      end
    end
  end
end
