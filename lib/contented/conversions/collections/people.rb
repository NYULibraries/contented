module Contented
  module Conversions
    module Collections
      autoload :Helpers, 'contented/conversions/collections/helpers'
      module People
        autoload :Person, 'contented/conversions/collections/people/person'
        autoload :ExpandedPerson, 'contented/conversions/collections/people/expanded_person'
        autoload :ExpandedPersonExhibitor, 'contented/conversions/collections/people/expanded_person_exhibitor'
        autoload :GoogleSpreadsheetPerson, 'contented/conversions/collections/people/google_spreadsheet_person'
        autoload :Presenters, 'contented/conversions/collections/people/presenters'
      end
    end
  end
end
