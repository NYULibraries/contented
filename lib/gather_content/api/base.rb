module GatherContent
  module Api
    class Base
      API_KEY = 'e11feb3e-b97c-4d55-a638-5759dd0b15ce'
      USERNAME = 'ba36@nyu.edu'
      API_HOST = 'https://api.gathercontent.com'
      attr_accessor :path

      def initialize
        raise RuntimeError, "Cannot initialize this interface!"
      end

      def get
        connection.get do |request|
          request.url path
          request.params = params
          request.headers['Accept'] = "application/vnd.gathercontent.v0.5+json"
        end
      end

    protected

      def params
        raise RuntimeError, "Expected this to be implemented in a subclass!"
      end

    private

      def connection
        @connection ||= Faraday.new(url: "#{API_HOST}:443") do |faraday|
          faraday.request  :url_encoded
          faraday.request  :basic_auth, USERNAME, API_KEY
          faraday.response :logger
          faraday.adapter  Faraday.default_adapter
        end
      end
    end
  end
end
