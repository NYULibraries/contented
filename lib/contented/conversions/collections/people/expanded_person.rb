module Contented
  module Conversions
    module Collections
      module People
        # Combines Person class attributes with google_spreadsheet_person class attributes
        class ExpandedPerson
          extend Forwardable
          attr_reader :person, :google_spreadsheet_person
          def_delegators :@person, :netid, :last_name, :first_name, :work_phone, :email_address, :all_positions_jobs
          def_delegators :@google_spreadsheet_person, :address, :buttons, :departments, :email, :subjectspecialties,
                         :guides, :image, :jobtitle, :keywords, :library, :netid, :phone, :space,
                         :status, :subtitle, :title, :twitter, :publications, :blog, :about, :liaisonrelationship,
                         :linkedin, :parentdepartment

          def initialize(person, google_spreadsheet_person)
            @person = person ? person : Person.new('{}')
            @google_spreadsheet_person = google_spreadsheet_person ? google_spreadsheet_person : GoogleSpreadsheetPerson.new('{}')
          end
        end
      end
    end
  end
end
