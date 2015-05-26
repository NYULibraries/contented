require File.expand_path('../base.rb', __FILE__)
module Nyulibraries
  module SiteLeaf
    module Attributes
      # Staffer returns metafields based on attrs
      class DeptAttr
        # This array needs to be the exact column as is in spreadsheet.
        def attrs
          {
            'Department Name'          => 'departmentname',
            'Room'                    => 'room',
            'Floor'                   => 'floor',
            'Space'                   => 'space',
            'Location'                => 'location',
            'Telephone'               => 'telephone',
            'E-Mail'                  => 'email',
            'What We Do?'             => 'whatwedo',
            'Department Head'         => 'departmenthead',
            'Additional Staff'        => 'additionalstaff',
            'Others We Work With'     => 'othersweworkwith',
            'Twitter'                 => 'twitter',
            'Twitter ID'              => 'twitterid',
            'LibCal Classes ID'       => 'libcalclassesid',
            'Blog'                    => 'blog',
            'Additional Social Media' => 'additionalsocialmedia'
          }
        end

        def tagsets
          {
            'tagset1name'             => 'tagset1terms',
            'tagset2name'             => 'tagset2terms',
            'tagset3name'             => 'tagset3terms'
          }
        end

        def get_dept_meta(dept)
          metafields = []
          attrs.each do |key, val|
            metafields << { 'key' => key, 'value' => dept.send('' + val).t }
          end
          metafields
        end

        def get_dept_tags(d)
          tag = []
          tagsets.each do |k, v|
            next if d.send('' + k).t.empty?
            tag << { 'key' => d.send('' + k).t, 'values' => d.send('' + v).t }
          end
          tag
        end
      end
    end
  end
end
