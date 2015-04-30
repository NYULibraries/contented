module Nyulibraries
  module Site_leaf
    module Loaders
      class Staffer
        #This array needs to be the exact column as it is in the spreadsheet.
        def attrs
          {
            'First Name'            => 'firstname',
            'Last Name'             => 'lastname',
            'E-mail'                => 'email',
            'Phone (work)'          => 'workphones',
            'Department'            => 'department',
            'Department 2'          => 'departmentii',
            'Job Title'             => 'jobtitle',
            'Work Space'            => 'workspace',
            'Location'              => 'location',
            'Libguides URL'         => 'libguidesurl',
            'Subject Speciality'    => 'subjects',
            'Photo'                 => 'photo'
          }
        end

        def get_staff(person)
          metafields = []
          attrs.each do |key , value|
            metafields << { 'key' => key, 'value' => person.send(''+value).t }
          end
          metafields
        end
      end
    end
  end
end