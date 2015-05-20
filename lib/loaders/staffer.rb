module Nyulibraries
  module SiteLeaf
    module Loaders
      # Staffer returns metafields based on attrs
      class Staffer
        # This array needs to be the exact column as is in spreadsheet.
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
          attrs.each do |key, val|
            metafields << { 'key' => key, 'value' => person.send('' + val).t }
          end
          metafields
        end
      end
    end
  end
end
