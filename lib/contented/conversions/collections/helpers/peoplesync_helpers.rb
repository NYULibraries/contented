module Conversions
  module Collections
    module Helpers
      # Grabs the peoplesync data
      module PeoplesyncHelpers
        def people_json_call
          RestClient::Request.new(method: :get, url: "#{ENV['PEOPLE_JSON_URL']}", user: "#{ENV['PEOPLE_JSON_USER']}",
                                  password: "#{ENV['PEOPLE_JSON_PASS']}",
                                  headers: { accept: :json, content_type: :json }, timeout: 200).execute
        end

        # Peoplesync data can be troublesome thus try getting it 3 time if timeout else is discarded
        def people_json
          tries ||= 3
          response = people_json_call
        rescue
          retry unless (tries -= 1).zero?
          puts 'People JSON retrieval failed after three tries'
          response || '[]'
        end
      end
    end
  end
end
