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
        @data = {}
      end

      def fetch_rooms
        fetch_technologies && @fetched = true unless @fetched
        normalize_rooms_by_id && @normalized = true unless @normalized
        merge_config_values && @merged = true unless @merged
        data
      end

      def close
        client.close
      end

      def each(&blk)
        data.each(&blk)
      end

      private

      def fetch_technologies
        @data = (execute <<~SQL
          USE schedwin
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
        ).map { |h| h.transform_values(&:strip) }
        data
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

          normalized[room_id]["room_technologies"] << tech_item
          room_data = room_data.slice("room_description", "building_id", "room_building_description")
          normalized[room_id] = normalized[room_id].merge(room_data)
          normalized
        end
      end

      def merge_config_values
        @data = @data.reduce({}) do |res, (id, props)|
          building_id = props["building_id"]
          address = buildings_yaml[building_id]&.slice("building_address") || {}
          room_config = rooms_yaml[id] || {}

          merged_props = [room_config, address].reduce(&:merge)

          res.merge!({ id => merged_props })
        end
      end

      def rooms_yaml
        return @rooms_yaml if @rooms_yaml

        yaml = File.read('config/campusmedia/rooms.yml')
        hash = YAML.safe_load(yaml)

        @rooms_yaml = hash.transform_values! do |props|
          props&.transform_keys! { |k| "room_#{k}" }
        end
      end

      def buildings_yaml
        return @buildings_yaml if @buildings_yaml

        yaml = File.read('config/campusmedia/buildings.yml')
        hash = YAML.safe_load(yaml)

        @buildings_yaml = hash.transform_values! do |props|
          props&.transform_keys! { |k| "building_#{k}" }
        end
      end

      def execute(sql)
        client.execute(sql)
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
