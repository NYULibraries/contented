require 'yaml'
require 'open-uri'
require 'hashie'
require 'json'

module Conversion
  module Helpers
    # Removes People to Exclude from the peoplesync using config/people_exclude.yml
    class RectifyPeopleSync
      def remove_people_to_exclude(people)
        fail Error, 'config/people_exclude.yml file deos not exist' unless File.exist? 'config/people_exclude.yml'
        people_exclude = YAML.load_file('config/people_exclude.yml')['people_exclude']
        people.delete_if { |p| people_exclude.include? p['netid']['tx'] }
      end
    end
  end
end
