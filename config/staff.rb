require 'rubygems'
require 'siteleaf'
require 'open-uri'
require 'json'
require 'figs'
Figs.load

class Staff
	def initialize (key,secret,staff_page_id,spreadsheet)
		empty_posts(key,secret,staff_page_id)
		get_sheet(key,secret,staff_page_id,spreadsheet)	
	end
	def empty_posts (key,secret,staff_page_id)	
		Siteleaf.api_key    = key
		Siteleaf.api_secret = secret
		# get posts by page id
		posts = Siteleaf::Page.find(staff_page_id).posts
		posts.each do |post|
			post.delete
		end
	end
	def get_sheet (key,secret,staff_page_id, spreadsheet)	
		Siteleaf.api_key    = key
		Siteleaf.api_secret = secret		
		#Get JSON File for spread sheets and parse it
		people = JSON.parse(open(spreadsheet).read)
		people['feed']['entry'].each do |p|			
			Siteleaf::Post.create({
				:parent_id => staff_page_id,
				:title     => p['gsx$firstname']['$t'],
				:meta      =>  [{"key" => "email", "value" => p['gsx$email']['$t']},{"key" => "phone", "value" => p['gsx$workphones']['$t']},{"key" => "department", "value" => p['gsx$department']['$t']},{"key" => "department2", "value" => p['gsx$departmentii']['$t']},{"key" => "jobtitle", "value" => p['gsx$jobtitle']['$t']},{"key" => "workspace", "value" => p['gsx$workspace']['$t']},{"key" => "location", "value" => p['gsx$location']['$t']},{"key" => "libguides_url", "value" => p['gsx$libguidesurl']['$t']},{"key" => "subjects", "value" => p['gsx$subjects']['$t']},{"key" => "photo", "value" => p['gsx$photo']['$t']}]
			})						
		end
	end
end

Staff.new(ENV['SITELFEAF_KEY'],ENV['SITELFEAF_SECRET'],ENV['STAFF_PAGE_ID'],ENV['STAFF_SPREADSHEET'])
