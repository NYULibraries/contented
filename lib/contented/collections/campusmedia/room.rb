require 'liquid'

module Contented
  module Collections
    class Room
      ROOMS_CONFIG_FILE = 'config/campusmedia/rooms.yml'
      BUILDINGS_CONFIG_FILE = 'config/campusmedia/buildings.yml'

      ATTRIBUTE_KEYS = [
        :room_id,
        :room_title, :room_subtitle, :room_capacity,
        :room_instructions, :room_image,
        :room_departments, :room_floor, :room_type,
        :room_notes, :room_technologies,
        :building_address,
        :constant_form_url, :constant_policies_url,
        :software
      ]

      attr_accessor :raw, :save_location, :room
      attr_reader :id

      def self.template_file
        File.read(File.expand_path(File.dirname(File.dirname(__FILE__))) + '/../contented/templates/camuspmedia/room.markdown')
      end

      def self.rooms_config
        return @rooms_config if @rooms_config
        hash = YAML.safe_load(File.read(ROOMS_CONFIG_FILE))

        @rooms_config = hash.transform_values! do |props|
          props&.transform_keys! { |k| "room_#{k}".to_sym }
        end
      end

      def self.buildings_config
        return @buildings_config if @buildings_config
        hash = YAML.safe_load(File.read(BUILDINGS_CONFIG_FILE))

        @buildings_config = hash.transform_values! do |props|
          props&.transform_keys! { |k| "building_#{k}".to_sym }
        end
      end

      def initialize(raw_yaml)
        @raw = raw_yaml.transform_keys(&:to_sym)
        @id = @raw[:room_id]

        attributes = ATTRIBUTE_KEYS.reduce({}) do |hash, attr_key|
          binding.pry
          hash.merge!({ attr_key => raw[attr_key] })
        end

        p attributes

        @room = OpenStruct.new(attributes)
      end

      def filename
        "#{room_id}"
      end

      def building_address
        building_config.dig(building_id.to_s, "address")
      end

      def room_notes
        room_config.dig(room_id.to_s, "notes")
      end

      def room_capacity
        room_config.dig(room_id.to_s, "notes")
      end

      def software
        room_config.dig(room_id.to_s, "software-image")
      end

      def method_missing(meth, *args)
        if ATTRIBUTE_KEYS.includes?(meth)
          room.send(meth)
        else
          super(meth, *args)
        end
      end

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
