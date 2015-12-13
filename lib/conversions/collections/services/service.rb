require_relative '../helpers/google_spreadsheet_helpers'

module Conversions
  module Collections
    module Services
      # Object Representation of Sheet JSON of services
      class Service
        include Conversions::Collections::Helpers::GoogleSpreadsheetHelpers
        attr_accessor :title, :location, :space, :departments, :type, :topics, :access, :email, :phone, :twitter, :facebook, :blog, :libcal_id, :libanswers_id, :links, :image, :buttons, :keywords, :services

        def initialize(json_data)
          useful_spreadsheet_hash(JSON.parse(json_data)).each_pair { |var, val| send("#{var.downcase}=", val) if respond_to?(var.downcase) && !val.empty? }
        end
      end
    end
  end
end
