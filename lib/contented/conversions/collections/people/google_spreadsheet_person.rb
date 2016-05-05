module Contented
  module Conversions
    module Collections
      module People
        # Edits the Google Sheet People workbook for markdown conversion
        class GoogleSpreadsheetPerson < Person
          include Conversions::Collections::Helpers::GoogleSpreadsheetHelpers
          attr_accessor :address, :buttons, :departments, :email, :subjectspecialties, :guides,
                        :image, :jobtitle, :keywords, :library, :netid, :phone, :space,
                        :status, :subtitle, :title, :twitter, :publications, :blog, :about,
                        :liaisonrelationship, :linkedin, :parentdepartment

          def initialize(json_data)
            useful_spreadsheet_hash(JSON.parse(json_data)).each_pair { |var, val| send("#{var}=", val) if respond_to?(var) && !val.empty? }
          end
        end
      end
    end
  end
end
