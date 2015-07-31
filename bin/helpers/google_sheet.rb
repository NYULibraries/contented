require 'open-uri'
# require 'hashie'
require 'json'
require 'figs'
Figs.load

# Grabs data from spreadsheet and converts it into a Hash object
class GoogleSheet
  def self.sheet(sheet_num)
    # Making objects of json file generated from spreadsheet and Remove gsx$ and $t from column and cell names
    Hashie::Mash.new(JSON.parse(open(uri(sheet_num)).read.gsub('"gsx$', '"').gsub('"$t"', '"t"'))).feed.entry
  end

  def self.uri(sheet_num)
    "http://spreadsheets.google.com/feeds/list/#{ENV['GOOGLE_SHEET_KEY']}/#{sheet_num}/public/values?alt=json"
  end
end
