require 'tiny_tds'
require 'yaml'

module Contented
  module SourceReaders
    class Scheduall
      attr_reader :client, :fetched

      def self.driver
        TinyTds::Client
      end

      def initialize(options)
        @client = Scheduall.driver.new(options)
        @rooms = {}
      end

      def fetch_rooms
        rooms_list =
          begin
            fetch_technologies
          rescue => e
            puts 'Something went wrong during the Scheduall SQL fetch.'
            puts e.message
          end

        @rooms = normalize_rooms_by_id(rooms_list)
      end

      def save_rooms!(save_location)
        File.write("#{save_location}/rooms_data.yml", @rooms.to_yaml)
      end

      def close
        client.close
      end

      def each(&blk)
        rooms.each(&blk)
      end

      def rooms
        @rooms.values
      end

      private

      def fetch_technologies
        execute(<<~SQL).map { |h| h.transform_values(&:strip) }
          USE schedwin
          SELECT DISTINCT
          schedwin.resctlg.resid as id,
          schedwin.resctlg.descript as room_description,
          schedwin.resctlg.type as building_id,
          schedwin.resctlg.typedesc as location,
          schedwin.svcctlg.svcode as technology_id,
          schedwin.svcctlg.servdesc as technology_description
          FROM schedwin.resctlg
          INNER JOIN schedwin.svcctlg ON schedwin.resctlg.resid = schedwin.svcctlg.resid
          WHERE schedwin.resctlg.cat=53
          ORDER BY schedwin.resctlg.typedesc;
        SQL
      end

      def normalize_rooms_by_id(rooms_list)
        starter = Hash.new do |rooms_hash, room_id|
          rooms_hash[room_id] = Hash.new do |room_hash, _k|
            room_hash["technology"] = []
          end
        end

        rooms_list.reduce(starter) do |normalized, room_data|
          room_id = room_data["id"]
          tech_item = room_data["technology_description"]

          normalized[room_id]["technology"] << tech_item
          normalized[room_id].merge!(room_data)
          normalized
        end
      end

      def execute(sql)
        client.execute(sql)
      end
    end
  end
end
