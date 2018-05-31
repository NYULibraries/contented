require 'figs'
require 'tiny_tds'
require 'yaml'

module Contented
  module SourceReaders
    class Scheduall
      attr_reader :client, :data

      @@driver = TinyTds::Client

      def initialize(options)
        @client = @@driver.new(options)
        @data = nil
      end

      def rooms
        fetch_technologies
        normalize_rooms_by_id
        merge_config_values
        data
      end

      def close
        client.close
      end

      private

      def fetch_technologies
        @data = execute <<~SQL
          SELECT DISTINCT
          schedwin.resctlg.resid as room_id,
          schedwin.resctlg.descript as room_description,
          schedwin.resctlg.type as building_id,
          schedwin.resctlg.typedesc as room_building_description,
          schedwin.svcctlg.svcode as technology_id,
          schedwin.svcctlg.servdesc as technology_description
          FROM schedwin.resctlg
          INNER JOIN schedwin.svcctlg ON schedwin.resctlg.resid = schedwin.svcctlg.resid
          WHERE schedwin.resctlg.cat=53
          ORDER BY schedwin.resctlg.typedesc;
        SQL

        @data = @data.map { |h| h.transform_values!(&:strip) }
      end

      def normalize_rooms_by_id
        starter = Hash.new do |rooms_hash, room_id|
          rooms_hash[room_id] = Hash.new do |room_hash, _k|
            room_hash["room_technologies"] = []
          end
        end

        @data = @data.reduce(starter) do |normalized, room_data|
          room_id = room_data["room_id"]
          tech_item = room_data["technology_description"].split(' ')[1..-1].join(' ') # remove first descriptor word
          normalized.dig(room_id, "room_technologies") << tech_item
          room_data = room_data.slice("room_description", "building_id", "room_building_description")
          normalized[room_id].merge!(room_data)
          normalized
        end
      end

      def rooms_yaml
        yaml = File.read('config/campusmedia/rooms.yml')
        hash = YAML.safe_load(yaml)

        hash.transform_values! do |props|
          props&.transform_keys! { |k| "room_#{k}" }
        end
      end

      def merge_config_values
        static_rooms_data = rooms_yaml
        buildings = buildings_yaml

        @data = @data.reduce({}) do |res, (id, props)|
          padding = static_rooms_data[id]
          address = buildings.dig(props["building_id"], "address")
          padding&.merge!({ "building_address" => address })

          new_props = props.merge(padding || {})
          res[id] = new_props
          res
        end
      end

      def buildings_yaml
        yaml = File.read('config/campusmedia/buildings.yml')
        YAML.safe_load(yaml)
      end

      def execute(sql)
        client.execute <<~SQL
          USE schedwin
          #{sql}
        SQL
      end
    end
  end
end

# Figs.load
# host = Figs.env["SCHEDUALL_HOST"]
# username = Figs.env["SCHEDUALL_USERNAME"]
# password = Figs.env["SCHEDUALL_PASSWORD"]
#
# scheduall = Contented::SourceReaders::Scheduall.new(host: host, username: username, password: password)
# scheduall.close
