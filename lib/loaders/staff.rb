require File.expand_path('../base.rb', __FILE__)

class Staff < Base

  def initialize(page_id, spreadsheet)    
    if page_id.empty? || spreadsheet.empty?
      raise ArgumentError.new("Page ID and spreadsheet are required params")
    end            
    create_staff_posts_from_sheet(page_id,spreadsheet)    
  end
 
 private

  def create_staff_posts_from_sheet(page_id,spreadsheet)
  	#first delete all posts from staff page
  	delete_all_posts(page_id)
    spreadsheet_to_json(spreadsheet)['feed']['entry'].each do |person|      
      create_post({
        parent_id: page_id,
        title: person['gsx$firstname']['$t'],
        meta: metafield_mapping(person)
      })      
    end
  end

  def metafield_mapping(person)
    metafields = []
    staff_attrs.each do |key,value|
      metafields << { 'key' => key, 'value' => person[value]['$t'] }
    end
    metafields
  end
 
  def staff_attrs
    {
      'firstname' => 'gsx$firstname',
      'lastname' => 'gsx$lastname',
      'email' => 'gsx$email',
      'phone' => 'gsx$workphones',
      'department' => 'gsx$department',
      'department2' => 'gsx$departmentii',
      'jobtitle' => 'gsx$jobtitle',
      'workspace' => 'gsx$workspace',
      'location' => 'gsx$location',
      'libguides_url' => 'gsx$libguidesurl',
      'subjects' => 'gsx$subjects',
      'photo' => 'gsx$photo'
    }
  end
  
end

Staff.new(ENV['STAFF_PAGE_ID'],ENV['STAFF_SPREADSHEET'])
