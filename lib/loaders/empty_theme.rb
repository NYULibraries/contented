require File.expand_path('../base.rb', __FILE__)

module Nyulibraries
  module SiteLeaf
    module Loaders
      # Empties Out the Entire Theme of siteleaf
      class EmptyTheme < Base
        def initialize
          theme.assets.each(&:delete)
        end
      end
    end
  end
end
