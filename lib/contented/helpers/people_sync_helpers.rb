module Contented
  module Helpers
    module PeopleSyncHelpers

      def people_sync_json
        @people_sync_json ||= JSON.parse(stored_people_sync_data)['Report_Entry']
      end

      private

      def people_sync_connection
        @people_sync_connection ||= Faraday.new(url: ENV['people_sync_host']) do |faraday|
          faraday.request  :url_encoded
          faraday.request  :basic_auth, ENV['people_sync_user'], ENV['people_sync_pass']
          faraday.response :logger
          faraday.adapter  Faraday.default_adapter
        end
      end

      def people_sync_response
        response = people_sync_connection.get do |request|
          request.url ENV['people_sync_url']
          request.params = {format: "json"}
          request.headers['Accept'] = "application/json"
        end
      end

      def stored_people_sync_data
        if File.exist?('tmp/people_sync.json')
          people_sync_data = File.open("tmp/people_sync.json", "rb").read
        else
          people_sync_data = people_sync_response.body
          File.write("tmp/people_sync.json", people_sync_data)
        end
        return people_sync_data
      end
    end
  end
end
