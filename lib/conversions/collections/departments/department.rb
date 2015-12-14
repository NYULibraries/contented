require_relative '../helpers/google_spreadsheet_helpers'

module Conversions
  module Collections
    module Departments
      # Object Representation of Sheet JSON of Departments
      class Department
        include Conversions::Collections::Helpers::GoogleSpreadsheetHelpers
        attr_accessor :title, :subtitle, :location, :space, :email, :phone, :twitter, :facebook, :blog, :libcal_id, :libanswers_id, :links, :classes, :image, :buttons, :keywords, :whatwedo

        def initialize(json_data)
          useful_spreadsheet_hash(JSON.parse(json_data)).each_pair { |var, val| send("#{var.downcase}=", val) if respond_to?(var.downcase) && !val.empty? }
        end
      end
    end
  end
end
