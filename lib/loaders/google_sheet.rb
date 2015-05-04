require File.expand_path('../base.rb', __FILE__)

module Nyulibraries
  module SiteLeaf
    module Loaders
      # Grabs Json from Google Sheets and returns objects
      class GoogleSheet < Base
        def initialize(uri)
          @uri = uri
        end

        def to_json
          # Mash provides you with method-like access.
          # google spreadsheet have this feed and entry sytem
          # remove the $ signs from the names as ruby doesn't allow $
          @to_json ||= Hashie::Mash.new(JSON.parse((open(@uri).read).gsub('"gsx$', '"').gsub('"$t"', '"t"'))).feed.entry
        end
      end
    end
  end
end
