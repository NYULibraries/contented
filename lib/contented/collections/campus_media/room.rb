require 'liquid'
require 'active_support/core_ext/hash'

module Contented
  module Collections
    module CampusMedia
      class Room
        FILE_ROOT = File.expand_path(File.dirname(File.dirname(__FILE__))) + '/../../..'
        GIT_URL = "https://raw.githubusercontent.com/NYULibraries/campusmedia-fillins/master/".freeze

        SCHEMA = {
          id: String,
          building_id: String,
          location: String,
          technology: Array,
          title: String,
          address: String,
          published: FalseClass, # Actually FalseClass or TrueClass
          capacity: String,
          links: Hash,
          image: String,
          floor: String,
          buttons: Hash,
          policies: Hash,
          description: String,
          type: String,
          keywords: Array,
          help: Hash,
          access: String,
          body: String,
          libanswers: Hash,
          features: Array,
          equipment: Array,
        }.freeze

        ATTRIBUTES = SCHEMA.keys.freeze

        attr_reader :raw, :save_location

        def self.template_file
          File.read("#{FILE_ROOT}/lib/contented/templates/campusmedia/room.markdown")
        end

        def self.get_config(key)
          res = Faraday.get("#{GIT_URL}#{key}.yml")
          YAML.safe_load(res.body).deep_symbolize_keys
        end

        def self.rooms_config
          @rooms_config ||= Room.get_config(:rooms).freeze
        end

        def self.buildings_config
          @buildings_config ||= Room.get_config(:buildings).freeze
        end

        def self.technology_config
          @technology_config ||= Room.get_config(:technology).freeze
        end

        def self.equipment
          @equipment ||= (
            technology_config.select { |k, props| props[:type] == 'equipment' }
          ).freeze
        end

        def self.features
          @features ||= (
            technology_config.select { |k, props| props[:type] == 'feature' }
          ).freeze
        end

        def self.defaults
          @defaults ||= (
            Room.rooms_config[:default].reduce({}) do |config, (k, v)|
              v = v.nil? ? SCHEMA[k].new : v
              config.merge!(k => v)
            end
          ).freeze
        end

        def self.merge!(room_attributes, *attributes_list)
          attributes_list.each do |new_attributes|
            room_attributes.merge!(new_attributes) do |k, room_val, new_val|
              if room_val.is_a? Hash
                room_val.merge(new_val)
              elsif room_val.is_a? Array
                room_val | new_val
              else
                new_val || room_val
              end
            end
          end
        end

        def initialize(raw_data, save_location)
          attributes = raw_data.deep_symbolize_keys
          @save_location = save_location

          id = attributes[:id].to_sym
          building_id = attributes[:building_id].to_sym

          Room.merge!(
            attributes,
            Room.defaults,
            Room.buildings_config[building_id],
            Room.rooms_config[id],
          )

          @room = OpenStruct.new(attributes)
        end

        def title
          @room.title || "NO_TITLE_#{id}_#{@room[:room_description]}"
        end

        def filename
          title.
            downcase.
            gsub(' ', '-').
            squeeze('-').
            chomp('-')
        end

        def equipment
          # dictionary of equipment { label => description, ... }
          technology.reduce({}) do |dict, item|
            item_data = Room.equipment[item.to_sym]
            if item_data
              label = item_data[:label]
              description = item_data[:description]
              dict.merge!(label => description)
            end
            dict
          end
        end

        def features
          # list of technology features [label1, label2, ...]
          technology.reduce([]) do |list, f|
            feature = Room.features[f.to_sym]
            feature ? list.push(feature[:label]) : list
          end
        end

        def method_missing(meth, *args)
          ATTRIBUTES.include?(meth) ? @room.send(meth) : super(meth, *args)
        end

        def save_as_markdown!
          File.write("#{save_location}/#{filename}.markdown", to_markdown)
        end

        def to_markdown
          liquid_hash = ATTRIBUTES.reduce({}) do |hash, attribute|
            val = send(attribute)
            val = val.deep_stringify_keys if val.is_a? Hash
            hash.merge!(attribute.to_s => val)
          end

          template = Liquid::Template.parse(Room.template_file)
          rendered = template.render(liquid_hash)
          p template.errors unless template.errors.empty?
          rendered
        end
      end
    end
  end
end
