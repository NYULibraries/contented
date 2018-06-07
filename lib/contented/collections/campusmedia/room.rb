require 'liquid'

module Contented
  module Collections
    class Room
      ROOMS_CONFIG_FILE = 'config/campusmedia/rooms.yml'.freeze
      BUILDINGS_CONFIG_FILE = 'config/campusmedia/buildings.yml'.freeze

      ATTRIBUTE_KEYS = [
        :id,
        :title, :capacity, :instructions, :image,
        :departments, :floor, :type,
        :notes, :technologies,
        :building_address, :building_id,
        :constant_form_url, :constant_policies_url,
        :software,
      ].freeze

      attr_accessor :raw, :save_location

      def self.template_file
        File.read(File.expand_path(File.dirname(File.dirname(__FILE__))) +
          '/../contented/templates/camuspmedia/room.markdown')
      end

      def self.rooms_config
        return @rooms_config if @rooms_config
        yaml = YAML.safe_load(File.read(ROOMS_CONFIG_FILE))
        @rooms_config =
          yaml.transform_values do |props|
            props.transform_keys(&:to_sym)
          end
      end

      def self.buildings_config
        return @buildings_config if @buildings_config
        yaml = YAML.safe_load(File.read(BUILDINGS_CONFIG_FILE))
        @buildings_config =
          yaml.transform_values do |props|
            props.transform_keys(&:to_sym)
          end
      end

      def initialize(raw_yaml)
        self.raw = raw_yaml.transform_keys(&:to_sym)

        attributes = ATTRIBUTE_KEYS.reduce({}) do |hash, attr_key|
          hash.merge!({ attr_key => raw[attr_key] })
        end

        self.room = OpenStruct.new(attributes)
      end

      def filename
        "#{id}"
      end

      def address
        Room.buildings_config.dig(building_id, :address)
      end

      def notes
        Room.rooms_config.dig(id, :notes)
      end

      def capacity
        Room.rooms_config.dig(id, :capacity)
      end

      def software
        !!Room.rooms_config.dig(id, :"software-image")
      end

      def image
        Room.rooms_config.dig(id, :image)
      end

      def method_missing(meth, *args)
        if ATTRIBUTE_KEYS.include?(meth)
          room.send(meth)
        else
          super(meth, *args)
        end
      end

      private

      attr_accessor :room

      # def to_markdown
      #   template = Liquid::Template.parse(Room.template_file)
      #   template.render(to_hash_for_liquid, { strict_variables: true })
      # end

      # def save_as_markdown!
      #   File.write("#{save_location}/#{filename}.markdown", to_markdown)
      # end

      private

      def to_hash_for_liquid
        ATTRIBUTE_KEYS.reduce({}) do |hash, attribute|
          hash.merge!({ attribute => send(attribute) })
        end
      end
    end
  end
end
