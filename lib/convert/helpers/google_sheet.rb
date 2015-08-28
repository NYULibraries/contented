require 'open-uri'
require 'json'
require 'figs'
require_relative 'parse_people'
Figs.load

# Grabs data from spreadsheet and converts it into a Hash object
class GoogleSheet
  def self.sheet(sheet_num)
    # Making objects of json file generated from spreadsheet and Remove gsx$ and $t from column and cell names
    return mash_json(open(uri(sheet_num)).read.gsub('"gsx$', '"').gsub('"$t"', '"t"')).feed.entry unless sheet_num == 6
    # People data needs to be combined with peoplesync data
    people_data
  end

  def people_data
    mash_json(('{"entry":' + ParsePeople.new(uri(sheet_num)).complete_people_data.to_json + '}')).entry
  end

  def mash_json(json_data)
    Hashie::Mash.new(JSON.parse(json_data))
  end

  def self.uri(sheet_num)
    "http://spreadsheets.google.com/feeds/list/#{ENV['GOOGLE_SHEET_KEY']}/#{sheet_num}/public/values?alt=json"
  end
end
