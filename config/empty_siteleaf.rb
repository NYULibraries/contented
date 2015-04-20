require 'siteleaf'
require 'figs'
Figs.load
class Empty_Siteleaf
	def initialize (key,secret,id)
		Siteleaf.api_key    = key
		Siteleaf.api_secret = secret
		theme = Siteleaf::Theme.find_by_site_id(id)
		assets = theme.assets
		assets.each do |asset|
			asset.delete
		end
	end
end

Empty_Siteleaf.new(ENV['SITELFEAF_KEY'],ENV['SITELFEAF_SECRET'],ENV['SITELFEAF_ID'])