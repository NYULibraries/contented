require File.expand_path('../base.rb', __FILE__)

module Nyulibraries
  module SiteLeaf
    module Loaders
      # Grabs Json from Google Sheets and returns objects
      class GoogleSheet < Base
        def initialize(uri)
          fail ArgumentError, 'uri is a required param' if uri.empty?
          @uri = uri
        end

        def to_json
          # remove the $ signs from the names as ruby doesn't allow $
          JSON.parse(open(@uri).read.gsub('"gsx$', '"').gsub('"$t"', '"t"'))
        end

        def json_data
          # Mash provides you with method-like access.
          # google spreadsheet have this feed and entry sytem
          Hashie::Mash.new(to_json).feed.entry
        end
      end
    end
  end
end