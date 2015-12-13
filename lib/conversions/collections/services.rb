require_relative 'services/service_exhibitor'

module Conversions
  module Collections
    module Services
      # Creates an Array of Service objects from JSON data
      def services(json_data)
        JSON.parse(json_data).collect { |service| ServiceExhibitor.new(Service.new(service.to_json)) }
      end
    end
  end
end
