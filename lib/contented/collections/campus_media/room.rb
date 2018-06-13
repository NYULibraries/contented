require 'liquid'
require 'ostruct'
require 'httparty'

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
          published: false,
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
        }

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
              props['type'] === 'feature' ? acc.merge!({ k => props['label'] }) : acc
            end
        end

        def initialize(raw_data, save_location)
          @raw = raw_data.transform_keys(&:to_sym)
          @save_location = save_location
          id = raw[:id]

          attributes = {}
          attributes.merge!(DEFAULTS)
          ATTRIBUTE_KEYS.reduce(attributes) do |attr, attr_key|
            val = raw[attr_key]
            val ? attr.merge!({ attr_key => val }) : attr
          end
          attributes.merge!(Room.rooms_config[id] || {})

          self.room = OpenStruct.new(attributes)
        end

        def filename
          description = raw[:room_description].gsub(' ', '_')
          "#{id}_#{description}"
        end

        def address
          Room.buildings_config.dig(building_id, :address)
        end

        def software
          @room[:'software-image'] ? 'http://library.nyu.edu/software' : nil
        end

        def image
          "https://www.nyu.edu/campusmedia/images/rooms/#{@room[:image]}"
        end

        def instructions
          "https://www.nyu.edu/campusmedia/data/pdfs/smartrooms/#{@room[:instructions]}"
        end

        def equipment
          technology.reduce({}) do |res, item|
            item_data = Room.equipment_with_labels[item]
            if item_data
              res.merge!(item_data["label"] => item_data["description"])
            else
              res
            end
          end
        end

        def features
          technology.map { |item| Room.features_with_labels[item] }.compact
        end

        def title
          room_number = raw[:room_description].split(' ').last
          building_description = raw[:building_description]
          "#{building_description} #{room_number}"
        end

        def method_missing(meth, *args)
          if ATTRIBUTE_KEYS.include?(meth)
            room.send(meth)
          else
            super(meth, *args)
          end
        end

        def save_as_markdown!
          File.write("#{save_location}/#{filename}.markdown", to_markdown)
        end

        private

        attr_accessor :room

        def to_markdown
          liquid_hash = ATTRIBUTE_KEYS.reduce({}) do |hash, attribute|
            hash.merge!({ attribute.to_s => send(attribute) })
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
