require 'json'
require 'faraday'
module GatherContent
  module Api
    Dir[File.dirname(__FILE__) + '/*.rb'].each do |file|
      require_relative file
    end
  end
end
