require 'ostruct'
require 'liquid'
module Contented
  class Person
    S3_IMAGE_PREFIX = 'https://s3.amazonaws.com/nyulibraries-www-assets/staff-images/'
    ATTRS_FROM_RAW = [
                        :net_id, :first_name, :last_name, :job_title, :departments,
                        :parent_department, :work_phone, :email_address, :building_address_line_1, :location,
                        :name, :nickname, :about_you, :liaison_relationships, :appointment_request_button,
                        :publications_rss, :publications_url, :libguides_author_profile_url, :libguides_account_id,
                        :guide_id_numbers, :orcid, :twitter, :linkedin, :blog_title, :blog_rss, :blog_url, :subject_specialties,
                        :sort_title, :image, :title
                      ]
    attr_accessor :raw, :person, :save_location
    # If parent department is one of these then append it to the departments list as well
    APPEND_PARENT_DEPARTMENTS = ["Knowledge Access & Resource Management Services"]

    def self.template_file
      File.read(File.expand_path(File.dirname(File.dirname(__FILE__))) + '/contented/templates/person.markdown')
    end

    def self.subject_specialties_config
      YAML.load(File.read(File.expand_path(File.dirname(File.dirname(__FILE__))) + '/../config/subject_specialties.yml'))
    end

    def initialize(raw, save_location)
      unless raw.is_a?(Hash)
        raise ArgumentError.new("Expecting a hash as the first parameter")
      end
      @raw = raw
      @save_location = save_location
      # Make self.person an ostruct so that arbitrary calls to attrs,
      # i.e. person.net_id, can be made
      @person = OpenStruct.new(transform_raw_keys_to_downcase)
    end

    # Assumes subject specialties in an unformatted hash with null values
    # and possibly non ASCII values and sets a formatted version
    #
    # Ex:
    #   Raw => {:Area_Cultural_Studies=>nil, :Health=>"Health Sciences, Medicine (Bobst), Nursing", :Social_Sciences=>"<U+200B>"}
    #   Formatted => { :Health => ["Health Sciences", "Medicine (Bobst)", "Nursing"] }
    def subject_specialties
      return {} if person.subject_specialties.nil? || !person.subject_specialties.is_a?(Hash)
      # Remove subject specialty categories nil and empty strings, unfortunately having to
      # account for non ascii data in the raw XML
      @subject_specialties = person.subject_specialties.reject {|ss| person.subject_specialties[ss].nil? || ascii_string(person.subject_specialties[ss]).empty? }
      # Then map these filtered values into a hash and split the values by commas
      # into an array with no non-ascii values or leading/trailing spaces
      @subject_specialties = Hash[@subject_specialties.map { |k, v| [Person.subject_specialties_config[k.to_s], ascii_string(v).split(',').map(&:strip)] }]
      @subject_specialties
    end

    def filename
      @filename ||= "#{first_name.gsub(/ /,'-')}-#{last_name.gsub(/ /,'-')}".downcase
    end

    def title
      @title ||= "#{first_name} #{last_name}"
    end

    def sort_title
      @sort_title ||= "#{last_name}, #{first_name}"
    end

    def image
      @image ||= image_filename if image_exists?
    end

    # If the building address equals the location then there is no Location
    # it is just a repetition of the address in the data
    def location
      @location ||= person.location unless person.building_address_line_1 == person.location
    end

    # Strip out job title category before colon (:)
    #
    # Ex.
    #   "Curator: Health Science Librarian" => "Health Science Librarian"
    def job_title
      @job_title ||= person.job_title&.split(':')&.last&.strip
    end

    # Transform semi-colon (;) delimited string into array
    #
    # Ex.
    #   "Liaison1; Liaison2" => ["Liaison1", "Liaison2"]
    def liaison_relationships
      @liaison_relationships ||= person.liaison_relationships&.split(';')&.map(&:strip)
    end

    # Transform semi-colon (;) delimited string into array and pull out departments
    # prefixed with a "ParentDepartment/" and replace "and" with "&"
    #
    # Ex.
    #   "KARMS/Metadata Production and Management (Adjuncts); Another Department" => ["Metadata Production & Management", "Another Department"]
    def departments
      @departments ||= begin
        # Replace "And|and" with an ampersand (&) and remove everything in parentheses
        departments = person.departments&.gsub(/(a|A)nd/,'&')&.gsub(/\((.+?)\)/, '')
        # Turn list of depratments into an array and remove leading "KARMS/"-like data
        departments = departments&.split(';').map { |d| d.split('/')&.last&.strip }
        # Append parent department if it's in the list
        departments&.push(person.parent_department) if APPEND_PARENT_DEPARTMENTS.include?(person.parent_department)
        # Remove dupes
        departments.uniq
      end
    end

    # Save markdown to file `title`.md
    def save_as_markdown!
      File.write("#{save_location}/#{filename}.markdown", to_markdown)
    end

    # Convert this object to a markdown string
    def to_markdown
      template = Liquid::Template.parse(Person.template_file)
      to_markdown = template.render(to_hash_for_liquid, { strict_variables: true })
    end

    # Convert this object back into a hash but with all the customizations
    # made with instance methods, and make sure to cast keys as strings
    def to_hash_for_liquid
      @to_hash = Hash[ATTRS_FROM_RAW.map {|k| [k.to_s, self.send(k)]}]
      # Process subject_specialties hash into a hash with string keys
      @to_hash["subject_specialties"] = Hash[@to_hash["subject_specialties"].map {|k, v| [k.to_s,v]}]
      @to_hash
    end

  private

    # Do a quick HTTP check to see if this image exists in S3
    def image_exists?
      @image_exists ||= Faraday.head(image_filename)
      @image_exists.status == 200
    end

    def image_filename
      @image_filename ||= "#{S3_IMAGE_PREFIX}#{filename}.jpg"
    end

    def ascii_string(non_ascii_string)
      return non_ascii_string unless non_ascii_string.is_a?(String)
      encoding_options = {
        :invalid           => :replace,  # Replace invalid byte sequences
        :undef             => :replace,  # Replace anything not defined in ASCII
        :replace           => '',        # Use a blank for those replacements
        :universal_newline => true       # Always break lines with \n
      }
      non_ascii_string.encode(Encoding.find('ASCII'), encoding_options).strip
    end

    # Assumes hash with uppercase keys and returns a version with lowercase
    #
    # Ex.
    #   Raw: { :Net_ID => 'abc123' }
    #   Formatted: { :net_id => 'abc123' }
    def transform_raw_keys_to_downcase
      transform = raw
      transform.keys.each do |key|
        transform[key.downcase] = ascii_string(transform.delete(key))
      end
      transform
    end

    # Forward methods onto the person object so calls like
    # self.net_id can be made
    def method_missing(meth, *args)
      if respond_to_missing?(meth)
        person.send(meth)
      else
        super(meth, *args)
      end
    end

    def respond_to_missing?(meth, include_private = false)
      ATTRS_FROM_RAW.include?(meth) || super
    end

  end
end
