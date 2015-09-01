require File.expand_path('../convert/convert.rb', File.dirname(__FILE__))
require 'figs'
Figs.load

module Loaders
  # Loads the siteleaf items
  class PeopleLoader
    def initialize
      siteleaf_yml = File.open('tmp_site/.siteleaf.yml', 'w')
      siteleaf_yml.write("---\n")
      siteleaf_yml.write("api_key: #{ENV['api_key']}\n")
      siteleaf_yml.write("api_secret: #{ENV['api_secret']}\n")
      siteleaf_yml.write("site_id: #{ENV['site_id']}\n")
    end

    def convert_people_to_markdown_and_replace_old
      Conversion::Convert.new.people
      FileUtils.rm_rf('tmp_site/_people') if File.directory?('tmp_site/_people')
      FileUtils.cp_r('site/_people/', 'tmp_site/_people') if File.directory?('site/_people')
    end
  end
end
