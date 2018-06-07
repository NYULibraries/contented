require 'figs'
require 'tiny_tds'
require 'yaml'

module Contented
  module SourceReaders
    class Scheduall
      attr_reader :client, :rooms, :fetched

      def self.driver
        TinyTds::Client
      end

      def initialize(options)
        @client = Scheduall.driver.new(options)
        @rooms = {}

        begin
          fetch_rooms
        rescue => e
          puts 'Something went wrong during the Scheduall SQL fetch.'
          puts e.message
        end
      end

      def fetch_rooms
        fetch_technologies
        normalize_rooms_by_id
        rooms
      end

      def close
        client.close
      end

      def each(&blk)
        rooms.each(&blk)
      end

      private

      def fetch_technologies
        @rooms = (execute <<~SQL
          USE schedwin
          SELECT DISTINCT
          schedwin.resctlg.resid as id,
          schedwin.resctlg.descript as description,
          schedwin.resctlg.type as building_id,
          schedwin.resctlg.typedesc as building_description,
          schedwin.svcctlg.svcode as technology_id,
          schedwin.svcctlg.servdesc as technology_description
          FROM schedwin.resctlg
          INNER JOIN schedwin.svcctlg ON schedwin.resctlg.resid = schedwin.svcctlg.resid
          WHERE schedwin.resctlg.cat=53
          ORDER BY schedwin.resctlg.typedesc;
        SQL
        ).map { |h| h.transform_values(&:strip) }
      end

      def normalize_rooms_by_id
        starter = Hash.new do |rooms_hash, room_id|
          rooms_hash[room_id] = Hash.new do |room_hash, _k|
            room_hash["technologies"] = []
          end
        end

        @rooms = @rooms.reduce(starter) do |normalized, room_data|
          room_id = room_data["id"]
          tech_item = room_data["technology_description"].split(' ')[1..-1].join(' ') # remove first descriptor word

          normalized[room_id]["technologies"] << tech_item
          room_data = room_data
          normalized[room_id] = normalized[room_id].merge(room_data)
          normalized
        end
      end

      def execute(sql)
        client.execute(sql)
      end
    end
  end
end
