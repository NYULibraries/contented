module Contented
  module GatherContent
    module Api
      class Base

        def initialize
          raise RuntimeError, "Cannot initialize this interface!"
        end

        def get
          connection.get do |request|
            request.url path
            request.params = params unless params.nil?
            request.headers['Accept'] = "application/vnd.gathercontent.v0.5+json"
          end
        end

      protected

        def params
          raise RuntimeError, "Expected this to be implemented in a subclass!"
        end

        def path
          raise RuntimeError, "Expected this to be implemented in a subclass!"
        end

      private

        def connection
          @connection ||= Faraday.new(url: "#{ENV['gather_content_api_host']}:443") do |faraday|
            faraday.request  :url_encoded
            faraday.request  :basic_auth, ENV['gather_content_api_username'], ENV['gather_content_api_key']
            # faraday.response :logger
            faraday.adapter  Faraday.default_adapter
          end
        end
      end
    end
  end
end
