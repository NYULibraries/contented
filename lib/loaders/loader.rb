# Loads the siteleaf items
require 'figs'
Figs.load
class Loader
  def initialize
    siteleaf_yml = File.open('site/.siteleaf.yml', 'w')
    siteleaf_yml.write("---\n")
    siteleaf_yml.write("api_key: #{ENV['api_key']}\n")
    siteleaf_yml.write("api_secret: #{ENV['api_secret']}\n")
    siteleaf_yml.write("site_id: #{ENV['site_id']}\n")
  end
end
Loader.new
