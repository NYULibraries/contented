require 'open-uri'
require 'json'
require 'figs'
# require_relative '../Collections/people'
Figs.load

module Conversion
  module Helpers
    # Grabs data from spreadsheet and converts it into a Hash object
    class GoogleSheet
      def self.sheet(sheet_num)
        # Making objects of json file generated from spreadsheet and Remove gsx$ and $t from column and cell names
        # Had to change to 'tx' for capistrano purposes. Capistrano throwing error for single letter obejcts
        return mash_json(open(uri(sheet_num)).read.gsub('"gsx$', '"').gsub('"$t"', '"tx"')).feed.entry unless sheet_num == 6
        # People data needs to be combined with peoplesync data
        people_data
      end

      def self.people_spreadsheet_json
        JSON.parse(open(uri(6)).read.gsub('"gsx$', '"').gsub('"$t"', '"tx"'))['feed']['entry']
      end

      def self.people_data
        # mash_json('{"entry":' +  Collections::People.new(people_spreadsheet_json).to_json.to_json + '}').entry
      end

      def self.mash_json(json_data)
        Hashie::Mash.new(JSON.parse(json_data))
      end

      def self.uri(sheet_num)
        "http://spreadsheets.google.com/feeds/list/#{ENV['GOOGLE_SHEET_KEY']}/#{sheet_num}/public/values?alt=json"
      end
    end
  end
end
