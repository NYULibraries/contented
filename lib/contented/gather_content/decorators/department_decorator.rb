module Contented
  module GatherContent
    module Decorators
      class DepartmentDecorator
        attr_accessor :department

        SECTION_MAP = { about: "About Your Dept", contact_info: "Contact Info",
                        related_departments: "Related Dept/Units", people: "People",
                        links: "Links/Guides/Class", social_media: "Social Media", services: "Services" }

        # Department as a Hash
        def initialize(department)
          @department = department
        end

        def title
          @title ||= find_element_by(section: :contact_info, type: 'choice_radio', label: 'Department Name')
        end

        def location
          @location ||= find_element_by(section: :contact_info, type: 'text', label: 'Please provide the name of your building')
        end

        def twitter
          @twitter ||= find_element_by(section: :social_media, type: 'text', label: 'Twitter')
        end

        def facebook
          @facebook ||= find_element_by(section: :social_media, type: 'text', label: 'Facebook')
        end

        def body
          @body ||= find_element_by(section: :about, type: 'text', label: 'What We Do')
        end

        def space(space_array = [])
          @space ||= begin
            space_array << room unless room.nil?
            space_array << area_name unless area_name.nil?
            space_array << "#{floor} #{cardinal_direction}" unless [floor, cardinal_direction].all? {|e| e.nil?}
          end
          return @space.join(", ") unless @space.empty?
        rescue NoMethodError
          nil
        end

        def email
          @email ||= find_element_by(section: :contact_info, type: 'text', label: 'Department Email')
        end

        def phone
          @phone ||= find_element_by(section: :contact_info, type: 'text', label: 'Phone Number')
        end

        # Blog is in the raw format
        #   title: 'Title'
        #   link: 'link'
        #   rss: 'rss'
        # and is output in the format
        #   { title: 'Title', link: 'link', rss: 'rss' }
        def blog
          @blog ||= begin
            raw = find_element_by(section: :social_media, type: 'text', label: 'Blog')
            raw.gsub(/'/,'').gsub(/&nbsp;/,'').split(/\n/).map {|part| part.split(/: /) }.map {|key, value| [key.to_sym, value] }.to_h
          end
        rescue NoMethodError
          nil
        end

        def libcal_id
          @libcal_id ||= find_element_by(section: :links, type: 'text', label: 'LibCal ID Number')
        end

        def libanswers_id
        end

        def subtitle
          @subtitle ||= find_element_by(section: :contact_info, type: 'text', label: 'Acronym or initials used by your department \(if any\)')
        end

        def classes
        end

        def keywords
        end

        def links
          @links ||= quick_link_1.merge(quick_link_2).merge(quick_link_3)
        end

        def buttons
          @buttons ||= begin
            raw = find_element_by(section: :links, type: 'text', label: 'Email address or URL to a form used for appointment requests')
            raw = (matches_email?(raw)) ? "mailto:#{raw}" : raw
            { "Request an Appointment" => "\"#{raw}\"" } unless raw.nil? || raw.empty?
          end
        end

      private

        # Very loose regex for seeing if the request appointment field
        # is actually an email address
        def matches_email?(str)
          !str.match(/^(.+)@(.+)\.(.+)$/).nil?
        end

        def quick_link_1
          @quick_link_1 ||= quick_link("Quick Link 1")
        end

        def quick_link_2
          @quick_link_2 ||= quick_link("Quick Link 2")
        end

        def quick_link_3
          @quick_link_3 ||= quick_link("Quick Link 3")
        end

        def quick_link(label)
          raw = find_element_by(section: :links, type: 'text', label: label)
          title, url = raw.split(': ') unless raw.nil?
          (title && url) ? { "\"#{title}\"" => url.gsub("'",'') } : {}
        end

        def room
          @room ||= find_element_by(section: :contact_info, type: 'text', label: "Room Number")
        end

        def floor
          @floor ||= begin
            floor = find_element_by(section: :contact_info, type: 'choice_checkbox', label: "Floor")
            if floor == "Other"
              floor = find_element_by(section: :contact_info, type: 'text', label: "If you selected 'Other' please write your floor number below")
            end
            floor
          end
        end

        def area_name
          @area_name ||= find_element_by(section: :contact_info, type: 'text', label: "Area Name")
        end

        def cardinal_direction
          @cardinal_direction ||= find_element_by(section: :contact_info, type: 'choice_radio', label: "Cardinal Direction")
        end

        def find_element_by(conditions)
          section = section(SECTION_MAP[conditions[:section]])
          raise ArgumentError, "Valid section is required to find element!" if section.nil?
          label = conditions[:label]
          raise ArgumentError, "Label is required to find element!" if label.nil?
          type_search = section.first["elements"].select {|element| !element["label"].nil? && element["type"] == conditions[:type] && !element["label"].match(/#{label}/).nil? }
          unless type_search.empty?
            search = begin
              if conditions[:type] == 'text'
                type_search.first["value"]
              else
                type_search.first["options"].select {|option| option["selected"] == true }.first["label"]
              end
            end
            # Return nil if result was empty or whitespace only
            unless search.empty? || search.match(/^(\s)+$/)
              # Strip leading and trailing whitespace and wrapping <p> tags
              return format_search_results(search)
            end
          end
        rescue NoMethodError
          return nil
        end

        # The format is so ugly, so make various arbitrary decisions about it
        def format_search_results(original_string)
          original_string.gsub(/<(\/)?p>/,'').gsub(/<br>/,'').gsub(/^(\s+)/,'').gsub(/(\s+)$/,'').gsub(/\u{00a0}/,'').gsub(/\u{200b}/,'').strip
        end

        def section(label)
          config.select { |section| section["label"] == label }
        end

        def config
          @config ||= data["config"]
        end

        def data
          @data ||= department["data"]
        end

      end
    end
  end
end
