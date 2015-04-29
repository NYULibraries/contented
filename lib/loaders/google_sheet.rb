require File.expand_path('../base.rb', __FILE__)

module Nyulibraries
  module Site_leaf
    module Loaders
      class Google_Sheet < Base
        def initialize(uri)
          @uri = uri
        end
        def to_json
          # Mash provides you with method-like access. 
          # Since all google spreadsheet have this feed and entry sytem I just got rid of it here
          # Gotta remove the $ signs from the names as ruby doesn't allow $ in names
          @to_json ||=  (Hashie::Mash.new(JSON.parse((open(@uri).read).gsub('"gsx$','"').gsub('"$t"','"t"')))).feed.entry
        end
      end
    end
  end
end
