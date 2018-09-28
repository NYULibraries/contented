require 'liquid'
require 'active_support/core_ext/hash'
require 'contented/markdownable'

module Contented
  module Collections
    class CampusMediaRoom
      include Contented::Markdownable
      GIT_URL = "https://raw.githubusercontent.com/NYULibraries/campusmedia-fillins/master/".freeze
      IMAGE_DIRECTORY = ENV['IMAGE_DIRECTORY'] || "https://s3.amazonaws.com/nyulibraries-www-assets/campus-media/classrooms/".freeze

      SCHEMA = {
        id: String,
        url: String,
        building_id: String,
        location: String,
        equipment: Array,
        technology: Array,
        features: Array,
        title: String,
        subtitle: String,
        address: String,
        published: String, # true/false
        capacity: String,
        links: Hash,
        image: String,
        buttons: Hash,
        policies: Hash,
        type: String,
        keywords: Array,
        help: Hash,
        body: String,
        libanswers: Hash,
        display_location: String # true/false
      }.freeze

      ATTRIBUTES = SCHEMA.keys.freeze

      def self.get_config(key)
        res = Faraday.get("#{GIT_URL}#{key}.yml")
        YAML.safe_load(res.body)
          .deep_stringify_keys # Handles keys that are non-strings (i.e. integer IDs)
          .deep_symbolize_keys
      end

      def self.rooms_config
        @rooms_config ||= get_config(:rooms).freeze
      end

      def self.buildings_config
        @buildings_config ||= get_config(:buildings).freeze
      end

      def self.equipment_config
        @equipment_config ||= get_config(:equipment).freeze
      end

      def self.technology
        @technology ||= (
          equipment_config.select { |k, props| props[:type] == 'technology' }
        ).freeze
      end

      def self.features
        @features ||= (
          equipment_config.select { |k, props| props[:type] == 'feature' }
        ).freeze
      end

      def self.defaults
        @defaults ||= rooms_config[:default].freeze
      end

      def self.merge!(room_attributes, *attributes_list)
        attributes_list.each do |new_attributes|
          room_attributes.merge!(new_attributes) do |k, room_val, new_val|
            if new_val.is_a? Hash
              room_val.merge(new_val)
            elsif new_val.is_a? Array
              room_val | new_val
            else
              new_val.nil? ? room_val : new_val
            end
          end
        end
      end

      attr_reader :raw, :save_location

      def initialize(raw_data)
        # gives default empty value to all attributes
        attributes = SCHEMA.reduce({}) do |acc, (k, v)|
          value = raw_data.deep_symbolize_keys[k] || v.new
          acc.merge!({ k => value })
        end

        id = attributes[:id].to_sym
        building_id = attributes[:building_id].to_sym

        self.class.merge!(
          attributes,
          self.class.defaults,
          self.class.buildings_config[building_id] || {},
          self.class.rooms_config[id] || {},
        )

        @room = OpenStruct.new(attributes)
      end

      def title
        @room.title.blank? ? "NO_TITLE_#{id}" : @room.title
      end

      def published
        equipment.join.include?("CM-Installed") ? @room.published : false
      end

      def filename
        url.present? ? url : title.downcase.gsub(',', '').gsub(' ', '-').squeeze('-').chomp('-')
      end

      def technology
        # dictionary of technology { label => description, ... }
        equipment.reduce({}) do |dict, item|
          item_data = self.class.technology[item.to_sym]
          if item_data
            label = item_data[:label]
            description = item_data[:description]
            dict.merge!(label => description)
          end
          dict
        end
      end

      def help
        @room.help.transform_values do |v|
          v.chomp.gsub("\n", "\n    ")
        end
      end

      def features
        # list of equipment features [label1, label2, ...]
        equipment.reduce([]) do |list, f|
          feature = self.class.features[f.to_sym]
          feature ? list.push(feature[:label]) : list
        end
      end

      def buttons
        # Only displays the 'last' of the buttons hash
        [@room.buttons.to_a.last].to_h
      end

      def image
        @room.image.present? ? @room.image : "#{IMAGE_DIRECTORY}#{filename}.jpg"
      end

      def method_missing(meth, *args)
        ATTRIBUTES.include?(meth) ? @room.send(meth) : super(meth, *args)
      end

      def to_liquid_hash
        ATTRIBUTES.reduce({}) do |hash, attribute|
          val = send(attribute)
          val = val.deep_stringify_keys if val.is_a? Hash
          hash.merge!(attribute.to_s => val)
        end
      end

      def save_as_markdown!(options)
        super(options) if published
      end
    end
  end
end
