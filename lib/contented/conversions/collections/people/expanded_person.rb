module Contented
  module Conversions
    module Collections
      module People
        # Combines Person class attributes with google_spreadsheet_person class attributes
        class ExpandedPerson
          extend Forwardable
          def_delegators :@person, :netid, :last_name, :first_name, :work_phone, :email_address, :all_positions_jobs
          def_delegators :@google_sheet_person, :address, :buttons, :departments, :email, :expertise,
                         :guides, :image, :jobtitle, :keywords, :library, :netid, :phone, :space,
                         :status, :subtitle, :title, :twitter, :publications, :blog, :about

          def initialize(person, google_person)
            @person = person ? person : Person.new('{}')
            @google_sheet_person = google_person ? google_person : GoogleSpreadsheetPerson.new('{}')
          end
        end
      end
    end
  end
end
