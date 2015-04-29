module Nyulibraries
  module Site_leaf
    module Loaders
      class Staffer
        #This array needs to be the exact column as it is in the spreadsheet.
        #the json call removes the spaces and makes everything in small case
        def attributes
          Array['firstname','lastname' ,'email','workphones' ,'department' ,'departmentii' , 'jobtitle' , 'workspace','location' ,'libguidesurl' ,'subjects' ,'photo']
        end

        def get_staff(person)
          metafields = []
          attributes.each do |key|
            metafields << { 'key' => key, 'value' => person.send(''+key).t }
          end
          metafields
        end
      end
    end
  end
end