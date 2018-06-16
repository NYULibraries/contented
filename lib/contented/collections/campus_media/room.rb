require 'liquid'
require 'ostruct'
require 'httparty'
require 'pry'

module Contented
  module Collections
    module CampusMedia
      class Room
        FILE_ROOT = File.expand_path(File.dirname(File.dirname(__FILE__))) + '/../../..'
        GIT_URL= "https://raw.githubusercontent.com/NYULibraries/campusmedia-fillins/master/".freeze
        ROOMS_CONFIG_FILE = "rooms.yml".freeze
        BUILDINGS_CONFIG_FILE = "buildings.yml".freeze
        TECHNOLOGY_CONFIG_FILE = "technology.yml".freeze

        ATTRIBUTE_KEYS = [
          # attributes for class
          :id, :building_id, :technology,
          # attributes for template
          :address, :title, :capacity,
          :instructions, :software,
          :image, :departments, :floor,
          :features, :equipment, :policies_url,
          :form_url, :notes, :published,
          :type, :help_text, :help_phone,
          :help_email, :access, :keywords,
          :description,
        ].freeze

        DEFAULTS = {
          published: true,
          departments: 'Campus Media',
          policies_url: 'http://library.nyu.edu/policies',
          form_url: 'http://library.nyu.edu/form',
          type: 'Lecture Room',
          help_text: 'Placeholder text about contact info',
          help_phone: '212 222 2222',
          help_email: 'library-help@nyu.edu',
          access: 'NYU Faculty',
          keywords: ['campus', 'media'],
          description: 'Placeholder description text',
        }.freeze

        attr_reader :raw, :save_location

        def self.template_file
          File.read("#{FILE_ROOT}/lib/contented/templates/campusmedia/room.markdown")
        end

        def self.rooms_config
          @rooms_config ||= (
            url = GIT_URL + ROOMS_CONFIG_FILE
            res = HTTParty.get(url)
            yaml = YAML.safe_load(res.body)
            yaml.transform_values do |props|
              props ? props.transform_keys(&:to_sym) : next
            end
          )
        end

        def self.buildings_config
          @buildings_config ||= (
            url = GIT_URL + BUILDINGS_CONFIG_FILE
            res = HTTParty.get(url)
            yaml = YAML.safe_load(res.body)
            yaml.transform_values do |props|
              props ? props.transform_keys(&:to_sym) : next
            end
          )
        end

        def self.technology_config
          @technology_config ||= (
            url = GIT_URL + TECHNOLOGY_CONFIG_FILE
            res = HTTParty.get(url)
            YAML.safe_load(res.body)
          )
        end

        def self.equipment_with_labels
          @equipment_with_labels ||=
            technology_config.reduce({}) do |acc, (k, props)|
              is_equipment = props['type'] === 'equipment'
              is_equipment ? acc.merge!(k => props.slice('label', 'description')) : acc
            end
        end

        def self.features_with_labels
          @features_with_labels ||=
            technology_config.reduce({}) do |acc, (k, props)|
              is_feature = props['type'] === 'feature'
              is_feature ? acc.merge!(k => props['label']) : acc
            end
        end

        def initialize(raw_data, save_location)
          @raw = raw_data.transform_keys(&:to_sym)
          @save_location = save_location
          id = raw[:id]

          attributes = {}.merge!(DEFAULTS)
          ATTRIBUTE_KEYS.reduce(attributes) do |hash, k|
            attributes.merge!(k => raw[k]) unless attributes[k]
          end
          attributes.merge!(Room.rooms_config[id]) if Room.rooms_config[id]
          @room = OpenStruct.new(attributes)
        end

        def filename
          is_i = ->(char) { char =~ /\A[-+]?[0-9]+\z/ }
          adds_hyphen = ->(chars, char, idx) do
            is_i[char] && !is_i[chars[idx + 1]] && idx + 1 < chars.length
          end

          filename =
            raw[:room_description]
              .downcase.squeeze(' ')
              .gsub(/\([^()]*\)/, "") # removes parentheses and contents
              .gsub(/[ |.]/, '-') # hyphenate special chars

          chars = filename.chars
          chars.each_with_index.reduce("") do |str, (char, i)|
            "#{str}#{char}#{'-' if adds_hyphen[chars, char, i]}"
          end
            .squeeze('-').chomp('-')
        end

        def address
          Room.buildings_config.dig(building_id, :address)
        end

        def software
          room[:'software-image'] ? 'http://library.nyu.edu/software' : nil
        end

        def image
          image_val = room[:image]
          image_val ? "https://www.nyu.edu/campusmedia/images/rooms/#{image_val}" : nil
        end

        def instructions
          instructions_val = room[:instructions]
          instructions_val ? "https://www.nyu.edu/campusmedia/data/pdfs/smartrooms/#{room[:instructions]}" : nil
        end

        def equipment
          technology.reduce({}) do |res, item|
            item_data = Room.equipment_with_labels[item]
            if item_data
              label = item_data['label']
              description = item_data['description']
              res.merge!(label => description)
            end
            res
          end
        end

        def features
          technology.reduce([]) do |list, f|
            feature = Room.features_with_labels[f]
            feature ? list.push(feature) : list
          end
        end

        def title
          room_number = raw[:room_description].split(' ').last
          building_description = raw[:building_description]
          "#{building_description} #{room_number}"
        end

        def method_missing(meth, *args)
          ATTRIBUTE_KEYS.include?(meth) ? room.send(meth) : super(meth, *args)
        end

        def save_as_markdown!
          File.write("#{save_location}/#{filename}.markdown", to_markdown)
        end

        private

        attr_accessor :room

        def to_markdown
          liquid_hash = ATTRIBUTE_KEYS.reduce({}) do |hash, attribute|
            hash.merge!(attribute.to_s => send(attribute))
          end

          template = Liquid::Template.parse(Room.template_file)
          rendered = template.render(liquid_hash, { strict_variables: true })
          p template.errors
          rendered
        end
      end
    end
  end
end
