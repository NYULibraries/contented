require 'figs'
require 'tiny_tds'
require 'pry'

module Contented
  module SourceReaders
    class Scheduall
      def self.create_connection_client(options)
        TinyTds::Client.new(options)
      end

      def initialize(options)
        # options: host, username, password
        @options = options
        @client = self.class.create_connection_client(options)
        puts 'Connecting to SQL Server'
        message = @client.active? ? 'Done' : "Client couldn't connect"
        puts message
      end

      def buildings
        # executes sql query for buildings
        # execute <<~SQL
          # SELECT ...
        # SQL
        # .each
        # return tiny_tds result object(.each)
      end

      def classrooms
        # executes sql query for classrooms
        # execute <<~SQL
          # SELECT ...
        # SQL
        # .each
        # return tiny_tds result object(.each)
      end

      def equipment
        # executes sql query for equipment
        # execute <<~SQL
          # SELECT ...
        # SQL
        # .each
        # return tiny_tds result object(.each)
      end

      def close
        client.close
        puts "Client closed"
      end

      def reconnect()
        @client = self.class.create_connection_client(options)
      end

      private

      def execute(sql)
        client.execute(sql)
      end
    end
  end
end
