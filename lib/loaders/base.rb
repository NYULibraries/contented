require 'siteleaf'
require 'json'
require 'open-uri'
require 'figs'
Figs.load

class Base
	
	def initialize
		Siteleaf.api_key    = ENV['SITELFEAF_KEY']
		Siteleaf.api_secret = ENV['SITELFEAF_SECRET']     
	end

 private

	def create_posts_from_spreadsheet	
		raise NotImplementedError, "#{child} must implement this method"
	end

	def create_page(title)
		Siteleaf::Page.create({
		  :site_id  => ENV['SITELFEAF_ID'],
		  :title    => title
		})
	end

	def create_post(attrs = {})
		Siteleaf::Post.create(attrs)
	end

	def delete_all_posts(page_id)
		Siteleaf::Page.find(page_id).posts.each { |post| post.delete }
	end

	def theme
		Siteleaf::Theme.find_by_site_id(ENV['SITELFEAF_ID'])
	end

	def spreadsheet_to_json(spreadsheet)    
    JSON.parse(open(spreadsheet).read)
  end

end

