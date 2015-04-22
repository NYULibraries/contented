require File.expand_path('../base.rb', __FILE__)

class Empty_Theme < Base

	def initialize
		theme.assets.each { |asset| asset.delete }
	end
	
end

Empty_Theme.new