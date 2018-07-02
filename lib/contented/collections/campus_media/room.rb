require 'liquid'
require 'httparty'
require 'active_support/core_ext/hash'
require 'pry'

module Contented
  module Collections
    module CampusMedia
      class Room
        FILE_ROOT = File.expand_path(File.dirname(File.dirname(__FILE__))) + '/../../..'
        GIT_URL = "https://raw.githubusercontent.com/NYULibraries/campusmedia-fillins/master/".freeze

        SCHEMA = {
          id: String,
          building_id: String,
          technology: Array,
          title: String,
          address: String,
          published: FalseClass, # Actually FalseClass or TrueClass
          capacity: String,
          links: Hash,
          image: String,
          departments: String,
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

        # concatenate all the attribute arrays
        ATTRIBUTES = SCHEMA.keys.freeze

        attr_reader :raw, :save_location

        def self.template_file
          File.read("#{FILE_ROOT}/lib/contented/templates/campusmedia/room.markdown")
        end

        def self.get_config(key)
          res = HTTParty.get("#{GIT_URL}#{key}.yml")
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
            technology_config.reduce({}) do |dict, (id, props)|
              is_equipment = props[:type] === "equipment"
              is_equipment ? dict.merge!(id => props) : dict
            end
          ).freeze
        end

        def self.features
          @features ||= (
            technology_config.reduce({}) do |dict, (id, props)|
              is_feature = props[:type] === 'feature'
              is_feature ? dict.merge!(id => props) : dict
            end
          ).freeze
        end

        def self.defaults
          @defaults ||= (
            Room.rooms_config[:default].reduce({}) do |config, (k, v)|
              v.nil? ? config.merge!(k => SCHEMA[k].new) : config.merge!(k => v)
            end
          ).freeze
        end

        def self.merge_defaults!(attributes)
          # key-value merges
          hash_keys = defaults.select { |k, v| v.is_a? Hash }.keys
          hash_keys.reduce(attributes) do |res, k|
            merged = defaults[k].merge(res[k] || {})
            res.merge!(k => merged)
          end
          # array merge
          array_keys = defaults.select { |k, v| v.is_a? Array }.keys
          array_keys.reduce(attributes) do |res, k|
            merged = defaults[k].concat(res[k] || []).uniq
            res.merge!(k => merged)
          end
          # merge other nil values
          defaults.reduce(attributes) do |res, (k, v)|
            attributes[k].nil? ? attributes.merge!(k => v) : attributes
          end
          attributes
        end

        def initialize(raw_data, save_location)
          @raw = raw_data.deep_symbolize_keys
          @save_location = save_location
          id = raw[:id].to_sym
          attributes = {}.merge(raw)
          attributes.merge!(Room.rooms_config[id] || {})
          Room.merge_defaults!(attributes)
          @room = OpenStruct.new(attributes)
        end

        def title
          @room.title || "NO_DATA_#{id}_#{@raw[:room_description]}"
        end

        def filename
          title.
            downcase.
            gsub(' ', '-').
            squeeze('-').
            chomp('-')
        end

        def address
          Room.buildings_config.dig(building_id.to_sym, :address)
        end

        def equipment
          # returns a dictionary { label => description, ... }
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
          # returns a list of technology features [label1, label2, ...]
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
          p template.errors
          rendered
        end
      end
    end
  end
end
