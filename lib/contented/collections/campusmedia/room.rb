require 'liquid'

module Contented
  module Collections
    class Room
      ROOM_DATA_MAP = {
        # "template_key" => "data_key"
        "description" => "desc",
        # etc.
      }

      BUILDING_DATA_MAP = {
        "address" => "addr",
        # etc.
      }

      def self.template_file
        File.read(File.expand_path(File.dirname(File.dirname(__FILE__))) + '/../contented/templates/camuspmedia/room.markdown')
      end

      def initialize(raw, save_location)
        @data = raw
      end

      def save_as_markdown!
        template = Liquid::Template.parse(Room.template_file)
        to_markdown = template.render(to_hash_for_liquid, { strict_variables: true })
      end

      private

      def namespaced_hash(namespace, data, data_map = nil)
        if data_map.nil?
          return data.transform_keys { |k| "#{namespace}_#{k}" }
        end

        data_map.reduce({}) do |hash, (template_key, data_key)|
          hash["#{namespace}_#{template_key}"] = data[data_key]
          hash
        end
      end

      def to_hash_for_liquid
        room_hash = namespaced_hash("room", @data[:room], ROOM_ATTRS)
        building_hash = namespaced_hash("building", @data[:building], BUILDING_ATTRS)
        constants_hash = namespaced_hash("contant", CONSTANTS)
        {}.merge(room_hash, building_hash, constants_hash)
      end

    end
  end
end
