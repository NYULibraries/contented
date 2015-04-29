require File.expand_path('../base.rb', __FILE__)

module Nyulibraries
  module Site_leaf
    module Loaders
			class Empty_Theme < Base
				def initialize
					theme.assets.each { |asset| asset.delete }
				end
			end
		end
	end
end