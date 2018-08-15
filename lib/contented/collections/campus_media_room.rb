require 'liquid'
require 'active_support/core_ext/hash'

module Contented
  module Collections
    class CampusMediaRoom
      include Contented::Markdownable
      GIT_URL = "https://raw.githubusercontent.com/NYULibraries/campusmedia-fillins/master/".freeze

      SCHEMA = {
        id: String,
        building_id: String,
        location: String,
        technology: Array,
        features: Array,
        equipment: Array,
        title: String,
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
      }.freeze

      ATTRIBUTES = SCHEMA.keys.freeze

      def self.get_config(key)
        res = Faraday.get("#{GIT_URL}#{key}.yml")
        YAML.safe_load(res.body).deep_symbolize_keys
      end

      def self.rooms_config
        @rooms_config ||= get_config(:rooms).freeze
      end

      def self.buildings_config
        @buildings_config ||= get_config(:buildings).freeze
      end

      def self.technology_config
        @technology_config ||= get_config(:technology).freeze
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

      def initialize(raw_data, save_location)
        @save_location = save_location

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
          self.class.buildings_config[building_id],
          self.class.rooms_config[id],
        )

        @room = OpenStruct.new(attributes)
      end

      def title
        @room.title.blank? ? "NO_TITLE_#{id}" : @room.title
      end

      def published
        technology.join.include?("CM-Installed") ? @room.published : false
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
          item_data = self.class.equipment[item.to_sym]
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
          feature = self.class.features[f.to_sym]
          feature ? list.push(feature[:label]) : list
        end
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

      def save_as_markdown!
        super if published
      end
    end
  end
end
