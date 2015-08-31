require File.expand_path('../convert/convert.rb', File.dirname(__FILE__))
require 'figs'
Figs.load
# Loads the siteleaf items
class Loader
  def initialize
    siteleaf_yml = File.open('site/.siteleaf.yml', 'w')
    siteleaf_yml.write("---\n")
    siteleaf_yml.write("api_key: #{ENV['api_key']}\n")
    siteleaf_yml.write("api_secret: #{ENV['api_secret']}\n")
    siteleaf_yml.write("site_id: #{ENV['site_id']}\n")
  end

  def convert_data_to_markdowns
    Conversion::Convert.new.departments
    Conversion::Convert.new.locations
    Conversion::Convert.new.people
    Conversion::Convert.new.services
    Conversion::Convert.new.spaces
  end


end
