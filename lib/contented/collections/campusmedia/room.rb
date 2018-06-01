require 'liquid'

module Contented
  module Collections
    class Room
      # def self.template_file
      #   File.read(File.expand_path(File.dirname(File.dirname(__FILE__))) + '/../contented/templates/camuspmedia/room.markdown')
      # end

      def initialize(raw, save_location)
        @data = raw
      end

      # def save_as_markdown!
      #   template = Liquid::Template.parse(Room.template_file)
      #   to_markdown = template.render(to_hash_for_liquid, { strict_variables: true })
      # end

      private

      # def to_hash_for_liquid
      #   {}.merge(room_hash, building_hash, constants_hash)
      # end

    end
  end
end
